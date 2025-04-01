# tableau-bridge-linux
This repository provides a step-by-step guide and Docker configuration for installing and setting up Tableau Bridge on a Linux-based system using containers.

## 📌 Overview
This project provides a **step-by-step guide** to deploying **Tableau Bridge** on a Linux server using Docker. Tableau Bridge enables secure data connections between **on-premises** databases and **Tableau Cloud**.

## 🏗 Prerequisites
Before you begin, ensure you have:

- **OS:** Ubuntu 20.04+
- **Memory:** At least **16 GB RAM**
- **Disk Space:** Minimum **40GB** available
- **Docker Installed** ([Guide](https://docs.docker.com/get-docker/))
- **Tableau Cloud Account** with a **Creator Role**
- **Personal Access Token (PAT)** from Tableau Cloud
- **Required Database Drivers** (PostgreSQL, SAP HANA, etc.)

## 📂 Project Structure
```
📂 tableau-bridge-linux
│── 📄 Dockerfile            # Docker setup for Tableau Bridge
│── 📄 README.md             # Main installation guide
│── 📄 setup.sh              # (Optional) Script for automated setup
│── 📂 drivers/              # JDBC or SAP drivers (if required)
│── 📂 docs/                 # Additional documentation
```
## 🚀 Installation & Deployment

### **1️⃣ Install Docker**
```sh
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin
```

### **2️⃣ Set Up Token**
Create a **Personal Access Token (PAT) File**:
```sh
touch MyTokenFile.txt
vim MyTokenFile.txt
```
Add the following content:
```json
{"MyToken": "your_token_here"}
```
Save & exit: `ESC -> :wq -> ENTER`

### **3️⃣ Build the Docker Image**
Create a `Dockerfile`:
```dockerfile
FROM registry.access.redhat.com/ubi8/ubi:latest

# Update system
RUN yum -y update

# Download Tableau Bridge RPM file
RUN curl -L -o /tmp/tableau-bridge.rpm "https://downloads.tableau.com/tssoftware/TableauBridge-20243.24.1010.1014.x86_64.rpm"

# Install Tableau Bridge
RUN ACCEPT_EULA=y yum install -y /tmp/tableau-bridge.rpm && rm -rf /tmp/*.rpm

# Set environment variables
ENV LC_ALL=en_US.UTF-8

# Create JDBC driver directory
RUN mkdir -p /opt/tableau/tableau_driver/jdbc/

# Download PostgreSQL JDBC Driver
RUN curl -o /opt/tableau/tableau_driver/jdbc/postgresql-42.7.4.jar \
 https://jdbc.postgresql.org/download/postgresql-42.7.4.jar

# Copy SAP HANA & other JDBC drivers
COPY ngdbc.jar /opt/tableau/tableau_driver/jdbc/
RUN chmod 755 /opt/tableau/tableau_driver/jdbc/ngdbc.jar

# PAT token directory
RUN mkdir -p /home/documents
COPY MyTokenFile.txt /home/documents/MyTokenFile.txt
RUN chmod 600 /home/documents/MyTokenFile.txt

# Set the default command
CMD ["/bin/bash"]
```
Build the Docker Image:
```sh
docker build -t tableau_bridge_image .
```

### **4️⃣ Run Tableau Bridge Container**
Start the container:
```sh
docker run -dit --name tableau_bridge_container tableau_bridge_image
```
Verify it’s running:
```sh
docker ps
```
Expected output:
```
CONTAINER ID   IMAGE                 COMMAND       CREATED        STATUS        PORTS   NAMES
a1b2c3d4e5f6   tableau_bridge_image  "/bin/bash"   10 minutes ago Up 10 min      -      tableau_bridge_container
```

### **5️⃣ Start Tableau Bridge Worker**
Run:
```sh
/opt/tableau/tableau_bridge/bin/run-bridge.sh -e --patTokenId="Mytoken" --userEmail="admin@tableau.com" --client="myBridgeAgent" --site="mySite" --patTokenFile="/home/jSmith/Documents/MyTokenFile.txt" --poolId="1091bfe4-604d-402a-b41c-29ae4b85ec94"
```

## 🔧 Troubleshooting
- **Check container logs:**
```sh
docker logs tableau_bridge_container
```
- **Ensure database drivers are correctly placed in:**
  ```sh
  /opt/tableau/tableau_driver/jdbc/
  ```
- **Verify network connectivity to Tableau Cloud.**

## 📎 Additional Notes
- Tableau Bridge supports multiple **database drivers**. Download the necessary ones from [Tableau Driver Support](https://www.tableau.com/support/drivers).
- If your database connection **fails**, check Tableau logs inside the container:
  ```sh
  /opt/tableau/tableau_bridge/logs/
  ```
