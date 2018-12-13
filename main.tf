provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

module "ecs" {
  source = "./modules/ecs"

  ami_id               = "${lookup(var.ecs_amis, var.region)}"
  instance_type        = "${var.ecs_instance_type}"
  key_name             = "${var.key_name}"
  max_cluster_size     = "${var.ecs_max_cluster_size}"
  min_cluster_size     = "${var.ecs_min_cluster_size}"
  platform_instance_id = "${var.platform_instance_id}"
  proxy_endpoint       = "${var.proxy_endpoint}"
  region               = "${var.region}"
  ssh_cidr_blocks      = "${var.ssh_cidr_blocks}"
  subnet_id_1          = "${var.ecs_subnet_id_1}"
  subnet_id_2          = "${var.ecs_subnet_id_2}"
  user_init            = "${var.ecs_user_init}"
  volume_size          = "${var.ecs_volume_size}"
}

module "queues" {
  source = "./modules/queues"

  platform_instance_id = "${var.platform_instance_id}"
}

module "elasticache" {
  source = "./modules/elasticache"

  instance_type_services = "${var.elasticache_instance_type_services}"
  platform_instance_id   = "${var.platform_instance_id}"
  subnet_id_1            = "${var.services_subnet_id_1}"
  subnet_id_2            = "${var.services_subnet_id_2}"
}

module "elasticsearch" {
  source = "./modules/elasticsearch"

  dedicated_master_count = "${var.elasticsearch_dedicated_master_count}"
  dedicated_master_type  = "${var.elasticsearch_dedicated_master_type}"
  instance_count         = "${var.elasticsearch_instance_count}"
  instance_type          = "${var.elasticsearch_instance_type}"
  platform_instance_id   = "${var.platform_instance_id}"
  region                 = "${var.region}"
  security_group_ids     = "${module.services.services_security_group_id}"
  subnet_id_1            = "${var.elasticsearch_subnet_id_1}"
  subnet_id_2            = "${var.elasticsearch_subnet_id_2}"
  volume_size            = "${var.elasticsearch_volume_size}"
}

module "rds" {
  source = "./modules/rds"

  allocated_storage    = "${var.db_allocated_storage}"
  db_backup_retention  = "${var.db_backup_retention}"
  db_backup_window     = "${var.db_backup_window}"
  db_instance_size     = "${var.db_instance_size}"
  db_kms_key_id        = "${var.db_kms_key_id}"
  db_multi_az          = "${var.db_multi_az}"
  db_password          = "${var.db_password}"
  db_snapshot          = "${var.db_snapshot}"
  db_storage_encrypted = "${var.db_storage_encrypted}"
  db_username          = "${var.db_username}"
  platform_instance_id = "${var.platform_instance_id}"
  rds_subnet_id_1      = "${var.rds_subnet_id_1}"
  rds_subnet_id_2      = "${var.rds_subnet_id_2}"
  services_subnet_id_1 = "${var.services_subnet_id_1}"
  services_subnet_id_2 = "${var.services_subnet_id_2}"
}

module "services" {
  source = "./modules/services"

  account_lockout_attempts      = "${var.account_lockout_attempts}"
  account_lockout_interval      = "${var.account_lockout_interval}"
  account_lockout_period        = "${var.account_lockout_period}"
  ami_id                        = "${lookup(var.services_amis, var.region)}"
  az1_nat_ip                    = "${var.az1_nat_ip}"
  az2_nat_ip                    = "${var.az2_nat_ip}"
  box_com_client_id             = "${var.box_com_client_id}"
  box_com_secret_key            = "${var.box_com_secret_key}"
  bcrypt_cost                   = "${var.bcrypt_cost}"
  client_secret_fe              = "${var.client_secret_fe}"
  client_secret_internal        = "${var.client_secret_internal}"
  customer                      = "${var.customer}"
  db_endpoint                   = "${module.rds.endpoint}"
  db_password                   = "${var.db_password}"
  db_username                   = "${var.db_username}"
  dropbox_app_key               = "${var.dropbox_app_key}"
  dropbox_app_secret            = "${var.dropbox_app_secret}"
  dns_name                      = "${var.dns_name}"
  ecs_cluster                   = "${module.ecs.cluster}"
  ecs_cpu_reservation           = "${var.ecs_cpu_reservation}"
  ecs_memory_hard_reservation   = "${var.ecs_memory_hard_reservation}"
  ecs_memory_soft_reservation   = "${var.ecs_memory_soft_reservation}"
  elasticache_services          = "${module.elasticache.endpoint_services}"
  elasticsearch_endpoint        = "https://${module.elasticsearch.endpoint}"
  encrypted_config_blob         = "${var.encrypted_config_blob}"
  encryption_key                = "${var.encryption_key}"
  faces_endpoint                = "${var.faces_endpoint}"
  file_storage_s3_bucket_arn    = "${var.file_storage_s3_bucket_arn}"
  gm_jwt_expiration_time        = "${var.gm_jwt_expiration_time}"
  gm_license_key                = "${var.gm_license_key}"
  gm_threshold_to_harvest       = "${var.gm_threshold_to_harvest}"
  gm_walkd_max_item_concurrency = "600"
  gm_walkd_redis_max_active     = "1200"
  google_maps_key               = "${var.google_maps_key}"
  harvest_complete_stow_fields  = "${var.harvest_complete_stow_fields}"
  harvest_polling_time          = "${var.harvest_polling_time}"
  instance_type                 = "${var.services_instance_type}"
  jwt_key                       = "${var.jwt_key}"
  key_name                      = "${var.key_name}"
  log_retention                 = "${var.log_retention}"
  max_cluster_size              = "${var.services_max_cluster_size}"
  min_cluster_size              = "${var.services_min_cluster_size}"
  notifications_from_addr       = "${var.notifications_from_addr}"
  notifications_region          = "${coalesce(var.notifications_region, var.region)}"
  oauthconnect_encryption_key   = "${var.oauthconnect_encryption_key}"
  password_min_length           = "${var.password_min_length}"
  platform_access_cidrs         = "${var.platform_access_cidrs}"
  platform_instance_id          = "${var.platform_instance_id}"
  proxy_endpoint                = "${var.proxy_endpoint}"
  public_subnet_id_1            = "${var.public_subnet_id_1}"
  public_subnet_id_2            = "${var.public_subnet_id_2}"
  region                        = "${var.region}"
  rollbar_token                 = "${var.rollbar_token}"
  s3subscriber_priority         = "${var.s3subscriber_priority}"
  services_iam_role_name        = "${var.services_iam_role_name}"
  sqs_activity                  = "${module.queues.activity}"
  sqs_activity_arn              = "${module.queues.activity_arn}"
  sqs_index                     = "${module.queues.index}"
  sqs_index_arn                 = "${module.queues.index_arn}"
  sqs_s3notifications           = "${var.sqs_s3notifications}"
  sqs_s3notifications_arn       = "${var.sqs_s3notifications_arn}"
  sqs_stage01                   = "${module.queues.stage01}"
  sqs_stage01_arn               = "${module.queues.stage01_arn}"
  sqs_stage02                   = "${module.queues.stage02}"
  sqs_stage02_arn               = "${module.queues.stage02_arn}"
  sqs_stage03                   = "${module.queues.stage03}"
  sqs_stage03_arn               = "${module.queues.stage03_arn}"
  sqs_stage04                   = "${module.queues.stage04}"
  sqs_stage04_arn               = "${module.queues.stage04_arn}"
  sqs_stage05                   = "${module.queues.stage05}"
  sqs_stage05_arn               = "${module.queues.stage05_arn}"
  sqs_stage06                   = "${module.queues.stage06}"
  sqs_stage06_arn               = "${module.queues.stage06_arn}"
  sqs_stage07                   = "${module.queues.stage07}"
  sqs_stage07_arn               = "${module.queues.stage07_arn}"
  sqs_stage08                   = "${module.queues.stage08}"
  sqs_stage08_arn               = "${module.queues.stage08_arn}"
  sqs_stage09                   = "${module.queues.stage09}"
  sqs_stage09_arn               = "${module.queues.stage09_arn}"
  sqs_stage10                   = "${module.queues.stage10}"
  sqs_stage10_arn               = "${module.queues.stage10_arn}"
  sqs_walk                      = "${module.queues.walk}"
  sqs_walk_arn                  = "${module.queues.walk_arn}"
  ssh_cidr_blocks               = "${var.ssh_cidr_blocks}"
  ssl_certificate_arn           = "${var.ssl_certificate_arn}"
  subnet_id_1                   = "${var.services_subnet_id_1}"
  subnet_id_2                   = "${var.services_subnet_id_2}"
  temporary_bucket_name         = "${module.ecs.temporary_bucket_name}"
  usage_s3_bucket_arn           = "${var.usage_s3_bucket_arn}"
  user_init                     = "${var.services_user_init}"
  walkd_item_batch_size         = "300"
}
