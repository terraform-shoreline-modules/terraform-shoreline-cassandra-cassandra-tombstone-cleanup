
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Cassandra Tombstone Cleanup
---

In a Cassandra database, tombstones are markers that indicate a deleted record. If tombstones are not properly cleaned up, they can cause performance issues and potentially lead to data inconsistency. A Cassandra tombstone cleanup incident is an event where there is a need to identify and remove tombstones from the database in order to maintain optimal performance and data consistency. This incident type typically involves database administrators and software engineers working together to identify the source of the tombstones and implement a solution to remove them.

### Parameters
```shell
export KEYSPACE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export PATH_TO_LOG_FILE="PLACEHOLDER"

export PATH_TO_METRICS_FILE="PLACEHOLDER"
```

## Debug

### Check Cassandra process status
```shell
systemctl status cassandra
```

### Check Cassandra logs for tombstone warnings/errors
```shell
grep -i tombstone /var/log/cassandra/system.log
```

### List Cassandra keyspaces
```shell
cqlsh -e "DESC KEYSPACES;"
```

### List tables in a keyspace
```shell
cqlsh -e "DESC ${KEYSPACE_NAME};"
```

### Count the number of tombstones in a table
```shell
nodetool tablestats ${KEYSPACE_NAME}.${TABLE_NAME} | grep "Number of tombstones"
```

### Force a cleanup of tombstones in a table
```shell
nodetool cleanup ${KEYSPACE_NAME} ${TABLE_NAME}
```

### Check for tombstones in a table after cleanup
```shell
nodetool tablestats ${KEYSPACE_NAME}.${TABLE_NAME} | grep "Number of tombstones"
```

## Repair

### Remove tombstones: This involves running a compaction process on the database to remove the tombstones or manually deleting them.
```shell
bash

#!/bin/bash



# Set the necessary parameters

KEYSPACE=${KEYSPACE_NAME}

TABLE=${TABLE_NAME}



# Run the compaction process to remove tombstones

nodetool compact $KEYSPACE $TABLE



# Alternatively, manually delete the tombstones

nodetool flush $KEYSPACE $TABLE

nodetool repair $KEYSPACE $TABLE


```