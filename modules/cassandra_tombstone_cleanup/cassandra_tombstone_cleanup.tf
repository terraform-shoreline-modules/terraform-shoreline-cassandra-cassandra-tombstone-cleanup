resource "shoreline_notebook" "cassandra_tombstone_cleanup" {
  name       = "cassandra_tombstone_cleanup"
  data       = file("${path.module}/data/cassandra_tombstone_cleanup.json")
  depends_on = [shoreline_action.invoke_tombstone_removal_script]
}

resource "shoreline_file" "tombstone_removal_script" {
  name             = "tombstone_removal_script"
  input_file       = "${path.module}/data/tombstone_removal_script.sh"
  md5              = filemd5("${path.module}/data/tombstone_removal_script.sh")
  description      = "Remove tombstones: This involves running a compaction process on the database to remove the tombstones or manually deleting them."
  destination_path = "/agent/scripts/tombstone_removal_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tombstone_removal_script" {
  name        = "invoke_tombstone_removal_script"
  description = "Remove tombstones: This involves running a compaction process on the database to remove the tombstones or manually deleting them."
  command     = "`chmod +x /agent/scripts/tombstone_removal_script.sh && /agent/scripts/tombstone_removal_script.sh`"
  params      = ["TABLE_NAME","KEYSPACE_NAME"]
  file_deps   = ["tombstone_removal_script"]
  enabled     = true
  depends_on  = [shoreline_file.tombstone_removal_script]
}

