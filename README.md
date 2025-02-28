## PostgreSQL Installation, Security, Upgrade, High Availability, and Backup/Restore 
## Subrahmanyeswarao Karri
This README provides a comprehensive guide to installing PostgreSQL, securing your installation, upgrading PostgreSQL, setting up high availability, and configuring backup/restore procedures. 

# Table of Contents 
# Installation 
# Security 
# Upgrade 
# High Availability 
# Backup and Restore 

Installation 
Follow these steps to install PostgreSQL on an Ubuntu system. 

1. Update the Package List 
sudo apt update 

2. Install PostgreSQL 
sudo apt install postgresql postgresql-contrib 
 
3. Verify the Installation 
sudo systemctl status postgresql 
 
4. Switch to the PostgreSQL User 
sudo -i -u postgres 
 
5. Access PostgreSQL 
psql 
 
Security 
Securing your PostgreSQL installation is essential for both performance and data protection. 

1. Set a Strong Password for the postgres User 
psql -c "ALTER USER postgres PASSWORD 'yourpassword';" 
 
2. Configure pg_hba.conf for Secure Authentication 

Open pg_hba.conf: 
sudo nano /etc/postgresql/12/main/pg_hba.conf 

Use the following settings for secure local connections: 
local   all             postgres                                peer 
host    all             all             127.0.0.1/32            md5 
host    all             all             ::1/128                 md5 
 

3. Use SSL for Remote Connections (Optional) 
Edit postgresql.conf to enable SSL: 
sudo nano /etc/postgresql/12/main/postgresql.conf 
Add or uncomment the following: 
ssl = on 
ssl_cert_file = '/etc/ssl/certs/ssl-cert-snakeoil.pem' 
ssl_key_file = '/etc/ssl/private/ssl-cert-snakeoil.key' 

Upgrade 
Upgrading PostgreSQL is crucial to keep the database secure and performant. 

1. Upgrade PostgreSQL to a New Version 
Add the PostgreSQL repository (if needed): 
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list' 
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - 
sudo apt update 
 
Install the new PostgreSQL version: 
sudo apt install postgresql-13 postgresql-client-13 
 
Upgrade the database using pg_upgrade (for major upgrades): 
sudo pg_upgradecluster 12 main 

Remove the old PostgreSQL version: 
sudo apt-get remove postgresql-12 

2. Verify the Upgrade 
psql --version 

High Availability 
High availability (HA) ensures that your PostgreSQL server remains operational even in the event of failure. 

1. Configure Streaming Replication 
Set up Primary Server: 
Edit postgresql.conf:  
sudo nano /etc/postgresql/12/main/postgresql.conf 

Add the following: 
wal_level = replica 
max_wal_senders = 3 
hot_standby = on 

Edit pg_hba.conf to allow replication: 
host    replication     all             192.168.x.x/32           md5 

Set up Standby Server: 
Take a base backup from the primary: 
pg_basebackup -h <primary_ip> -D /var/lib/postgresql/12/main -U replication -P --wal-method=stream 
 
Edit postgresql.conf on the standby:
primary_conninfo = 'host=<primary_ip> port=5432 user=replication password=yourpassword' 
 
Start the PostgreSQL server on the standby:
sudo systemctl start postgresql 

Backup and Restore 
Backing up and restoring PostgreSQL databases is critical for disaster recovery and system maintenance. 
1. Backup the Database 
Full Database Backup:  
pg_dumpall > all_databases_backup.sql 
 
Single Database Backup: 
pg_dump mydatabase > mydatabase_backup.sql 
 

Backup Using pg_basebackup: 
pg_basebackup -D /path/to/backup -Ft -z -P 
 

2. Restore the Database 
Restore from SQL Backup: 
psql -f all_databases_backup.sql postgres 
 
Restore from pg_basebackup: 
Copy the backup files back to the data directory and start PostgreSQL. 
pg_ctl -D /path/to/data_directory start 
 
3. Automate Backups 
You can automate backups using cron jobs. For example, to back up your databases every day at 2am, add the following to the crontab: 

crontab -e 
0 2 * * * pg_dumpall > /path/to/backup/all_databases_$(date +\%F).sql 

Conclusion 
This guide provides essential steps for installing, securing, upgrading, and maintaining a PostgreSQL server. Regular backups, high availability setups, and security configurations are crucial to ensure your database remains robust, secure, and always available. 
