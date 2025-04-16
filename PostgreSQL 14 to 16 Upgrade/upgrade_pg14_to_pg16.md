# ✅ PostgreSQL 14 to 16 Upgrade – Step-by-Step

This guide outlines the full procedure to upgrade PostgreSQL 14 to 16 on Ubuntu with a custom data directory.

---

## 📦 Step 1: Install PostgreSQL 16
```bash
sudo apt install wget ca-certificates -y
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install postgresql-16 postgresql-client-16 -y
```

## 🧰 Step 2: Backup PostgreSQL 14
```bash
pg_dumpall > /tmp/pg14_full_backup.sql
```

## 🛑 Step 3: Stop PostgreSQL 14
```bash
sudo systemctl stop postgresql@14-main
```

## 🔐 Step 4: Set Permissions
```bash
sudo chown -R postgres:postgres /postgresql
sudo chmod 700 /postgresql
```

## 🧱 Step 5: Initialize PostgreSQL 16
```bash
sudo -u postgres /usr/lib/postgresql/16/bin/initdb -D /postgresql/data16
```

## 🛠️ Step 6: Perform the Upgrade
```bash
sudo -i -u postgres
/usr/lib/postgresql/16/bin/pg_upgrade \
  --old-datadir=/postgresql/data \
  --new-datadir=/postgresql/data16 \
  --old-bindir=/usr/lib/postgresql/14/bin \
  --new-bindir=/usr/lib/postgresql/16/bin \
  > /postgresql/logs/pg_upgrade_final.log 2>&1
```

## 🚀 Step 7: Start PostgreSQL 16
```bash
sudo systemctl start postgresql@16-main
sudo -u postgres psql -c "SELECT version();"
```

## 🧹 Step 8: Cleanup PostgreSQL 14
```bash
sudo systemctl stop postgresql@14-main
sudo apt purge postgresql-14 postgresql-client-14 -y
sudo apt autoremove --purge -y
sudo rm -rf /postgresql/data
```

---

✅ PostgreSQL 16 is now fully operational!
