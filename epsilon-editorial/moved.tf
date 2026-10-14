# cudl-data-processing v1.3.0 switched the SQS event source mappings from count to
# for_each keyed by list index, so [n] becomes ["n"]. Without this the mapping is
# destroyed and recreated, which can conflict on the same queue/function pair.
moved {
  from = module.cudl-data-processing.aws_lambda_event_source_mapping.sqs-trigger-lambda-transforms[0]
  to   = module.cudl-data-processing.aws_lambda_event_source_mapping.sqs-trigger-lambda-transforms["0"]
}
