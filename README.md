# Container Lab: From Syscalls to Orchestration

A deep-dive into the Linux Kernel primitives that power modern containerization. This repository contains two main components:

1. **`runtime/`**: A minimalist container runtime built from scratch in **C**.
2. **`project/`**: A production-ready, multi-container infrastructure (**Inception**) using Docker and Docker Compose.

---

## Part 1: Under the Hood (C Runtime)

Before using Docker, I built a custom runtime to understand how the Linux Kernel isolates processes. Using the `clone()` syscall and manual mount management, I implemented the four pillars of isolation:

### The 4 Pillars of Isolation in `main.c`:

* **PID Isolation (`CLONE_NEWPID`):** Tricking the process into thinking it is PID 1.
* **Hostname Isolation (`CLONE_NEWUTS`):** Changing the hostname within the container without affecting the host.
* **Mount Isolation (`CLONE_NEWNS`):** Creating a private mount namespace to hide the host's filesystem.
* **Network/IPC Isolation:** Preventing the container from seeing host IPC and network interfaces.

### Core Logic

In `container_setup()`, we "jail" the process using:

1. **`chroot`**: Changing the root directory to a restricted `ROOTFS_PATH`.
2. **`mount`**: Creating a private `/proc` so tools like `ps` only see containerized processes.

> **Explore the Runtime:** [View C Implementation](./runtime/)

---

## Part 2: The Infrastructure (Inception)

Building on the concepts learned in the runtime, this project implements a secure, interconnected web stack using **Docker Compose** and **Debian Bullseye**.

### Architecture

* **Nginx:** Secured with TLSv1.2/v1.3.
* **WordPress:** Managed via PHP-FPM and WP-CLI.
* **MariaDB:** Database with dedicated persistent volumes.
* **Network:** Strictly isolated bridge network with no external exposure except for 443.

### Documentation Links

For detailed instructions on setup, administration, and development, see the dedicated guides:

* **[Project README](./project/README.md)** — Architectural choices and design.
* **[User Documentation](./project/USER_DOC.md)** — How to start, stop, and access services.
* **[Developer Documentation](./project/DEV_DOC.md)** — Environment setup and volume management.

---

## Getting Started

### 1. Running the C Runtime (`mini-runc`)

Since the runtime uses `chroot`, you must provide a Root File System (rootfs).

**Step A: Prepare the environment**

1. Download a minimalist rootfs (e.g., Alpine Linux) or export one from Docker:
```bash
mkdir -p /tmp/rootfs
docker export $(docker create alpine) | tar -C /tmp/rootfs -xvf -

```

2. Ensure `ROOTFS_PATH` in `main.c` matches your directory:
```c
#define ROOTFS_PATH "/tmp/rootfs"

```

**Step B: Build and Run**

```bash
cd runtime
make
# This will spawn an isolated shell inside your new rootfs
sudo ./mini-runc run /bin/sh

```

### 2. Launching `Inception` Project

```bash
cd project
make up

```

---

## 💡 What I Learned

* **Kernel Primitives:** The difference between a VM (Hardware Virtualization) and a Container (OS-level Isolation).
* **Networking:** How Docker uses IPTables and bridge interfaces to route traffic securely.
* **Persistence:** Managing the lifecycle of data using Docker Volumes vs Bind Mounts.
* **Security:** Implementing SSL/TLS and preventing container breakouts through restricted user privileges.

---
