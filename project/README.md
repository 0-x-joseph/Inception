# Inception - 1337

**This project has been created as part of the 42 curriculum by ybouryal**

## Description

### Project Description

#### Design Choices & Sources

The infrastructure is built using a **Microservices Architecture**, where each component resides in its own isolated container.

- **Base Image: Debian Bullseye/Bookworm.** * *Choice:* While Alpine is smaller, **Debian** was chosen for its superior stability, robust package manager (`apt`), and extensive documentation. It provides a more "production-ready" environment for complex services like MariaDB and WordPress.
- **Custom Build:** Every image is built from scratch using a dedicated `Dockerfile`. No pre-made "ready-to-use" images from Docker Hub were used, ensuring full control over the binary versions and security patches.
- **Entrypoint Scripts:** Custom `.sh` scripts handle the runtime configuration (like database initialization and user creation) to ensure the system is "ready-to-go" upon deployment.

#### Architectural Comparisons

##### 1. Virtual Machines vs. Docker

- **VMs:** Operate on a **Hypervisor** and include a full Guest OS. They are resource-heavy and slow to boot because they virtualize the hardware layer.
- **Docker:** (Our Choice) Uses the **Host Kernel** and leverages Linux namespaces/cgroups for process isolation. It is significantly more lightweight, as containers share the host's resources while remaining logically separate.

##### 2. Secrets vs. Environment Variables

- **Environment Variables:** Visible in `docker inspect` and process logs. Suitable for public configs like database names.
- **Secrets:** (Our Choice for sensitive data) Encrypted at rest and only mounted into the container's memory at runtime (typically in `/run/secrets/`). We use these for DB passwords and SSL keys to prevent leakage into the image layers.

##### 3. Docker Network vs. Host Network

- **Host Network:** The container shares the host’s IP and port space directly, offering zero network isolation.
- **Docker Network (Bridge):** (Our Choice) Creates a private, virtual network. Containers can communicate with each other via service names (DNS), but only specified ports (e.g., 443) are mapped to the host, providing a critical layer of perimeter security.

##### 4. Docker Volumes vs. Bind Mounts

- **Bind Mounts:** Maps a specific path on the host to the container. They are dependent on the host’s file structure and can cause permission issues across different machines.
- **Docker Volumes:** (Our Choice) Managed entirely by Docker in a dedicated area of the filesystem. They are safer, more portable, and more efficient for data persistence in a containerized environment.


### Project Sources & Structure

The project is organized to ensure a clear separation between the Docker orchestration and the individual service configurations.

```text
.
├── Makefile                # Automation of the build/deploy process
|-- secrets/                # Secrets directory used by Docker Compose
├── srcs/
│   ├── docker-compose.yml  # The docker compose config file
│   ├── .env                # Environment variables
│   └── requirements/       # Service-specific configurations
│       ├── mariadb/        # MariaDB Dockerfile and setup scripts
│       ├── nginx/          # Nginx Dockerfile and SSL/TLS config
│       └── wordpress/      # WordPress Dockerfile and PHP-FPM config

```

## Instructions

### Prerequisites

* **OS:** Linux (Debian/Ubuntu preferred) or a VM.
* **Tools:** `docker`, `docker-compose`, `make`.
* **Domain:** Your local `/etc/hosts` must map `127.0.0.1` to `login.42.fr`.

### Installation & Execution

The project is fully automated via a `Makefile`.

1. **Clone the repository:**
```bash
git clone https://github.com/0-x-joseph/inception.git && cd inception

```


2. **Initialize the Infrastructure:**
This command creates the necessary data directories on the host, builds the images, and launches the containers in detached mode.
```bash
make up

```


3. **Verify the Services:**
```bash
docker-compose ps

```


4. **Clean Up:**
To stop and remove all containers, networks, and images:
```bash
make clean

```

### Security Note

All traffic is routed through **HTTPS (Port 443)**. Direct access to the database or WordPress PHP-FPM ports from the host machine is restricted by the container network policy.

## Ressources

- [Build Your Own Docker](https://codingchallenges.fyi/challenges/challenge-docker)
- [HTTPS, SSL, TLS & Certificate Authority](https://www.youtube.com/watch?v=EnY6fSng3Ew)
- [Nginx](https://www.youtube.com/watch?v=7VAI73roXaY)
- [Docker under the hood](https://www.youtube.com/watch?v=sK5i-N34im8)
