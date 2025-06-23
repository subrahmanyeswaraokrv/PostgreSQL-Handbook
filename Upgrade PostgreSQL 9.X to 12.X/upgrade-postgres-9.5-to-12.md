Install PostgreSQL:

```
sudo echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
  
sudo apt update

sudo apt install postgresql-12 postgresql-client-12 postgresql-contrib-12
```

Use `dpkg -l | grep postgresql` to check which versions of postgres are installed:

```
i   postgresql                                                        - object-relational SQL database (supported version)
i A postgresql-9.5                                                    - object-relational SQL database, version 9.5 server
i A postgresql-9.6                                                    - object-relational SQL database, version 9.6 server
i A postgresql-client-9.5                                             - front-end programs for PostgreSQL 9.5
i A postgresql-client-12                                             - front-end programs for PostgreSQL 9.6
i A postgresql-contrib-9.5                                            - additional facilities for PostgreSQL
i A postgresql-contrib-12                                            - additional facilities for PostgreSQL
```

Run `pg_lsclusters`, your 9.5 and 9.6 main clusters should be "online".

```
pg_lsclusters 
Ver Cluster Port Status Owner    Data directory               Log file
9.5 main    5432 online postgres /var/lib/postgresql/9.3/main /var/log/postgresql/postgresql-9.5-main.log
12 main    5433 online postgres /var/lib/postgresql/9.5/main /var/log/postgresql/postgresql-9.6-main.log
```

There already is a cluster "main" for 11 (since this is created by default on package installation).
This is done so that a fresh installation works out of the box without the need to create a cluster first,
but of course it clashes when you try to upgrade 9.5/main when 11/main also exists.
The recommended procedure is to remove the 11 cluster with `pg_dropcluster` and then upgrade with `pg_upgradecluster`.

Stop the 12 cluster and drop it.

```bash
sudo pg_dropcluster 12 main --stop
```

Upgrade the 9.5 cluster to the latest version.

```bash
sudo pg_upgradecluster 9.5 main
```

Your 9.5 cluster should now be "down".

```
pg_lsclusters 
Ver Cluster Port Status Owner    Data directory               Log file
9.5 main    5433 down   postgres /var/lib/postgresql/9.5/main /var/log/postgresql/postgresql-9.5-main.log
12 main    5432 online postgres /var/lib/postgresql/9.6/main /var/log/postgresql/postgresql-9.6-main.log
```

Check that the upgraded cluster works, then remove the 9.5 cluster.

```bash
sudo pg_dropcluster 9.5 main
```


Lastly:

```
sudo nano /etc/postgresql/12/main/postgresql.conf
```

Change `cluster_name = '9.5/main'` to `cluster_name = '12/main'`.