## File: chcek.tf 
# Purpose: Post-deploy health verification for ALB
# Does NOT block deploy — warns only

check "alb_health" {
    data "http" "alb_response" { 
     url = "http://${aws_lb.application_load_balancer.dns_name}/healthz"
}

assert{
      condition = data.http.alb_response.status_code == 200
      error_message = "ALB is not returning HTTP 200! App may not be running. Got: ${data.http.alb_response.status_code}"
}
}