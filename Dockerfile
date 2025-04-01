FROM registry.access.redhat.com/ubi8/ubi:latest
# Update system
RUN yum -y update
# Install Tableau Bridge
COPY tableau-bridge.rpm /tmp/
RUN ACCEPT_EULA=y yum install -y /tmp/tableau-bridge.rpm && rm -rf /tmp/*.rp
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
#PAT token directory
RUN mkdir -p /home/dgw_documents
COPY MyTokenFile.txt /home/documents/MyTokenFile.txt
RUN chmod 600 /home/documents/MyTokenFile.txt
CMD ["/bin/bash"]
