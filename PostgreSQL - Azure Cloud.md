PostgreSQL & Azure Cloud – KT Questionnaire 
1. Environment Overview

What PostgreSQL versions are currently in use?

How many databases and instances are running, and on which servers (on-prem / Azure)?

What is the environment type – Dev / UAT / Prod?

Where is the inventory documented (server list, DB names, owners)?

How are PostgreSQL servers deployed – standalone, HA cluster, or Azure Flexible Server?

What are the hostnames, IPs, and connectivity methods (bastion, jump host, etc.)?

What is the database size (approx.) and growth trend?

2. Access & Security

How is access provided (local login, Active Directory, Azure AD, key vault, etc.)?

What roles and privileges are assigned to DBAs?

How do we connect (client tools like psql, DBeaver, Azure Data Studio)?

Are connections restricted by IP or VNet rules?

What is the SSL/TLS setup — do we enforce SSL-only connections?

Where are certificates stored and how are they renewed?

Any password rotation or key vault policy in place?

3. Backup & Restore

What is the backup strategy (native pg_dump, pg_basebackup, Azure Backup, etc.)?

What is the backup retention period?

Where are backups stored (local disk, Azure Blob, S3, etc.)?

How to perform a restore (full and PITR)?

How frequently are backup restores tested for validation?

Who monitors backup success/failures?

Is there any backup automation script or job scheduler (cron, Azure Automation)?

4. Replication & HA

Is replication configured (streaming / logical / Azure read replicas)?

How is replication lag monitored?

How to perform manual failover or switchover?

What are the steps to rejoin a failed standby node?

What tool is used for replication monitoring (Grafana, pg_stat_replication, etc.)?

Any DR site setup or geo-redundant configuration?

What is the RPO/RTO target?

5. Monitoring & Alerting

What tools are used for monitoring (Prometheus, Grafana, Azure Monitor, etc.)?

What are the key metrics being tracked (CPU, I/O, connections, replication lag)?

What are the alert thresholds for critical parameters?

How are alerts notified (email, Teams, PagerDuty, etc.)?

Where are the dashboards located?

Who maintains the monitoring scripts or configurations?

6. Maintenance & Operations

How often are VACUUM, ANALYZE, and REINDEX jobs executed?

Are these automated? If yes, how (cron or Azure Automation)?

What’s the patching and upgrade policy for PostgreSQL?

How do we rotate logs and manage disk space?

What’s the typical maintenance window and who approves it?

What scripts are in place for daily health checks?

Any pre- or post-maintenance checklists to follow?

7. Performance & Troubleshooting

How are slow queries identified (pg_stat_statements, Azure logs, etc.)?

What’s the process for tuning queries or parameters?

How is autovacuum configured and monitored?

Any performance baseline available for reference?

Common performance issues seen in this environment?

How do we handle deadlocks or blocking sessions?

What is the escalation process if performance degrades?

8. Azure Cloud Specific

Which Azure PostgreSQL deployment model is used (Flexible Server / Hyperscale / VM)?

What resource groups, subscriptions, and regions are in use?

How is high availability configured in Azure?

How do we scale compute/storage if needed?

How are backups managed in Azure (automatic or manual)?

What Azure Monitor metrics or alerts are set up?

Is Azure AD authentication configured?

How are network and firewall rules managed (VNet, private endpoints)?

What’s the process to perform failover or restart from Azure portal?

Any integration with other Azure services (App Service, Data Factory, Event Hub)?

9. Incident Management

Where are incidents tracked (ServiceNow, Jira, etc.)?

What are the typical incident categories (DB down, replication lag, high CPU)?

Who are the L1/L2/L3 escalation points?

Any RCA format or process to follow post-incident?

How are production changes handled (CRQ/Change ticket process)?

10. Documentation & Handover

Where is all DB documentation stored (Confluence, SharePoint, Git)?

Any DB schema diagrams or data flow documents available?

Where are scripts stored (Git repo, shared drive)?

What are the ongoing activities or pending tasks?

What KT sessions are planned (topics, schedule)?

Any known issues, limitations, or planned migrations/upgrades?

11. Closing KT Checklist
Area	Status	Remarks
Access received	☐	
Environment overview understood	☐	
Backup & restore tested	☐	
Monitoring access verified	☐	
Failover tested / observed	☐	
Azure portal access verified	☐	
All scripts & docs received	☐	
KT completed and sign-off	☐	
