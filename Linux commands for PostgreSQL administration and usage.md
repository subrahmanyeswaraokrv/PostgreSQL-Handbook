Author : Subrahmanyeswarao Karri
DataArchitect 
subrahmanyeswaraokarri@gmail.com
==============================================
1. PostgreSQL Service Management (systemd-based systems)
bash
Copy
Edit
# Start PostgreSQL
sudo systemctl start postgresql

# Stop PostgreSQL
sudo systemctl stop postgresql

# Restart PostgreSQL
sudo systemctl restart postgresql

# Enable PostgreSQL to start on boot
sudo systemctl enable postgresql

# Check PostgreSQL status
sudo systemctl status postgresql
👤 2. User and Role Management
bash
Copy
Edit
# Switch to the postgres OS user
sudo -i -u postgres

# Access PostgreSQL shell (psql)
psql

# Create a new PostgreSQL user
createuser <username>

# Create a new user with password and superuser rights
createuser --interactive --pwprompt --superuser <username>

# Drop a PostgreSQL user
dropuser <username>
🗃️ 3. Database Management
bash
Copy
Edit
# Create a new database
createdb <dbname>

# Drop (delete) a database
dropdb <dbname>

# List all databases
psql -c "\l"

# Connect to a specific database
psql -d <dbname>
📜 4. SQL Execution and Interactive Mode
bash
Copy
Edit
# Run SQL commands inside psql
psql

# Run SQL script from file
psql -d <dbname> -f /path/to/file.sql

# Run a single SQL command
psql -d <dbname> -c "SELECT * FROM table_name;"
📂 5. Backup and Restore
bash
Copy
Edit
# Full database dump
pg_dump -U <username> <dbname> > backup.sql

# Compressed backup
pg_dump -U <username> -F c -b -v -f backup.dump <dbname>

# Restore from SQL file
psql -U <username> -d <dbname> -f backup.sql

# Restore from custom format
pg_restore -U <username> -d <dbname> -v backup.dump

# Dump all databases
pg_dumpall -U <username> > all_databases.sql

# Restore all databases
psql -U <username> -f all_databases.sql
📊 6. Database Inspection and Queries
bash
Copy
Edit
# List all roles/users
\du

# List all tables
\dt

# Describe table schema
\d <table_name>

# List current connections
SELECT * FROM pg_stat_activity;

# Show current database
SELECT current_database();
🔒 7. Password and Access Control
bash
Copy
Edit
# Change PostgreSQL user password inside psql
\password <username>

# Change host-based authentication rules
sudo vi /etc/postgresql/<version>/main/pg_hba.conf

# Reload PostgreSQL config
sudo systemctl reload postgresql
🔍 8. Log and Config File Management
bash
Copy
Edit
# PostgreSQL config file (edit settings)
sudo vi /etc/postgresql/<version>/main/postgresql.conf

# Check location of config files from psql
SHOW config_file;
SHOW hba_file;

# View logs (example for Debian-based systems)
sudo tail -f /var/log/postgresql/postgresql-<version>-main.log
🧪 9. Performance and Monitoring
bash
Copy
Edit
# View current connections
SELECT * FROM pg_stat_activity;

# View locks
SELECT * FROM pg_locks;

# Table statistics
SELECT * FROM pg_stat_user_tables;

# Index usage
SELECT * FROM pg_stat_user_indexes;
🛠️ 10. Useful Utilities and Maintenance
bash
Copy
Edit
# Reindex a database
reindexdb -U <username> <dbname>

# Vacuum (cleanup dead tuples)
vacuumdb -U <username> -d <dbname> -v

# Analyze (update planner stats)
vacuumdb -U <username> -d <dbname> --analyze
