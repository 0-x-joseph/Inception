## `USER_DOC.md` — User Documentation

### Provided Services

The Inception stack provides a secure, containerized web environment consisting of:

* **Web Server (Nginx):** Handles secure HTTPS traffic and serves the WordPress site.
* **Content Management (WordPress):** The application layer for managing website content.
* **Database (MariaDB):** The persistent storage layer for all WordPress data and users.

### Managing the Project

The project is managed through a simple `Makefile` interface:

* **Start:** `make up` (Builds and starts all services in the background).
* **Stop:** `make down` (Gracefully stops all services).
* **Full Reset:** `make re` (Stops, cleans, and rebuilds everything).

### Accessing the Site

1. **Website:** Open your browser and navigate to `https://login.42.fr` (replace `login` with your intra login).
2. **Admin Panel:** Navigate to `https://login.42.fr/wp-admin` to manage the WordPress site.
* *Note: You must accept the self-signed SSL certificate in your browser to proceed.*

### Credentials & Security

All administrative credentials (passwords, usernames, and database keys) are stored in the `.env` file located in the `srcs/` directory.

* **WordPress Admin:** Located under `WP_ADMIN_USER` and `WP_ADMIN_PASSWORD`.
* **Database Root:** Located under `MYSQL_ROOT_PASSWORD`.

### Health Check

To verify that all services are operational, run:

```bash
docker-compose -f srcs/docker-compose.yml ps

```

A healthy stack will show all services as `Up` or `Running`.

---
