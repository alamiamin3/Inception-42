# Inception
This is a walkthrough for the inception project from 1337 curriculum
# Project Overview:

The inception project is about setuping a small infrastructure (mariadb + Wordpress & php + nginx)using docker containers , this is the diagram of the results we want to get:

![**schema-inception**](https://user-images.githubusercontent.com/54292953/147146268-a616f39a-3f16-41f8-80c9-db5494c3dfe7.png)

![Different tools used in this project](https://miro.medium.com/v2/resize:fit:1400/1*MiiTlPl89vwpv_bvFUjacQ.jpeg)

Different tools used in this project
# Bare Metal vs VMs vs  Containers
in this chapter we will see difference between Containers virtual machines and bare metal(physical computers), and we will see how containers work
## Bare Metal:

Before virtualization was invented, all programs ran directly on the host system. The terminology many people use for this is "bare metal". While that sounds fancy and scary.

With a bare metal system, the operating system, binaries/libraries, and applications are installed and run directly onto the physical hardware.

This is simple to understand and direct access to the hardware can be useful for specific configuration, but can lead to:

- Hellish dependency conflicts
- Low utilization efficiency
- Large blast radius
- Slow start up & shut down speed (minutes)
- Very slow provisioning & decommissioning (hours to days)

![**Bar Metal**](https://courses.devopsdirective.com/_next/image?url=%2Fdocker-beginner-to-pro%2F01-03-bare-metal.jpg&w=1200&q=75)

Bar Metal 

## Virtual Machines (VMs):

Virtual machines use a system called a "hypervisor" that can carve up the host resources into multiple isolated virtual hardware configuration which you can then treat as their own systems (each with an OS, binaries/libraries, and applications).

This helps improve upon some of the challenges presented by bare metal:

- No dependency conflicts
- Better utilization efficiency
- Faster startup and shutdown (minutes)
- Faster provisioning & decommissioning (minutes)

![**VM**](https://courses.devopsdirective.com/_next/image?url=%2Fdocker-beginner-to-pro%2F01-03-virtual-machine.jpg&w=1200&q=75)

VM

## Containers:

Containers are similar to virtual machines in that they provide an isolated environment for installing and configuring binaries/libraries, but rather than virtualizing at the hardware layer containers use native linux features (cgroups + namespaces )  to provide that isolation while still sharing the same kernel **(we will talk about this in the next chapter)**.

This approach results in containers being more "lightweight" than virtual machines, but not providing the save level of isolation:

- No dependency conflicts
- Even better utilization efficiency
- Even faster startup and shutdown (seconds)
- Even faster provisioning & decommissioning (seconds)
- Lightweight enough to use in development!

    ![**container**](https://courses.devopsdirective.com/_next/image?url=%2Fdocker-beginner-to-pro%2F01-03-container.jpg&w=1200&q=75)
    
    

# The Idea behind containers

Containers are an abstraction over several linux technologies, and the main ones are c-groups and namespaces.

**C-groups** : or control groups is a mechanism used by linux to track and organize processes regardless of wether these processes are containers or not, c-groups are typically used to associate processes with resources and limit or prioritize resources utilization, and those resources include:

- **CPU:** Limit CPU usage.
- **Memory:** Limit memory usage.
- **I/O:** Limit disk I/O.
- **Network:** Limit network bandwidth.

With cgroups, we are  to specify that a container should be able to use (for example):

- Use up to XX% of CPU cycles (cpu.shares)
- Use up to YY MB Memory (memory.limit_in_bytes)

**Namespaces**: it’s another linux mechanism concerned with controlling visibility and accessibility of resources.

A **namespace** wraps a global system resource in an abstraction that makes it appear to the processes within the namespace that they have their own isolated instance of the global resource.

Changes to the global resource are visible to other processes that are members of the namespace, but are invisible to other processes, the main namespaces used by a container runtime are PID, Network, MNT, UTS and IPC  namespaces.

in this section we will try to discover how a container runtime (i.e docker daemon ) uses those namespaces to isolate resources for a specific container 

- **PID namespace**:
    
    It’s used to isolate Processes IDs , Each container gets its own PID namespace, meaning processes inside a container have a separate PID space from the host and other containers. This allows each container to have its own init process (PID 1) and prevents processes in different containers from seeing or interacting with each other.
    
- **NET namespace**:
    
    Each container gets its own network namespace, which includes its own network interfaces, IP addresses, routing tables, and port numbers. This allows containers to have isolated network environments. Docker runtime for example can create virtual Ethernet devices to connect containers to the host network or to other containers.
    
- **MNT namespace**:
    
    It isolates filesystem mount points, so when a container is created it has it own MNT namespace, providing it with a separate filesystem view from the host and other containers.
    
- **UTS namespace**:
    
    Each container gets its own UTS namespace, allowing it to have a unique hostname and domain name. This is useful for network identification within the containerized environment.
    
- **IPC namespace**:
    
    It’s used to isolate inter-process communication resources, such as System V IPC and POSIX message queues, where each container gets its own IPC namespace, preventing processes inside the container from interacting with IPC resources outside the container. This isolation ensures that shared memory segments, message queues, and semaphores are not accessible across container boundaries.
    

# **Docker overview**
in this part we will see what is docker and how it works
## What is Docker

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications. By taking advantage of Docker's methodologies for shipping, testing, and deploying code, you can significantly reduce the delay between writing code and running it in production.

### **Docker architecture**

Docker uses a client-server architecture. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker containers. The Docker client and daemon can run on the same system, or you can connect a Docker client to a remote Docker daemon. The Docker client and daemon communicate using a REST API, over UNIX sockets or a network interface. Another Docker client is Docker Compose, that lets you work with applications consisting of a set of containers.

### **The Docker daemon**

The Docker daemon (`dockerd`) listens for Docker API requests and manages Docker objects such as images, containers, networks, and volumes. A daemon can also communicate with other daemons to manage Docker services.

### **The Docker client**

The Docker client (`docker`) is the primary way that many Docker users interact with Docker. When you use commands such as `docker run`, the client sends these commands to `dockerd`, which carries them out. The `docker` command uses the Docker API. The Docker client can communicate with more than one daemon.

### **Docker registries**

A Docker registry stores Docker images. Docker Hub is a public registry that anyone can use, and Docker looks for images on Docker Hub by default. You can even run your own private registry.

When you use the `docker pull` or `docker run` commands, Docker pulls the required images from your configured registry. When you use the `docker push` command, Docker pushes your image to your configured registry.

### **Docker objects**

When you use Docker, you are creating and using images, containers, networks, volumes, plugins, and other objects. This section is a brief overview of some of those objects.

### **Images**

An image is a read-only template with instructions for creating a Docker container. Often, an image is based on another image, with some additional customization. For example, you may build an image which is based on the `ubuntu` image, but installs the Apache web server and your application, as well as the configuration details needed to make your application run.

You might create your own images or you might only use those created by others and published in a registry. To build your own image, you create a Dockerfile with a simple syntax for defining the steps needed to create the image and run it. Each instruction in a Dockerfile creates a layer in the image. When you change the Dockerfile and rebuild the image, only those layers which have changed are rebuilt. This is part of what makes images so lightweight, small, and fast, when compared to other virtualization technologies.

### **Containers**

A container is a runnable instance of an image. You can create, start, stop, move, or delete a container using the Docker API or CLI. You can connect a container to one or more networks, attach storage to it, or even create a new image based on its current state.

By default, a container is relatively well isolated from other containers and its host machine. You can control how isolated a container's network, storage, or other underlying subsystems are from other containers or from the host machine.

A container is defined by its image as well as any configuration options you provide to it when you create or start it. When a container is removed, any changes to its state that aren't stored in persistent storage disappear.

![**Illustration for the Docker architecture**](https://docs.docker.com/guides/images/docker-architecture.webp)

**Illustration for the Docker architecture**

### Example docker run command

The following command runs an `ubuntu` container, attaches interactively to your local command-line session, and runs `/bin/bash`.

`$ docker run -i -t ubuntu /bin/bash`

When you run this command, the following happens (assuming you are using the default registry configuration):

1. If you don't have the `ubuntu` image locally, Docker pulls it from your configured registry, as though you had run `docker pull ubuntu` manually.
2. Docker creates a new container, as though you had run a `docker container create` command manually.
3. Docker allocates a read-write filesystem to the container, as its final layer. This allows a running container to create or modify files and directories in its local filesystem.
4. Docker creates a network interface to connect the container to the default network, since you didn't specify any networking options. This includes assigning an IP address to the container. By default, containers can connect to external networks using the host machine's network connection.
    
    Docker assigns IP addresses to containers using its networking subsystem. When a container is started, Docker creates a virtual network interface for the container and assigns an IP address to that interface. Docker uses different networking modes to manage how containers communicate with each other and with the host system.
    
    In the default configuration, Docker uses a bridge network to connect containers. When you start a container, Docker creates a bridge network interface on the host system, typically named **`docker0`**, and assigns an IP address range to this bridge network. Containers are then connected to this bridge network, and each container is assigned an IP address from the range defined for the bridge network.
    
    The default IP address range for the bridge network is usually **`172.17.0.0/16`**, but this can be customized in Docker's configuration.
    
5. Docker starts the container and executes `/bin/bash`. Because the container is running interactively and attached to your terminal (due to the `i` and `t` flags), you can provide input using your keyboard while Docker logs the output to your terminal.
6. When you run `exit` to terminate the `/bin/bash` command, the container stops but isn't removed. You can start it again or remove it.

### Docker Volumes:

Volumes are the preferred mechanism for persisting data generated by and used by Docker containers. While [bind mounts](https://docs.docker.com/storage/bind-mounts/) are dependent on the directory structure and OS of the host machine, volumes are completely managed by Docker. Volumes have several advantages over bind mounts:

- Volumes are easier to back up or migrate than bind mounts.
- You can manage volumes using Docker CLI commands or the Docker API.
- Volumes work on both Linux and Windows containers.
- Volumes can be more safely shared among multiple containers.
- Volume drivers let you store volumes on remote hosts or cloud providers, encrypt the contents of volumes, or add other functionality.
- New volumes can have their content pre-populated by a container.
- Volumes on Docker Desktop have much higher performance than bind mounts from Mac and Windows hosts.

Volumes are first-class citizens in Docker. Among other things, this means they are
their own object in the API, and they have their own docker volume sub-command.

Use the following command to create a new volume called myvol.

```docker
$ docker volume create myvol

```

By default, Docker creates new volumes with the built-in local driver. As the name
suggests, local volumes are only available to containers on the node they’re created
on.

### Dockerfile:

A Dockerfile is a text file containing a series of instructions on how to build a Docker image. Docker uses this file to automate the creation of a container image, which is a lightweight, standalone, and executable software package that includes everything needed to run a piece of software, including the code, runtime, libraries, environment variables, and configuration files.

This is an example of a Dockerfile for a custom Node.js image

```docker
# Use the official Node.js image as the base image
FROM node:14

# Create and change to the app directory
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json files
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 8080

# Define the command to run the application
CMD ["node", "app.js"]

```

To build this image we can run :

```docker
docker build -t mynodeapp .
```

And to run a container from this  image:

```docker
docker run -p 8080:8080 mynodeapp
```

But what if our container depends on other containers? We need to build the image and run its instance in the same way each time. It’s tedious, isn’t it? Thanks to docker-compose we will explore the magic of this tool in the next chapter

### docker-compose:

Docker Compose allows us to define and manage multi-container Docker applications with ease. With a simple [YAML file](https://spacelift.io/blog/yaml), we can configure our application’s services, networks, and volumes, making it much simpler to build and run our entire application stack with a single command.

Compose lets you encapsulate all the services as a “stack” of containers that’s specific to your app. Using Compose to bring up the stack starts every container using the config values you’ve set in your file. This improves developer ergonomics, supports reuse of the stack in multiple environments, and helps prevent accidental misconfiguration.

This is a simple docker-compose file for the same image from the example we saw before:

```docker
version: '3.8' #Specifies the version of the Docker Compose file format

services: #Defines the services that make up your application.
  web:  #The name of the service.
    build: .    #Specifies that Docker Compose should use the Dockerfile in the current directory to build the image.
    ports: #Maps port 8080 on the host to port 8080 in the container.
      - "8080:8080"
    volumes: #Mounts the current directory on the host to /usr/src/app in the container, allowing for code changes on the host to be reflected inside the container.
      - .:/usr/src/app
    environment: # Sets environment variables inside the container
      - NODE_ENV=production

```

there’s a lot of utilities you can use in the docker-compose you can find them [**here](https://docs.docker.com/compose/)** 

in the next part we will see how to build the images for each  service.

# Docker Images configuration and setup

let’s begin by configuring the nginx image:

## Nginx:

First of all let’s give a short definiton of nginx and what is used for, So Nginx is a high-performance web server, reverse proxy server, and load balancer. It's designed to handle high traffic loads and is known for its stability, rich feature set, simple configuration, and low resource consumption.

Nginx can be useful in a lot of situation such as :

- A web server. This is the most common because of its performance and scalability.
- A reverse proxy server. NGINX does this by directing the client’s request to the appropriate back-end server.
- A load balancer. It automatically distributes your network traffic load without manual configuration.
- An API gateway. This is useful for request routing, authentication, and exception handling.
- A firewall for web applications. This protects your application by filtering incoming and outgoing network requests on your server.

In our project we will use nginx as a primary web server and also as a fastcgi proxy (we will talk about this later), also we ll try to configure our webserver to communicate with incoming requests via the HTTPS protocol

### The HTTPS protocol:

HTTPS (HyperText Transfer Protocol Secure) is an extension of HTTP (HyperText Transfer Protocol) that provides secure communication over a computer network, particularly the Internet. It ensures that the data sent between a client (such as a web browser) and a server is encrypted and secure from interception or tampering.

HTTPS uses SSL (Secure Sockets Layer) or its successor TLS (Transport Layer Security) to encrypt the data transmitted between the client and the server. SSL/TLS are  cryptographic protocols designed to provide secure communication over a computer network.

The main responsibility of SSL is to ensure that the data transfer between the communicating systems is **secure and reliable**. It is the standard security technology that is used for encryption and decryption of data during the transmission of requests.

Now let’s discover how HTTPS works:

1. **The three-way handshake** : The client establish a tcp connection with the server, it also known as  the **three-way handshake**. in this process the client sends a TCP segment with the **SYN** (synchronize) flag set to the server, then the server receives the SYN segment from the client and responds with a TCP segment that has both the **SYN** and **ACK** (acknowledge) flags set, and finally the client receives the **SYN-ACK** segment from the server and responds with a TCP segment that has the **ACK** flag set. You can learn more about this [**here](https://www.geeksforgeeks.org/tcp-3-way-handshake-process/).**
2. **The certificate check**: in this step the client inform the server about the TLS versions and the ciphers supported (**this step is called client hello**), after that the server respond with a confirmation message, telling the client if its able to secure a connection based on the informations sent and what kind of TLS and cipher it will use.
3. **Certificate Exchange:** The server’s certificate is sent to the client. The client uses the CA’s public key to verify the server's certificate. If the certificate is valid and trusted, the client proceeds with the handshake.
4. **Key Exchange:** The client and server use the agreed-upon cipher suite to exchange keys. The client generates a "pre-master secret," encrypts it with the server's public key (from the certificate), and sends it to the server. Both the client and server use the pre-master secret, along with the previously exchanged random values, to generate the "session keys" used for encrypting the data in the session.
5. **Finished Messages:** The client sends a "Finished" message encrypted with the session key, indicating that it has completed its part of the handshake. The server responds with its own "Finished" message, also encrypted with the session key. This confirms that the server has completed its part of the handshake.
6. **Secure Communication:** After the handshake is complete, both the client and server use the established session keys to encrypt and decrypt the data exchanged between them. This ensures that the communication is secure and private.
7. **Session Resumption (Optional):** To improve performance in future connections, the client and server may use session resumption techniques to skip some parts of the handshake for subsequent connections. This involves using previously established session information to quickly resume secure communication.
8. **Data Transmission:** With the secure connection established, the client and server exchange application data over the encrypted channel. This data is protected from eavesdropping and tampering due to the encryption provided by TLS.
9. **Connection Termination:** When the communication is complete, either the client or server can initiate the termination of the secure connection. The connection is closed gracefully, ensuring that any remaining data is securely transmitted and that the session is properly ended

Now let’s talk about FastCGI and how Nginx can act as a FastCGI proxy.

### What is FastCGI?

FastCGI is a protocol for interfacing interactive programs with a web server. It is an evolution of the original Common Gateway Interface (CGI), designed to improve performance and scalability. Unlike CGI, which creates a new process for each request (leading to inefficiencies due to process creation and destruction overhead), FastCGI keeps processes alive between requests. This reduces the overhead and allows for better performance and resource utilization.

FastCGI works by maintaining a pool of persistent processes that handle multiple requests over their lifetime. These processes are managed by a FastCGI application server (such as PHP-FPM for PHP), which communicates with the web server using the FastCGI protocol.

### How Nginx Can Act as a FastCGI Proxy

Here’s how Nginx acts as a FastCGI proxy:

1. **Client Request:**
    - When a client requests a dynamic resource (e.g., a PHP script), Nginx receives the request.
2. **Request Routing:**
    - Based on the configuration, Nginx determines that the request should be passed to a FastCGI server for processing. This is typically defined using a location block in the Nginx configuration file.
3. **Proxying to FastCGI:**
    - Nginx uses the FastCGI protocol to pass the request to the FastCGI application server (e.g., PHP-FPM). It sends the necessary request parameters, such as the script to be executed and any input data.
4. **FastCGI Processing:**
    - The FastCGI application server processes the request and generates the dynamic content. The application server runs the script, interacts with databases if needed, and produces the response.
5. **Response Handling:**
    - The FastCGI application server sends the generated content back to Nginx. Nginx then forwards this content to the client.

![**-**](https://miro.medium.com/v2/resize:fit:1100/format:webp/1*8qHYUvfe3EV0HH0VwH5-Ig.jpeg)

Now let’s see how we can achieve this. Nginx allows users to configure how it handles incoming requests using its configuration file located at `/etc/nginx/nginx.conf`. This file includes a variety of directives that control the web server's behavior and operation,  and can include additional configuration files for specific sites or applications, typically located in `/etc/nginx/sites-available/` or `/etc/nginx/conf.d/` . Nginx configurations are organized into server blocks, each defining how requests for a specific domain or path are handled, for this project i used this configuration.

```bash
server {
    # Listen on port 443 for HTTPS traffic
    listen 443 ssl;
    listen [::]:443 ssl;

    # Specify the SSL certificate and private key files for HTTPS
    ssl_certificate /etc/nginx/ssl/certs/nginx-selfsigned.crt;  # Path to the SSL certificate
    ssl_certificate_key /etc/nginx/ssl/certs/nginx-selfsigned.key;  # Path to the SSL certificate key

    # Define the root directory for serving files
    root /var/www/html;  # Directory where your website's files are located

    # Specify default index files to serve when a directory is requested
    index index.php index.html index.htm;

    # Block to handle PHP requests
    location ~ \.php$ {
        # Split the request URI into script and path info for FastCGI processing
        fastcgi_split_path_info ^(.+\.php)(/.+)$;

        # Pass the PHP requests to the FastCGI server (wordpress container) running on port 9000
        fastcgi_pass wordpress:9000;  

        # Define the default script to run if a directory is requested
        fastcgi_index index.php;

        # Include standard FastCGI parameters
        include fastcgi_params;  # This file typically defines common FastCGI parameters

        # Define the path to the PHP script being executed
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # Full path to the PHP script
        fastcgi_param SCRIPT_NAME $fastcgi_script_name;  # Script name for the FastCGI process
    }
}

```

Now let’s create a DockerFile to build the nginx’s container image 

```bash
# Start from the official Debian Bullseye image as the base image
FROM debian:bullseye

# Create the directory for storing SSL certificates
RUN mkdir -p /etc/nginx/ssl/certs/

# Update the package list, install Nginx, and OpenSSL
RUN apt-get update && apt-get install -y nginx && apt install openssl -y

# Copy the Nginx configuration file from the local directory to the container's configuration directory 
#(this the config file we talked about before)
COPY ./conf/default.conf /etc/nginx/conf.d/

# Copy the tools directory from the local directory to the container's /tools directory
# here will be the script that will run nginx 
COPY ./tools /tools

# Set the working directory to /tools
WORKDIR /tools

# Give execute permissions to the script.sh file located in the /tools directory
RUN chmod +x script.sh

# Run the script.sh file when the container starts
CMD ./script.sh

```

as we see in the Dockerfile there is a script, that it will be executed when the container starts

```bash
#!/bin/bash

chown -R www-data:www-data /var/www/html
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${CERTS_}nginx-selfsigned.key -out ${CERTS_}nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=MA" 
nginx -g "daemon off;"
```

**`chown -R www-data:www-data /var/www/html`**: This command changes the ownership of the `/var/www/html` directory and all its contents (`-R` stands for recursive) to the `www-data` user and group. This ensures that the Nginx web server, which runs as `www-data`, has the proper permissions to access and manage the files in the web root directory.

**www-data** is a standard user and group in Unix-like operating systems, commonly used by web server software like Apache and Nginx. Here's a brief overview of its purpose:

### **Purpose of www-data**

1. **Web Server User**:
    - www-data is the default user under which web server processes (such as Apache or Nginx) run. This user has limited permissions to improve security by restricting access to sensitive system files and directories.
2. **Permissions**:
    - Files and directories related to the web server, such as website content and log files, are often owned by the www-data user and group. This ensures that the web server can read and write necessary files while preventing unauthorized access.
3. **Security**:
    - Running web servers as www-data helps minimize the impact of potential security breaches. If an attacker manages to exploit a vulnerability, the permissions and capabilities of the www-data user are limited, reducing the risk of system-wide damage.

**`openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${CERTS_}nginx-selfsigned.key -out ${CERTS_}nginx-selfsigned.crt -subj "/C=MO/L=KH/O=1337/OU=student/CN=MA"`**

: This command generates a self-signed SSL certificate using OpenSSL. The options used are:

- **`req`**: Command to create and process certificate requests.
- **`x509`**: Specifies that you want to create a self-signed certificate rather than a certificate signing request (CSR).
- **`nodes`**: Tells OpenSSL not to encrypt the private key (meaning no passphrase is required).
- **`days 365`**: Sets the validity period of the certificate to 365 days.
- **`newkey rsa:2048`**: Creates a new RSA key with a length of 2048 bits.
- **`keyout ${CERTS_}nginx-selfsigned.key`**: Specifies the filename for the generated private key. `${CERTS_}` is an environment variable prefixing the path.
- **`out ${CERTS_}nginx-selfsigned.crt`**: Specifies the filename for the generated certificate. `${CERTS_}` is an environment variable prefixing the path.
- **`subj "/C=MO/L=KH/O=1337/OU=student/CN=MA"`**: Defines the subject field of the certificate, which includes details such as country (C), locality (L), organization (O), organizational unit (OU), and common name (CN).

**`nginx -g "daemon off;"`**: Starts the Nginx service with the `-g` flag to specify a global directive. The `daemon off;` directive tells Nginx to run in the foreground rather than as a background daemon. This is useful in Docker containers, where you want the process to run in the foreground to keep the container alive.

**Now let’s see how to configure the mariadb image** 

## Mariadb:

MariaDB is an open-source relational database management system (RDBMS) that is a fork of MySQL. It was created by the original developers of MySQL, led by Michael "Monty" Widenius, in response to Oracle's acquisition of MySQL. MariaDB aims to maintain high compatibility with MySQL while providing additional features and improvements.

let’s start by the DockerFile that will build the image for the mariadb container:

```bash
# Use the Debian Bullseye image as the base image for this Docker container
FROM debian:bullseye

# Update the package list and install the MariaDB server package
# - `apt-get update`: Updates the list of available packages and their versions
# - `apt-get install -y mariadb-server`: Installs the MariaDB server package and automatically confirms the installation
RUN apt-get update && \
    apt-get install -y mariadb-server 

# Copy the custom MariaDB server configuration file to the container
# - `./conf/50-server.cnf` is the local configuration file for MariaDB
# - `/etc/mysql/mariadb.conf.d/50-server.cnf` is the target location in the container where the configuration file will be placed
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy the contents of the local 'tools' directory to the '/tools' directory in the container
# This directory may contain scripts or other files needed for setting up or configuring MariaDB
COPY ./tools /tools

# Set the working directory to '/tools'
# All subsequent commands will be executed from this directory
WORKDIR /tools

# Make the 'script.sh' script executable
# - `chmod +x script.sh`: Grants execute permissions to the 'script.sh' file
RUN chmod +x script.sh

# Specify the command to run when the container starts
# - `CMD ./script.sh`: Executes the 'script.sh' script, which likely contains setup or initialization commands for MariaDB
CMD ./script.sh

```

for the 50-server.cnf i used the default config file i just updated the bind-adress directive to 0.0.0.0 , this is useful when working with containers, which make the mariadb container able to communicate with different network interfaces .

and for the script that i used in order to launch the mariadb server and create a new database

```bash
#!/bin/bash

# Start the MariaDB service
# This command initializes and starts the MariaDB server process
service mariadb start

# Pause the script for 5 seconds
# This gives MariaDB some time to start up fully before running subsequent commands
sleep 5

# Create a new database if it doesn't already exist
# - `mariadb -e`: Executes the given SQL command
# - `CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;`: Creates a database named $MYSQL_DATABASE if it does not already exist
mariadb -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;"

# Create a new user if it doesn't already exist
# - `CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';`: Creates a user with the specified username and password
mariadb -e "CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"

# Grant all privileges on the new database to the newly created user
# - `GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';`: Grants all permissions on the specified database to the user
mariadb -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';"

# Reload the grant tables to ensure that the new privileges take effect
# - `FLUSH PRIVILEGES;`: Reloads the privilege tables in MariaDB
mariadb -e "FLUSH PRIVILEGES;"

# Shutdown the MariaDB server
# - `mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown`: Uses `mysqladmin` to shut down the MariaDB server process as the root user with the provided root password
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# Start MariaDB in safe mode with specified options
# - `mysqld_safe`: Starts MariaDB server in safe mode, which helps in case of problems during startup
# - `--port=3306`: Specifies the port for the MariaDB server to listen on (default is 3306)
# - `--bind-address=0.0.0.0`: Binds the server to all available network interfaces, allowing connections from any IP address
# - `--datadir='/var/lib/mysql'`: Specifies the data directory where MariaDB stores its data files
mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'

```

**Now let’s see how to configure the wordpress image** 

## Wordpress:

WordPress is a popular open-source content management system (CMS) used to create and manage websites and blogs. Here's an overview of what it is and its key features:

- **Content Management System (CMS)**:
    - WordPress is a CMS that provides a user-friendly interface for creating, managing, and publishing digital content. It simplifies the process of building and maintaining a website without needing extensive technical knowledge.
- **Open Source**:
    - WordPress is open-source software, meaning its source code is freely available and can be modified by anyone. This fosters a large community of developers and users who contribute to its development and support.
- **PHP and MySQL**:
    - WordPress is built using PHP, a server-side scripting language, and MySQL, a relational database management system. It stores website content and settings in a MySQL database and generates web pages dynamically using PHP.(in this project we will use mariadb which is an extension of the MySQL project . We will talk about it later)

Now let’s create a DockerFile to build the wordpress+php-fpm container image 

```bash
# Use the official Debian Bullseye image as the base image for this Docker image
FROM debian:bullseye

# Update the package list and install the necessary packages
# - php-fpm: PHP FastCGI Process Manager, which handles PHP requests
# - curl: A tool for transferring data with URLs (commonly used for testing and downloading)
# - php-mysqli: PHP extension for MySQL database interactions
# - sudo: Utility to allow users to run commands with superuser privileges
RUN apt-get update && apt-get install -y \
    php-fpm \
    curl \
    php-mysqli \
    sudo

# Create the directory where PHP-FPM will store runtime data such as PID files and socket files
RUN mkdir -p /run/php

# Copy the PHP-FPM pool configuration file from the host machine to the container
# This file configures how PHP-FPM handles requests
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/

# Copy the tools directory from the host machine to the /tools directory in the container
COPY ./tools /tools

# Set the working directory to /tools
# Commands that follow will be executed in this directory
WORKDIR /tools

# Change the permissions of script.sh to make it executable
# This is necessary if the script needs execution rights
RUN chmod +x script.sh

# Set the default command to execute when the container starts
# This will run the script.sh file located in /tools
CMD ./script.sh

```

as before in the nginx configuration we will talk about the configuration file of PHP-FPM

### What is PHP-FPM

**PHP-FPM** (PHP FastCGI Process Manager) is a PHP implementation designed to handle requests efficiently and effectively

### How PHP-FPM Works:

1. **Request Handling**:
    - When a web server (like Nginx) receives a request for a PHP script, it passes the request to PHP-FPM.
    - PHP-FPM handles the execution of the PHP script using its worker processes.
2. **Configuration**:
    - PHP-FPM is configured through a configuration file (typically `www.conf`), where you can set parameters like process management options, logging settings, and resource limits.

for this project i used the default www.conf i just updated the ‘listen’ directive from
**`listen = /var/run/php5-fpm.sock`**  to **`listen = 9000`**

this update is made due to the fact that the services (nginx and and php-fpm are isolated each one is running on a container , so php-fpm will not reiceives requests within the same container instead it will reiceive them over a network. We will talk later how to configure a docker network that let containers communicate with each others and also communicate with the host).

Now we will talk about the script i used to run a wordpress .

```bash
#!/bin/bash

# Pause execution for 5 seconds to ensure that the mariadb service is running
sleep 5

# Change directory to /var/www/html where the WordPress files will be managed
cd /var/www/html

# Remove all existing files and directories in /var/www/html
rm -rf *

# Download the WP-CLI PHP archive from the official repository
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Make the downloaded wp-cli.phar file executable
chmod +x wp-cli.phar

# Move the executable wp-cli.phar to /usr/local/bin and rename it to 'wp'
# This makes WP-CLI globally accessible as the 'wp' command
mv wp-cli.phar /usr/local/bin/wp

# Create a directory for WP-CLI cache files
mkdir -p /var/www/.wp-cli/cache/

# Change ownership of the cache directory to the 'www-data' user and group
chown -R www-data:www-data /var/www/.wp-cli/cache/

# Change ownership of the current directory (and its contents) to the 'www-data' user and group
chown -R www-data:www-data .

# Set permissions for all files and directories in the current directory to 755 (readable and executable by everyone, writable by the owner)
chmod -R 755 .

# Execute WP-CLI commands as the 'www-data' user, which is the user running the web server processes

# Download the latest WordPress core files
sudo -u www-data wp core download

# Create the WordPress configuration file with database details
# Uses environment variables for database name, user, password, and host
sudo -u www-data wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=maria-db

# Install WordPress with the provided details such as site URL, title, admin username, password, and email
sudo -u www-data wp core install --url=https://$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL

# Create a new WordPress user with editor role and the provided email and password
sudo -u www-data wp user create $WP_USER $WP_USER_EMAIL --role=editor --user_pass=$WP_PASS

# Start PHP-FPM in the foreground (prevents the container from exiting)
php-fpm7.4 -F

```

in the next chapter we will talk how to configure volumes and network for each container.

## Docker compose and volumes and network configuration

First of all lets talk about docker compose and what problems can solve and how it works

### **Introduction to Docker Compose**

Docker Compose is a tool for defining and running multi-container Docker applications. With Docker Compose, you can manage complex applications that consist of multiple interconnected services, each running in its own container. Instead of managing each container individually, Docker Compose provides a way to manage the entire application stack with a single configuration file and set of commands.

### **Problems Docker Compose Solves**

1. **Multi-Container Management**:
    - **Problem**: Managing multiple Docker containers individually can be cumbersome. You need to manually start, stop, and link each container, which can be error-prone and inefficient.
    - **Solution**: Docker Compose allows you to define all your application's services, networks, and volumes in a single `docker-compose.yml` file. You can then start, stop, and manage all these services together with a few simple commands.
2. **Service Dependencies**:
    - **Problem**: Many applications have dependencies between services (e.g., a web server depends on a database). Managing these dependencies manually can be complex.
    - **Solution**: Docker Compose handles service dependencies through its configuration file. You can specify the order in which services should be started, ensuring that dependencies are available when needed.
3. **Configuration Management**:
    - **Problem**: Configuring individual containers for various environments (development, testing, production) can lead to inconsistencies and errors.
    - **Solution**: Docker Compose allows you to define environment-specific configurations in your `docker-compose.yml` file. You can use multiple configuration files or override settings based on the environment, ensuring consistency across different stages of development.
4. **Networking**:
    - **Problem**: Setting up networking between containers manually can be complex and error-prone.
    - **Solution**: Docker Compose simplifies container networking by automatically creating a default network for your services. Services can communicate with each other using container names as hostnames, making it easier to manage internal communication.
5. **Volume Management**:
    - **Problem**: Managing persistent data and shared volumes across containers can be challenging.
    - **Solution**: Docker Compose allows you to define and manage volumes in your `docker-compose.yml` file. This ensures that data is persisted and shared correctly between containers.
6. **Scaling Services**:
    - **Problem**: Scaling individual services manually can be complex, especially if you need to scale up or down multiple services simultaneously.
    - **Solution**: Docker Compose supports scaling services with simple commands. You can easily adjust the number of container instances for each service as needed.

### **How Docker Compose Works**

1. **Configuration File**:
    - Docker Compose uses a YAML file named `docker-compose.yml` to define the services, networks, and volumes for your application. This file specifies how each service should be built, what images to use, which ports to expose, and how the services are connected.
2. **Commands**:
    - **`docker-compose up`**: Starts the services defined in the `docker-compose.yml` file. It builds images if necessary and creates the required containers.
    - **`docker-compose down`**: Stops and removes the containers, networks, and volumes created by `docker-compose up`.
    - **`docker-compose build`**: Builds or rebuilds the services defined in the `docker-compose.yml` file.
    - **`docker-compose ps`**: Lists the running containers for the services defined in the configuration file.
    - **`docker-compose logs`**: Displays logs from the services, helping with debugging and monitoring.
3. **Lifecycle Management**:
    - Docker Compose simplifies the lifecycle management of your application. You can start, stop, and scale services with a few commands, making it easier to handle complex applications.

as we saw the docker compose make it easy to manage multiple containers at once

for this project i used this docker compose file.

```bash
version: '3.8'  # Specify the Docker Compose file version

services:
  nginx:
    container_name: nginx  # Name the container as 'nginx'
    build: ./requirements/nginx/.  # Build the Docker image from the Dockerfile in this directory
    restart: always  # Automatically restart the container if it stops
    ports:
      - "443:443"  # Map port 443 of the container to port 443 on the host
    volumes:
      - wordpress:/var/www/html/  # Mount the 'wordpress' volume to '/var/www/html/' in the container
    networks:
      - inception  # Connect the container to the 'inception' network
    depends_on:
      - wordpress  # Ensure 'wordpress' service is started before 'nginx'
    env_file:
      - .env  # Load environment variables from the '.env' file

  wordpress:
    container_name: wordpress  # Name the container as 'wordpress'
    depends_on:
      - maria-db  # Ensure 'maria-db' service is started before 'wordpress'
    build: ./requirements/wordpress/.  # Build the Docker image from the Dockerfile in this directory
    restart: always  # Automatically restart the container if it stops
    ports:
      - "9000:9000"  # Map port 9000 of the container to port 9000 on the host
    volumes:
      - wordpress:/var/www/html/  # Mount the 'wordpress' volume to '/var/www/html/' in the container
    networks:
      - inception  # Connect the container to the 'inception' network
    env_file:
      - .env  # Load environment variables from the '.env' file

  maria-db:
    container_name: maria-db  # Name the container as 'maria-db'
    build: ./requirements/mariadb/.  # Build the Docker image from the Dockerfile in this directory
    restart: always  # Automatically restart the container if it stops
    env_file:
      - .env  # Load environment variables from the '.env' file
    ports:
      - "3306:3306"  # Map port 3306 of the container to port 3306 on the host
    volumes:
      - mariadb:/var/lib/mysql  # Mount the 'mariadb' volume to '/var/lib/mysql' in the container
    networks:
      - inception  # Connect the container to the 'inception' network

networks:
  inception:
    name: inception  # Define a custom network named 'inception'

volumes:
  wordpress:
    name: wordpress  # Define a volume named 'wordpress'
    driver: local  # Use the local volume driver
    driver_opts:
      type: none  # Use a bind mount
      o: bind  # Mount a host directory as a volume
      device: /home/aalami/data/wordpress  # Path on the host to mount

  mariadb:
    name: mariadb  # Define a volume named 'mariadb'
    driver: local  # Use the local volume driver
    driver_opts:
      type: none  # Use a bind mount
      o: bind  # Mount a host directory as a volume
      device: /home/aalami/data/mariadb  # Path on the host to mount

```

 the `networks` section defines the networks that will be used by the services.
Each service that you define in the `services` section can be connected to one or more networks. in our case all the services are connected to the ‘inception’ network, by default when we don’t specify a network type , we are telling  docker daemon to setup a bridge network (there is different types of  networks that docker can use you can read about them [here](https://docs.docker.com/network/))

**Bridge Network** :

- **Description**: This is the default network type when you don't specify any type. It provides basic isolation and is used for communication between containers on the same host.
- **Use Case**: Suitable for single-host deployments where you want isolated networks for containers.

Now let’s talk about Volumes.

Volumes are used to persist data and share data between containers and the host machine.

The volume configuration we used maps specific directories from the host machine into Docker containers, ensuring data persistence and direct access between the host and the containerized applications.

### **Volume Definition**

- **`name: [Volume-Name]`**: This is the identifier used to reference this volume in the Docker Compose configuration.
- **`driver: local`**: This specifies that the volume will use the `local` driver, which is the default and typically used for local storage on the host machine.
- **`driver_opts:`**: This section allows you to provide additional options to the volume driver.
    - **`type: none`**: Specifies that no special volume type is used. This means that the volume will directly map to a directory on the host machine.
    - **`o: bind`**: This option indicates that the volume is a bind mount, meaning it maps a directory on the host machine directly into the container.
    - **`device: [path/to/directory/to/map]`**: This is the path on the host machine that will be mounted into the container.
