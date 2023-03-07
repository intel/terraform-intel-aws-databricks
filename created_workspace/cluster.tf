resource "databricks_token" "pat" {
  # provider         = databricks.created_workspace
  comment          = "Terraform Provisioning"
  lifetime_seconds = 86400
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
}

resource "databricks_global_init_script" "init1" {
  source = "../../scripts/init_intel_optimized_ml.sh"
  name   = "Intel Optimized ML library init script"
  enabled =  var.dbx_global_init_script_enabled
}

resource "databricks_cluster" "dbx_cluster" {
  cluster_name            = var.dbx_cluster_name
  spark_version           = data.databricks_spark_version.latest_lts.id
  node_type_id            = var.dbx_node_type_id
  autotermination_minutes = var.dbx_auto_terminate_min
  runtime_engine          = var.dbx_runtime_engine
  num_workers             = var.dbx_num_workers
  spark_conf              = var.dbx_spark_config
  custom_tags             = var.tags
}
