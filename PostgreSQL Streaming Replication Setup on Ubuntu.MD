PostgreSQL Streaming Replication Setup on Ubuntu
🧾 Assumptions
Primary Node (Master):

Hostname: pg-primary

IP: 192.168.1.10

Standby Node (Replica):

Hostname: pg-standby

IP: 192.168.1.11

OS: Ubuntu 20.04+ (same steps apply to 22.04)

PostgreSQL Version: 12 or higher (e.g., 15)

PostgreSQL is installed via apt packages

1️⃣ Install PostgreSQL on Both Nodes
bash
Copy
Edit
sudo apt update
sudo apt install postgresql postgresql-contrib -y
Verify version:

bash
Copy
Edit
psql -V
2️⃣ Configure Primary Node
a. Edit postgresql.conf
bash
Copy
Edit
sudo nano /etc/postgresql/15/main/postgresql.conf
Update or add:

conf
Copy
Edit
listen_addresses = '*'
wal_level = replica
max_wal_senders = 10
wal_keep_size = 64MB
archive_mode = on
archive_command = 'cd .'  # dummy command
b. Edit pg_hba.conf
bash
Copy
Edit
sudo nano /etc/postgresql/15/main/pg_hba.conf
Add replication entry (use replica IP):

conf
Copy
Edit
host    replication     replicator      192.168.1.11/32        md5
c. Create Replication User
bash
Copy
Edit
sudo -u postgres psql
sql
Copy
Edit
CREATE ROLE replicator WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'replicator_password';
\q
d. Restart PostgreSQL
bash
Copy
Edit
sudo systemctl restart postgresql
3️⃣ Configure Standby Node
a. Stop PostgreSQL
bash
Copy
Edit
sudo systemctl stop postgresql
b. Clear Existing Data Directory
bash
Copy
Edit
sudo rm -rf /var/lib/postgresql/15/main/*
c. Base Backup from Primary
bash
Copy
Edit
sudo -u postgres pg_basebackup -h 192.168.1.10 -D /var/lib/postgresql/15/main -U replicator -P -R
It will:

Pull data from primary

Create a standby.signal file (for streaming replica mode)

Create a postgresql.auto.conf with replication connection string

When prompted for password, enter replicator_password.

You can also manually edit postgresql.auto.conf if needed:

conf
Copy
Edit
primary_conninfo = 'host=192.168.1.10 port=5432 user=replicator password=replicator_password'
d. Optional Tuning (standby)
Edit /etc/postgresql/15/main/postgresql.conf and set:

conf
Copy
Edit
hot_standby = on
4️⃣ Start Standby Node
bash
Copy
Edit
sudo systemctl start postgresql
✅ Verification
On Primary:
bash
Copy
Edit
sudo -u postgres psql
sql
Copy
Edit
SELECT * FROM pg_stat_replication;
Check for active connections.

On Standby:
bash
Copy
Edit
sudo -u postgres psql
Run:

sql
Copy
Edit
SELECT pg_is_in_recovery();  -- should return true
📌 Optional: Enable Passwordless SSH (for WAL shipping / archive mode)
For physical log shipping instead of streaming, or hybrid mode, you may want SSH trust. Not required for basic streaming.

📤 Monitoring Replication Lag
sql
Copy
Edit
-- On primary
SELECT pid, usename, application_name, client_addr, state, sent_lsn, write_lsn, flush_lsn, replay_lsn FROM pg_stat_replication;

-- On standby
SELECT pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn(), pg_is_in_recovery();
📎 Notes
Default replication is asynchronous.

For synchronous replication, set synchronous_standby_names on primary.

Make sure firewalls or ufw allow port 5432 on both nodes.
