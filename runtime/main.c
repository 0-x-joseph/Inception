#define _GNU_SOURCE
#define ROOTFS_PATH "/tmp/rootfs"
#define STACK_SIZE (1024 * 1024)

#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <unistd.h>

int process_cmd(int ac, char **av) {
  if (ac < 3) {
    printf("Usage: %s run <command> <arg1> <arg2> ...\n", av[0]);
    return (1);
  }
  char *cmd = av[1];

  if (strcmp(cmd, "run") != 0) {
    printf("%s: unsupported command\n", av[0]);
    return (1);
  }
  return (0);
}

int container_setup(void) {
  if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) < 0) {
    perror("mount private");
    return 1;
  }

  sethostname("Joseph", 6);

  if (chroot(ROOTFS_PATH) < 0) {
    perror("chroot");
    return 1;
  }
  if (chdir("/") < 0) {
    perror("chdir");
    return 1;
  }

  mkdir("/proc", 0555);
  mount("proc", "/proc", "proc", 0, NULL);

  return (0);
}

int container_teardown(void) {
  umount("/proc");
  rmdir("/proc");
  return (0);
}

int container_main(void *data) {
  char **cmd = (char **)data;
  int pid;
  int status = 0;

  if (container_setup() != 0)
    return (1);
  pid = fork();

  if (pid == -1) {
    perror("fork");
    return (1);
  }
  if (pid == 0) {
    execvp(cmd[0], cmd);
    perror("execvp");
  }
  while (wait(&status) > 0)
    ;
  container_teardown();
  exit(WEXITSTATUS(status));
}

int main(int ac, char **av) {
  int status = 0;
  char stack[STACK_SIZE];
  int pipefd[2];

  if (process_cmd(ac, av) != 0)
    return (1);

  pipe(pipefd);

  int pid =
      clone(container_main, stack + STACK_SIZE,
            CLONE_NEWNS | CLONE_NEWPID | CLONE_NEWIPC | CLONE_NEWUTS | SIGCHLD,
            &av[2]);

  if (pid == -1) {
    perror("clone");
    return (1);
  }

  waitpid(pid, &status, 0);
  exit(WEXITSTATUS(status));
}
