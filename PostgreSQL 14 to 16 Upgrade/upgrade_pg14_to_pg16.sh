#!/bin/bash

# PostgreSQL 14 to 16 Upgrade Script
# Assumes /postgresql/data is old cluster and /postgresql/data16 is new target

set -e

echo "🧩 Installing PostgreSQL 16 packages..."
sudo apt install wget ca-certificates -y
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt update
sudo apt install postgresql-16 postgresql-client-16 -y

echo "📦 Taking backup..."
pg_dumpall > /tmp/pg14_full_backup.sql

echo "🛑 Stopping PostgreSQL 14..."
sudo systemctl stop postgresql@14-main

echo "🔧 Fixing directory permissions..."
sudo chown -R postgres:postgres /postgresql
sudo chmod 700 /postgresql

echo "📁 Initializing new PostgreSQL 16 cluster..."
sudo -u postgres /usr/lib/postgresql/16/bin/initdb -D /postgresql/data16

echo "⚙️ Running pg_upgrade..."
sudo -i -u postgres /usr/lib/postgresql/16/bin/pg_upgrade \
  --old-datadir=/postgresql/data \
  --new-datadir=/postgresql/data16 \
  --old-bindir=/usr/lib/postgresql/14/bin \
  --new-bindir=/usr/lib/postgresql/16/bin \
  > /postgresql/logs/pg_upgrade_final.log 2>&1

echo "🚀 Starting PostgreSQL 16..."
sudo systemctl start postgresql@16-main
sudo -u postgres psql -c "SELECT version();"

echo "🧹 Cleaning up PostgreSQL 14..."
sudo systemctl stop postgresql@14-main
sudo apt purge postgresql-14 postgresql-client-14 -y
sudo apt autoremove --purge -y
sudo rm -rf /postgresql/data

echo "✅ Upgrade to PostgreSQL 16 completed!"
