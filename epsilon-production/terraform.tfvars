environment                  = "production"
project                      = "epsilon"
component                    = "cudl-data-workflows"
subcomponent                 = "cudl-transform-lambda"
destination-bucket-name      = "releases"
web_frontend_domain_name     = "production.epsilon.ac.uk"
transcriptions-bucket-name   = "unused-cul-cudl-transcriptions"
enhancements-bucket-name     = "unused-cul-cudl-data-enhancements"
source-bucket-name           = "unused-cul-cudl-data-source"
compressed-lambdas-directory = "compressed_lambdas"
lambda-jar-bucket            = "cul-cudl.mvn.cudl.lib.cam.ac.uk"

transform-lambda-bucket-sns-notifications = [

]
transform-lambda-bucket-sqs-notifications = [
  {
    "type"          = "SQS",
    "queue_name"    = "EpsilonIndexTEIQueue"
    "filter_prefix" = "solr-json/tei/"
    "filter_suffix" = ".json"
    "bucket_name"   = "releases"
  }
]
transform-lambda-information = [
  {
    "name"                     = "AWSLambda_TEI_SOLR_Listener"
    "image_uri"                = "330100528433.dkr.ecr.eu-west-1.amazonaws.com/epsilon/solr-listener@sha256:af9641da791dbc525e5e48452277d6e87efb77026f37a272ec36fc259b0f87c6"
    "queue_name"               = "EpsilonIndexTEIQueue"
    "queue_delay_seconds"      = 10
    "vpc_name"                 = "epsilon-production-epsilon-ecs-vpc"
    "subnet_names"             = ["epsilon-production-epsilon-ecs-subnet-private-eu-west-1a", "epsilon-production-epsilon-ecs-subnet-private-eu-west-1b"]
    "security_group_names"     = ["epsilon-production-epsilon-ecs-vpc-egress", "epsilon-production-solr-external"]
    "timeout"                  = 180
    "memory"                   = 1024
    "batch_window"             = 2
    "batch_size"               = 1
    "maximum_concurrency"      = 100
    "use_datadog_variables"    = false
    "use_additional_variables" = true
    "environment_variables" = {
      API_HOST = "solr-api-epsilon-ecs.epsilon-production-solr"
      API_PORT = "8081"
      API_PATH = "item"
    }
  }
]
dst-efs-prefix    = "/mnt/cudl-data-releases"
dst-prefix        = "html/"
dst-s3-prefix     = ""
tmp-dir           = "/tmp/dest/"
lambda-alias-name = "LIVE"

releases-root-directory-path        = "/data"
efs-name                            = "cudl-data-releases-efs"
cloudfront_route53_zone_id          = "Z02382343G7Z7F9QNC05L"
cloudfront_distribution_name        = "production"
cloudfront_origin_path              = "/www"
cloudfront_error_response_page_path = "/404.html"
cloudfront_default_root_object      = "index.html"
cloudfront_access_logging           = true
cloudfront_access_logging_bucket    = "production-darwin-cloudfront-access-logs.s3.amazonaws.com"

# Base Architecture
cluster_name_suffix            = "epsilon-ecs"
registered_domain_name         = "epsilon.ac.uk."
asg_desired_capacity           = 1 # n = number of tasks
asg_max_size                   = 1 # n + 1
asg_allow_all_egress           = true
ec2_instance_type              = "t3.large"
ec2_additional_userdata        = <<-EOF
echo 1 > /proc/sys/vm/swappiness
echo ECS_RESERVED_MEMORY=256 >> /etc/ecs/ecs.config
EOF
route53_zone_id_existing       = "Z02382343G7Z7F9QNC05L"
route53_zone_force_destroy     = false
acm_certificate_arn            = "arn:aws:acm:eu-west-1:330100528433:certificate/8787e264-e102-4836-a6f4-fbdd47274209"
acm_certificate_arn_us-east-1  = "arn:aws:acm:us-east-1:330100528433:certificate/91731dd2-c03b-487d-91c0-535e1bc24299"
alb_enable_deletion_protection = false
alb_idle_timeout               = "900"
vpc_cidr_block                 = "10.75.0.0/22" #1024 adresses
vpc_public_subnet_public_ip    = false
cloudwatch_log_group           = "/ecs/epsilon-production"

# SOLR Worload
solr_name_suffix       = "solr"
solr_domain_name       = "search"
solr_application_port  = 8983
solr_target_group_port = 8081
solr_ecr_repositories = {
  "epsilon/solr-api" = "sha256:60a4e7a16e1f452ec059af498a6e92aca836d09a23fa1e63acc6e3138e636881",
  "epsilon/solr"     = "sha256:8cd12771b9770ce8bc61ae39863311669d372c1dbcfeff2d268310d783baaf99"
}
solr_ecs_task_def_volumes     = { "solr-volume" = "/var/solr" }
solr_container_name_api       = "solr-api"
solr_container_name_solr      = "solr"
solr_health_check_status_code = "404"
solr_allowed_methods          = ["HEAD", "GET", "OPTIONS"]
solr_ecs_task_def_cpu         = 2048
solr_use_service_discovery    = true
