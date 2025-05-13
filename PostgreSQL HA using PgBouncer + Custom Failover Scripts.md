PostgreSQL HA using PgBouncer + Custom Failover Scripts
======================================================
🧭 Architecture Diagram
text
Copy
Edit
           +------------------+
           |   Application    |
           |     Clients      |
           +--------+---------+
                    |
                    v
           +------------------+
           |    PgBouncer     |
           | (on virtual IP)  |
           +--------+---------+
                    |
        +-----------+------------+
        |                        |
+----------------+     +----------------+
| PostgreSQL Node A |   | PostgreSQL Node B |
|    (Primary)      |   |   (Standby)       |
+------------------+   +-------------------+
PgBouncer connects to primary PostgreSQL, and on failure, custom scripts promote the standby and update PgBouncer config or Virtual IP (VIP).

🧾 Requirements
OS: Ubuntu 20.04 or later

PostgreSQL: 12+

PgBouncer: 1.16+

VIP setup (optional but recommended for seamless routing)

Passwordless SSH between nodes

1️⃣ Install PostgreSQL on Both Nodes
bash
Copy
Edit
sudo apt update
sudo apt install postgresql -y
2️⃣ Configure Streaming Replication
Follow standard replication setup:

On Primary (Node A):
Edit postgresql.conf:

conf
Copy
Edit
listen_addresses = '*'
wal_level = replica
max_wal_senders = 10
wal_keep_size = 64
Add to pg_hba.conf:

conf
Copy
Edit
host    replication     replicator     192.168.1.11/32     md5
Create replicator user:

sql
Copy
Edit
CREATE ROLE replicator WITH REPLICATION LOGIN ENCRYPTED PASSWORD 'replicator_password';
Restart PostgreSQL:

bash
Copy
Edit
sudo systemctl restart postgresql
On Standby (Node B):
bash
Copy
Edit
sudo systemctl stop postgresql
sudo rm -rf /var/lib/postgresql/15/main/*
Take base backup:

bash
Copy
Edit
sudo -u postgres pg_basebackup -h 192.168.1.10 -U replicator -D /var/lib/postgresql/15/main -P -R
Confirm standby.signal and primary_conninfo exists.

Start PostgreSQL on standby:

bash
Copy
Edit
sudo systemctl start postgresql
3️⃣ Install and Configure PgBouncer
On a shared node (or both):

bash
Copy
Edit
sudo apt install pgbouncer -y
Edit /etc/pgbouncer/pgbouncer.ini:

ini
Copy
Edit
[databases]
postgres = host=192.168.1.10 port=5432 dbname=postgres

[pgbouncer]
listen_addr = 0.0.0.0
listen_port = 6432
auth_type = md5
auth_file = /etc/pgbouncer/userlist.txt
admin_users = postgres
Create /etc/pgbouncer/userlist.txt:

txt
Copy
Edit
"postgres" "md5<MD5_HASHED_PASSWORD>"
Reload PgBouncer:

bash
Copy
Edit
sudo systemctl restart pgbouncer
4️⃣ Create Failover Script
On Standby Node, create /usr/local/bin/failover.sh:

bash
Copy
Edit
#!/bin/bash
# promote standby to primary

PGDATA="/var/lib/postgresql/15/main"

echo "[INFO] Promoting standby to primary..."
sudo -u postgres pg_ctl -D "$PGDATA" promote

sleep 5

echo "[INFO] Updating PgBouncer config..."
# Option 1: Update PgBouncer on localhost
sed -i 's/host=.*/host=192.168.1.11/' /etc/pgbouncer/pgbouncer.ini
sudo systemctl restart pgbouncer

# Option 2: If PgBouncer is on separate node, use SSH
# ssh pgbouncer@<IP> 'sed -i "s/host=.*/host=192.168.1.11/" /etc/pgbouncer/pgbouncer.ini && systemctl restart pgbouncer'
Make it executable:

bash
Copy
Edit
chmod +x /usr/local/bin/failover.sh
5️⃣ Setup Health Check / Cron (Optional)
Run a health check script periodically on standby:

bash
Copy
Edit
#!/bin/bash

PGHOST=192.168.1.10
PGPORT=5432

pg_isready -h $PGHOST -p $PGPORT
if [ $? -ne 0 ]; then
    echo "[WARN] Primary down, triggering failover..."
    /usr/local/bin/failover.sh
fi
Add to crontab or use a monitoring tool like monit or systemd-timer.

✅ 6️⃣ Verification Steps
On Standby:
bash
Copy
Edit
psql -c "SELECT pg_is_in_recovery();"  # should be true
Simulate Primary Failure:
Stop PostgreSQL on Node A:

bash
Copy
Edit
sudo systemctl stop postgresql
Run failover script on Node B:

bash
Copy
Edit
sudo /usr/local/bin/failover.sh
On PgBouncer Node:
bash
Copy
Edit
psql -U postgres -p 6432 -h localhost
SELECT pg_is_in_recovery();  -- should be false, confirming promotion
PgBouncer Logs:
Check /var/log/postgresql/pgbouncer.log for connection redirection.

🧾 Summary
Component	Role
PostgreSQL A	Primary
PostgreSQL B	Standby
PgBouncer	Connection proxy
Script	Manual failover & config switch
