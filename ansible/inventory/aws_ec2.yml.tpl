plugin: aws_ec2
regions:
  - ap-south-1
filters:
  tag:Name: miniserver-*
  instance-state-name: running
keyed_groups:
   - key: tags.Role
     perfix: role
compose:
   ansible_host: instance_id
   ansible_connection: "'amazon.aws.aws_ssm'"
   ansible_aws_ssm_region: "'ap-south-1'"
   ansible_aws_ssm_bucket_name: "'${ssm_bucket_name}'"
