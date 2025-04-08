environment                  = "editorial"
project                      = "epsilon"
component                    = "cudl-data-workflows"
subcomponent                 = "cudl-transform-lambda"
destination-bucket-name      = "releases"
web_frontend_domain_name     = "epsilon-editorial.epsilon.ac.uk"
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
    "image_uri"                = "330100528433.dkr.ecr.eu-west-1.amazonaws.com/epsilon/solr-listener@sha256:5f39a1ec9383065a2a90855849532b0eb24827e8887f0401a3b6017e418aeadf"
    "queue_name"               = "EpsilonIndexTEIQueue"
    "queue_delay_seconds"      = 10
    "vpc_name"                 = "epsilon-editorial-epsilon-ecs-vpc"
    "subnet_names"             = ["epsilon-editorial-epsilon-ecs-subnet-private-a", "epsilon-editorial-epsilon-ecs-subnet-private-b"]
    "security_group_names"     = ["epsilon-editorial-epsilon-ecs-vpc-egress", "epsilon-editorial-solr-external"]
    "timeout"                  = 180
    "memory"                   = 1024
    "batch_window"             = 2
    "batch_size"               = 1
    "maximum_concurrency"      = 5
    "use_datadog_variables"    = false
    "use_additional_variables" = true
    "environment_variables" = {
      API_HOST = "solr-api-epsilon-ecs.epsilon-editorial-solr"
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
cloudfront_route53_zone_id          = "Z028489118FY8DBPA2P7Q"
cloudfront_distribution_name        = "epsilon-editorial"
cloudfront_origin_path              = "/www"
cloudfront_error_response_page_path = "/404.html"
cloudfront_default_root_object      = "index.html"

# Base Architecture
cluster_name_suffix     = "epsilon-ecs"
registered_domain_name  = "epsilon.ac.uk."
asg_desired_capacity    = 1 # n = number of tasks
asg_max_size            = 1 # n + 1
asg_allow_all_egress    = true
ec2_instance_type       = "t3.large"
ec2_additional_userdata = <<-EOF
echo 1 > /proc/sys/vm/swappiness
echo ECS_RESERVED_MEMORY=256 >> /etc/ecs/ecs.config
EOF
#route53_delegation_set_id      = "N02288771HQRX5TRME6CM"
route53_zone_id_existing       = "Z028489118FY8DBPA2P7Q"
route53_zone_force_destroy     = true
alb_enable_deletion_protection = false
alb_idle_timeout               = "900"
vpc_cidr_block                 = "10.87.0.0/22" #1024 adresses
vpc_public_subnet_public_ip    = false
cloudwatch_log_group           = "/ecs/epsilon-editorial"

# SOLR Worload
solr_name_suffix       = "solr"
solr_domain_name       = "editorial-search"
solr_application_port  = 8983
solr_target_group_port = 8081
solr_ecr_repositories = {
  "epsilon/solr-api" = "sha256:f26af50c2280663aa99cf91b338d3356eae76e650edcc83c44408d4591576cc0",
  "epsilon/solr"     = "sha256:eb300986965baf9bc12168c7bbb8827c907ad4ec8a962cb0f54f33f4cf4ae8e8"
}
solr_ecs_task_def_volumes     = { "solr-volume" = "/var/solr" }
solr_container_name_api       = "solr-api"
solr_container_name_solr      = "solr"
solr_health_check_status_code = "404"
solr_allowed_methods          = ["HEAD", "GET", "OPTIONS"]
solr_ecs_task_def_cpu         = 2048
solr_use_service_discovery    = true
