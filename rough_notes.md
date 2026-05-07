why small files are a problem: read overhead 
read footer 
read all files 

image
use thread dump to show how this works (create a large dataset wit multiple small files, force this )
 
Too many small files:
1. Driver overhead to read Iceberg manifests (Avro deserialization per entry)
2. Driver overhead for file → task mapping (bin packing, serialization, tracking)
3. Executor overhead multiplied by file count (one S3 GET open cost per file)

IMAGE TO show small files v optimal size file stage screenshot and cmparison of the ui and time to complete

use cleanup functions to reprocess files to be in the goldilocks size zone 

image 
code
spark ui screenshot of how this clean up works 

https://iceberg.apache.org/docs/latest/spark-procedures/#rewrite_data_files
Delta optimize 

with these you can run a separate command to optimize the files 

| Order | Procedure | Why |
|---|---|---|
| 1 | `rewrite_data_files` | Compacts data files first — creates new snapshots |
| 2 | `expire_snapshots` | Expires old snapshots created before the rewrite |
| 3 | `remove_orphan_files` | Removes old data files dereferenced in step 2 |
| 4 | `rewrite_manifests` | Compact manifests last to reflect final state |


define table level settings

set output part size; but not always respected, one task -> input may have cross part data -> write to partition 

part in code -> 1 task -> 1 partitoin (respects file size)

in task file size 

1 

code 
surprise utput screenshot / file size 
what happens image 

2 

code (partition in code)
file size as expected 
what happens image 

vendors do this for you 

without iceberg snowflake does all of this for you 
with iceberg snowflake automates this for you as well https://docs.snowflake.com/en/user-guide/tables-iceberg-manage#label-tables-iceberg-configure-table-optimization-snowflake-managed

https://docs.snowflake.com/en/user-guide/tables-auto-reclustering

| Concern | OSS Iceberg (your setup) | Databricks OSS Delta | Databricks Unity Catalog | Snowflake |
|---|---|---|---|---|
| File compaction | ❌ manual `rewrite_data_files` | ⚠️ semi-auto with table props | ✅ Predictive Optimization | ✅ automatic |
| Old snapshot cleanup | ❌ manual `expire_snapshots` | ❌ manual `VACUUM` | ✅ automatic | ✅ automatic |
| Orphan file removal | ❌ manual `remove_orphan_files` | ❌ manual `VACUUM` | ✅ automatic | ⚠️ contact support |
| Manifest compaction | ❌ manual `rewrite_manifests` | N/A (transaction log) | N/A | ✅ automatic |

^ check docs for this 

choose your tradeoff 

