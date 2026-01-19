## `DEV_DOC.md` — Developer Documentation

### Environment Setup

To replicate this environment from scratch:

1. **Prerequisites:** Install `docker`, `docker-compose`, and `make` on a Debian-based system.
2. **Hosts File:** Map the local IP to the project domain:
```bash
echo "127.0.0.1 login.42.fr" >> /etc/hosts

```

3. **Secrets:** Copy the `.env.example` to `.env` in the `srcs/` folder and fill in the required passwords and SSL paths.

### Build and Launch

The infrastructure is strictly managed via the **Root Makefile**:

* **`make` / `make all**`: The default entry point. It ensures the data volumes exist and then triggers `docker compose up -d --build`.
* **`make up`**: Forces a build of the images and starts the containers in detached mode. This is your primary command for deployment.
* **`make down`**: Stops and removes the containers and networks defined in the compose file, but preserves the data volumes.
* **`make re`**: A full reset cycle (`down` followed by `up`). Use this when you make configuration changes to your Nginx or WordPress Dockerfiles.

### Container & Volume Management

* **Logs**: `docker compose -f ./srcs/docker-compose.yml logs -f [service_name]` (Essential for debugging PHP-FPM or Nginx startup errors).
* **Shell Access**: `docker exec -it [container_name] bash` (Used to inspect the internal **Debian** environment, check file permissions, or verify the database state).
* **Full Cleanup (`make fclean`)**: This is a "Nuclear" option. It:

1. Stops and removes all containers and networks.
2. Deletes all images (`--rmi all`).
3. Removes all Docker volumes (`-v`).
4. **Crucial:** Uses `sudo rm -rf` to physically delete the persistent data directories on the host (`/home/joseph/data`).

### Data Persistence

The project uses a dedicated directory on the host to ensure data survives container removals:

* **Root Directory**: `VOLUME_DIR = /home/login/data`
* **Service Volumes**:
* **MariaDB**: Stored at `/home/login/data/mariadb`.
* **WordPress**: Stored at `/home/login/data/wp`.


The `make volumes` target automatically creates these directories with the correct structure before the containers are launched.

---
