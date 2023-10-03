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