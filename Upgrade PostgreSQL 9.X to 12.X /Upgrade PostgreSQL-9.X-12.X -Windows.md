Upgrade PostgreSQL 9.X to 12.X in Windows
Subrahmanyeswarao Karri, 2025-06-23

This text will elaborate on upgrading the PostgreSQL database from the 9.x version to the 12.x version. Upgrading the PostgreSQL server can be done by installing the newer version of Postgres alongside the current one and executing the pg_upgrade command with essential parameters. A manual backup and restore process is not required when we use the pg_upgrade as the command will automatically copy the data directory to the newer version. We will cover many requirements in-depth in this text to eradicate the numerous dynamic errors and challenges.

The PostgreSQL Config file and user database file must be backed up using pg_dump command before initiating the PostgreSQL upgrade process. Generally, backing up of data is not essential as current PostgreSQL 9.x will not get affected during or after the update using the pg_upgrade process.

Config Files
Two config files (PostgreSQL.conf and pg_hba.conf) must be have a backup taken as the newer installation will replace the new config file with default configuration parameters and values. The default directory where PostgreSQL keeps configuration file is: C:\Program Files\PostgreSQL \X.X\data). It could be modified by the user to change the Config file with the 9.X version, so we have to compare config files of 9.X with 12.X and synch the required updates in the newer version's config file(12.x).

Backup Databases
Users may take an individual database backup by using the help of the below command. However, we can take a backup together of all databases using the pg_dumpall command. To do this, open a command prompt and traverse through the appropriate directory. Then run the pg_dump command, as shown here:

CD C:\Program Files\PostgreSQL\9.0\bin

pg_dump -U Postgres -W -F t dvdrental > "V:\ PostgreSQL Backup\dvdrental.tar"
Here, I used the directory, C:\Users\JERRY\Downloads\PostgreSQLDir\Backup, for storing the backup database and named it as 'dvrental' with a tar extension.

Using the VERSION() and inet_server_port() functions, users will get the information of PostgreSQL version and the port number on which PostgreSQL is running. Let us begin with the realtime setup. Below I will dictate the possible challenges, errors and its solution on my local server



Here, the default port number 5432 is under use by my currently running PostgreSQL server, and the version of PostgreSQL 9.6.19. After that, I have used the \l command to get the list of all databases existing on the PostgreSQL.



Here, we can see that dvdrental is a user database, while Postgres is a system database. Let me show you the number of tables and their tuples counts in the user database dvdrental beforehand, upgrading the Postgres server.



We can clearly see that there are 22 tables and view types of objects that are residing in the dvdrental database. The users are also able to enlist it by using information-schema and table objects. We will now get the numbers of records of each table by quivering on pg_stat_user_tables and showing them in decreasing order.

SELECT schemaname, relname, n_live_tup
  from pg_stat_user_tables ORDER BY n_live_tup DESC;
 



Install PostgreSQL 12.X
We must ensure that we download the PostgreSQL 12.x version from this Postgres Official Link. Download and install it by selecting the new installation file directory. "C:\Program Files\PostgreSQL \12" is the default installation directory for the 12.x version.



Here, to install the Binaries and Data, we used the default installation directory.



The data directory can also be modified. Generally, we use the SAN disk storage drive, so the drive path and folder can be changed accordingly.



As we know, the '5432' port is under use by PostgreSQL 9.x, so 12.X can not be run on 5432 because two different PostgreSQL services can not run on the same port. At the end of the installation process, we can see the installation summary, which will showcase the user's user inputs during the installation process. If we wish to modify any input or information, we must do this by using.



The installation wizard will complete the setup installation if we have supplied proper legitimate inputs.



The user is asked for the password for the Postgres default user by the installation wizard. Now, users can log in on new Postgres with port 5433 using Postgres username and its password.



From the screenshot above, we can see that the latest Postgre12.4 is running on port number 5433.



We must give full privileges to the PostgreSQL installation directory (C:\Program Files\PostgreSQL ) before running the pg_upgrade utility. Otherwise, that will immediately raise a permission error as below. In a command prompt, run this:

CD C:\Program Files\PostgreSQL \12\bin

SET PGPASSWORD =1234

pg_upgrade -d "c:\Program Files\PostgreSQL \9.6\data" -D"c:\Program Files\PostgreSQL \12\data" -b "c:\Program Files\PostgreSQL \9.6\bin" -B "c:\Program Files\PostgreSQL \12\bin" -U Postgres
Now, In the pg_upgrade command to authenticate the Postgres user, we are going to use PGPASSWORD. We are using the Postgres user, so we have to use the default password for the Postgres user of PostgreSQL 12, which is 1234 set by us during the installation process.



I suggest making a separate folder, either in C drive or another drive, and execute the pg_upgrade because the problem arises when we run the. pg_uppgrade command from the base directory "C:\Program Files\PostgreSQL \12\bin" and is that it generates several log files, including the error log.



Here, we have made one folder TEMP in V:\ drive and assigning full privileges to everyone on that folder to avoid conflicting situations again.



Now, let's run the pg_upgrade command after opening the command prompt open in the directory "V:\TEMP". Here is the command:

SET PGPASSWORD=1234

"c:\Program Files\PostgreSQL \12\bin\pg_upgrade.exe" -d "c:\Program Files\PostgreSQL \9.6\data" -D"c:\Program Files\PostgreSQL \12\data" -b "c:\Program Files\PostgreSQL \9.6\bin" -B "c:\Program Files\PostgreSQL \12\bin" -U Postgres
Here, we can modify the parameter accordingly if the data directory and installation directory, which is not the default one. kindly refer to the parameter reference as below:

-d is the data directory for the older PostgreSQL version 9.6
-D is the data directory for the newer PostgreSQL version 12
-b is the data Directory folder for the older PostgreSQL 9.6
-B is the data Directory folder for the newer PostgreSQL 9.6
-U is the user who is performing the migration (Default is Postgres )


Here, In the same console, we add the upgrade log. We will get the error on the console if any conflicting situation arises during the data migration or up-gradation. For further exploration regarding the error, we can see the error log in the "V:\TEMP" directory in case of any error or issue. Now you will understand the reason for running the pg_upgrade command from another folder rather than the default directory.

Now we can start the PostgreSQL Server 12 service in the Services.msc appelet upon successful execution of pg_upgrade command and using PgAdmin IV, we can see the data from the previous version to this new version. The pg_upgrade is copying data directory and system database stuff, so users and system stuff will get copied.

Using PORT 5433 must connect Postgres 12 and check the database and table details as we checked earlier on Postgres 9.6 in this text.



Here, we can see that the dvdrental database synchronized. Let me get the tables in the database with any of the table data.



We can see the number of rows in the city table as it is in Postgres 9.6.

Here, the latest PostgreSQL works on the new port 5433, where your applications will be configured with the older version's port number 5432 to connect with the databases. So, we have two options to handle this situation. Either change the Postgres connection port number in the application configuration with 5433 or change the port number in PostgreSQL 12 with 5432.

If we want to change the port number in PostgreSQL 12, first users have to stop the services running on port 5432 using Microsoft windows services as port 5432 is already occupied by PostgreSQL's services 9.6. The Port number can be changed in PostgreSQL with the config file's help, and don't forget to sync and update the older and latest config files. Because newly installed Postgres 12 is being configured with the latest configuration, and existing could be different from the Memory, connection, and other parameters.

My recommendation is to keep the older PostgreSQL version for a day or week because if you face any challenges or issues with the newer ones, users can compare it with the older one. If it is not required, then you can uninstall the older PostgreSQL. I recommend following the same process on Dev, QA, or Stage environment before proceeding to the Production.
