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
