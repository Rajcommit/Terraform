# Terraform Infrastructure Project - Complete History

**Project Name:** Multi-Tier AWS Infrastructure  
**Owner:** RAjAbhishek  
**Started:** February 3, 2026  
**Last Updated:** February 6, 2026  
**Status:** ✅ Deployed & Running  
**Region:** ap-south-1 (Mumbai)  
**Terraform Cloud:** Organization "RAjAbhishek", Workspace "Terraform_cli"

---

## Project Vision

Build a **production-ready, enterprise-grade, multi-tier web application infrastructure** using Terraform modules. The goal is to create something complex but doable for daily use, maximizing practical learning and real-world application.

---

## Architecture Overview

```
VPC (10.2.0.0/16)
├── Public Subnets (2 AZs)
│   ├── 10.2.0.0/24 (ap-south-1a)
│   └── 10.2.1.0/24 (ap-south-1b)
├── Private Subnets (2 AZs)
│   ├── 10.2.10.0/24 (ap-south-1a)
│   └── 10.2.11.0/24 (ap-south-1b)
├── Internet Gateway (public access)
├── NAT Gateway (private subnet internet)
└── EC2 Instances (private subnets)
    ├── Apache web server
    ├── IAM roles (SSM + CloudWatch)
    ├── Security groups (SSH, HTTP, HTTPS)
    └── Enhanced monitoring
```

---

## Project Structure

```
/mnt/s/terraform/modules/
├── main.tf                    # Root orchestration
├── variable.tf                # Root variables
├── output.tf                  # Root outputs
├── localfile.tf               # Local file generation
├── PROJECT_HISTORY.md         # This file
├── blueprint/                 # Planning & documentation
│   ├── CHECKPOINT.md         # Detailed progress tracker
│   ├── FUTUREPLAN.md         # Future enhancements
│   └── README.md             # Blueprint overview
└── module/                    # Reusable Terraform modules
    ├── network/              # VPC, subnets, gateways
    │   ├── network.tf
    │   ├── variable.tf
    │   └── outputnetwork.tf
    ├── compute/              # EC2, security groups, IAM
    │   ├── compute.tf
    │   ├── iam.tf
    │   ├── variable.tf
    │   └── output.tf
    └── loadbalancer/         # ALB (in progress)
        ├── loadbalancer.tf
        ├── variable.tf
        └── output.tf
```

---

## Complete Session History

### **Session 1: Feb 3, 2026 - Project Inception**

**Goal:** Create enterprise-grade infrastructure for daily use

**Key Decisions:**
- Improve existing code rather than start from scratch
- Use modular architecture for reusability
- Implement checkpoint system for session recovery
- Plan for 4 subnets across 2 AZs

**Subnet Strategy:**
- Public: 10.2.0.0/24, 10.2.1.0/24 (for ALB, NAT Gateway)
- Private: 10.2.10.0/24, 10.2.11.0/24 (for EC2, RDS)

**Created:**
- Blueprint folder structure
- CHECKPOINT.md for progress tracking
- Initial network and compute modules

---

### **Session 2: Feb 4, 2026 - Building & Debugging**

**Major Issues Resolved:**

1. **Variable Declaration Errors**
   - Fixed: "Unexpected attribute: environment"
   - Learned: Proper variable declaration in modules

2. **Module Communication**
   - Issue: Subnet errors, VPC reference errors
   - Fixed: `module.network.vpc` → `module.network.vpc_id`
   - Learned: Outputs must match exact names

3. **Security Group Typo**
   - Fixed: `aws_securtiy_group` → `aws_security_group`
   - Learned: Terraform resource naming is strict

4. **Template Interpolation**
   - Issue: Cannot interpolate tuple directly in string
   - Fixed: Used `join(", ", module.network.private_subnet_ids)`
   - Learned: Difference between `for_each` and direct interpolation

5. **Provisioner Understanding**
   - Learned: `local-exec` runs commands on local machine
   - Learned: `self` references current resource

**Key Learning: "Do I learn fast or am I dumb?"**
- Answer: Learning well! Asking the right questions.

**Dynamic Blocks Mastery:**
- Problem: Repetitive ingress rules
- Solution: `dynamic "ingress"` blocks
- Learned: When to use dynamic vs static blocks
- Understood: Egress doesn't need dynamic (single rule)

**Architecture Understanding:**
- Question: "Why private subnets, not public?"
- Answer: Security best practice - EC2 in private, ALB in public
- Learned: main.tf communicates via module outputs only

**Future Planning:**
- Wanted: GitHub Actions & Docker integration
- Decision: Focus on current goals, added to FUTUREPLAN.md

---

### **Session 3: Feb 4, 2026 Evening - Security & IAM**

**Implemented:**

1. **Dynamic Security Group Rules**
   - SSH (port 22)
   - HTTP (port 80)
   - HTTPS (port 443)
   - Egress (all outbound)

2. **IAM Roles & Policies**
   - Created IAM role for EC2
   - Attached SSM policy (Session Manager access)
   - Attached CloudWatch policy (logs & metrics)
   - Configured instance profile

3. **User Data Scripts**
   - Automatic Apache installation
   - Custom welcome page per instance
   - Shows instance ID and environment

4. **Enhanced Monitoring**
   - Enabled detailed CloudWatch monitoring
   - Custom root volume (20GB gp3)
   - Volume encryption enabled

5. **Security Improvements**
   - Fixed egress rule (was blocking outbound!)
   - Proper tagging on all resources

**Status:** ✅ Infrastructure validated and deployed successfully

---

### **Session 4: Feb 5, 2026 - Module Communication Deep Dive**

**The Big Questions:**

1. **"How to pass network to compute?"**
   - Learned: 3-step flow
     1. Network module outputs data
     2. Root main.tf connects modules
     3. Compute module receives via variables

2. **Circular Reference Issue**
   - Problem: `vpc_cidr = module.network.vpc_cidr` ❌
   - Why wrong: Module can't reference its own output as input
   - Solution: Use direct value or variable default

3. **"subnet_id or subnet_ids?"**
   - `subnet_ids` = Variable holding list (plural)
   - `subnet_id` = AWS resource attribute (singular)
   - Each instance gets ONE subnet from the list

4. **"Is it necessary to give it in main.tf?"**
   - Answer: No, if variable has default in variable.tf
   - Can override when needed

5. **Variable Defaults vs Explicit Values**
   - Defaults: For standard/common values
   - Override: For environment-specific values

**Final Fixes:**

- Removed circular reference in main.tf
- Fixed `Length()` → `length()` (case sensitivity matters!)
- Corrected: `subnet_ids` → `private_subnet_ids`
- Cleaned up main.tf to use defaults

**Status:** ✅ All issues resolved, infrastructure running

---

## What's Been Built

### ✅ **Phase 1: Networking Foundation (COMPLETED)**
- VPC module (10.2.0.0/16)
- Subnets (2 public + 2 private across 2 AZs)
- Internet Gateway
- NAT Gateway
- Route Tables (public & private)
- Network outputs configured

### ✅ **Phase 2: Compute Layer (COMPLETED)**
- Security Groups with dynamic rules
- EC2 instances in private subnets
- Multi-AZ distribution
- Proper module communication
- IAM roles & instance profiles
- User data scripts
- Enhanced monitoring
- Encrypted volumes

### ✅ **Phase 3: IAM & Enhanced Features (COMPLETED)**
- IAM roles for EC2
- SSM policy (Session Manager - no SSH keys needed!)
- CloudWatch policy (logs & metrics)
- Security best practices

### ⚠️ **Phase 4: Load Balancer (IN PROGRESS)**
- Basic structure created
- Not yet fully implemented

---

## Key Concepts Mastered

### 1. **Module Architecture**
- Modules are self-contained, reusable components
- Communication via outputs → root → variables
- Never reference same module's output as input

### 2. **Terraform Fundamentals**
- Variables can have defaults
- Outputs expose data to other modules
- Functions are case-sensitive (`length` not `Length`)
- Template interpolation requires proper types

### 3. **Dynamic Blocks**
- Use for repetitive nested blocks
- Syntax: `dynamic "block_name" { for_each = ... }`
- Not needed when only one block

### 4. **Security Best Practices**
- EC2 in private subnets
- ALB in public subnets
- NAT Gateway for private subnet internet
- IAM roles instead of hardcoded credentials
- Session Manager instead of SSH keys

### 5. **AWS Resource Relationships**
- VPC contains subnets
- Subnets require VPC ID
- Security groups require VPC ID
- Instances require subnet ID and security group IDs

---

## Common Errors & Solutions

### Error: Circular Reference
```hcl
# ❌ WRONG
module "network" {
  vpc_cidr = module.network.vpc_cidr
}

# ✅ CORRECT
module "network" {
  vpc_cidr = "10.2.0.0/16"
}
```

### Error: Wrong Output Reference
```hcl
# ❌ WRONG
subnet_ids = module.network.subnet_ids

# ✅ CORRECT
subnet_ids = module.network.private_subnet_ids
```

### Error: Template Interpolation
```hcl
# ❌ WRONG
"Subnets: ${module.network.private_subnet_ids}"

# ✅ CORRECT
"Subnets: ${join(", ", module.network.private_subnet_ids)}"
```

### Error: Case Sensitivity
```hcl
# ❌ WRONG
count.index % Length(var.subnet_ids)

# ✅ CORRECT
count.index % length(var.subnet_ids)
```

---

## Current Infrastructure Details

### Network Layer
- **VPC CIDR:** 10.2.0.0/16
- **Public Subnets:** 10.2.0.0/24, 10.2.1.0/24
- **Private Subnets:** 10.2.10.0/24, 10.2.11.0/24
- **Availability Zones:** ap-south-1a, ap-south-1b
- **Internet Gateway:** Yes
- **NAT Gateway:** Yes (in public subnet)

### Compute Layer
- **Instance Type:** t3.micro
- **Instance Count:** 2 (configurable)
- **Placement:** Private subnets (multi-AZ)
- **OS:** Amazon Linux 2
- **Web Server:** Apache (auto-installed)
- **Root Volume:** 20GB gp3, encrypted
- **Monitoring:** Detailed CloudWatch enabled

### Security
- **Security Groups:** Dynamic rules (SSH, HTTP, HTTPS)
- **IAM Role:** EC2 instance role
- **Policies:** SSM, CloudWatch
- **Access Method:** AWS Session Manager (no SSH keys!)

### Outputs Available
- VPC ID
- Subnet IDs (public & private)
- Instance IDs
- AMI ID
- Security Group IDs
- Gateway IDs

---

## Next Steps (Planned)

### Phase 4: Load Balancing & Auto Scaling
- [ ] Application Load Balancer
- [ ] Target Groups
- [ ] Launch Template
- [ ] Auto Scaling Group
- [ ] Health checks
- [ ] SSL/TLS certificates

### Phase 5: Database Layer
- [ ] RDS subnet group
- [ ] RDS instance (PostgreSQL)
- [ ] ElastiCache subnet group
- [ ] ElastiCache cluster (Redis)
- [ ] S3 buckets for storage
- [ ] Database security groups
- [ ] Backup configuration

### Phase 6: Monitoring & Alerts
- [ ] CloudWatch dashboards
- [ ] CloudWatch alarms
- [ ] SNS topics for notifications
- [ ] Lambda for automated responses
- [ ] Log aggregation
- [ ] Metrics collection

### Phase 7: CI/CD Integration
- [ ] GitHub Actions workflows
- [ ] Terraform validation on PRs
- [ ] Auto-deploy on merge
- [ ] Docker integration
- [ ] ECR for container registry
- [ ] Security scanning (tfsec, trivy)

### Phase 8: Advanced Features
- [ ] Multi-region deployment
- [ ] Disaster recovery setup
- [ ] Blue-green deployment
- [ ] WAF rules
- [ ] Secrets Manager
- [ ] KMS encryption keys

---

## How to Use This Project

### Prerequisites
```bash
terraform >= 1.0
AWS CLI configured
Terraform Cloud account (optional)
```

### Initialize
```bash
cd /mnt/s/terraform/modules
terraform init
```

### Validate
```bash
terraform validate
```

### Plan
```bash
terraform plan
```

### Apply
```bash
terraform apply
```

### Destroy
```bash
terraform destroy
```

### Access Instances
Use AWS Session Manager (no SSH keys needed):
```bash
aws ssm start-session --target <instance-id>
```

---

## Important Notes

### Module Communication Flow
```
Network Module (outputs) 
    ↓
Root main.tf (connects)
    ↓
Compute Module (variables)
```

### Variable Priority
1. Command line flags: `-var`
2. Variable files: `terraform.tfvars`
3. Environment variables: `TF_VAR_*`
4. Default values in `variable.tf`

### Best Practices Followed
- ✅ Modular architecture
- ✅ Private subnets for compute
- ✅ IAM roles (no hardcoded credentials)
- ✅ Encrypted volumes
- ✅ Multi-AZ deployment
- ✅ Dynamic blocks for DRY code
- ✅ Comprehensive outputs
- ✅ Proper tagging

---

## Troubleshooting

### Issue: Module not found
**Solution:** Run `terraform init` to download modules

### Issue: State lock error
**Solution:** Use `-lock=false` flag (not recommended for production)

### Issue: Circular dependency
**Solution:** Check module inputs aren't referencing same module outputs

### Issue: Invalid template interpolation
**Solution:** Use `join()` for lists in string templates

---

## Learning Resources

### Terraform Documentation
- [Terraform Modules](https://www.terraform.io/docs/language/modules/index.html)
- [Dynamic Blocks](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html)
- [Functions](https://www.terraform.io/docs/language/functions/index.html)

### AWS Best Practices
- [VPC Design](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Scenario2.html)
- [IAM Roles for EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html)
- [Session Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html)

---

## Project Milestones

- ✅ **Feb 3, 2026:** Project started, blueprint created
- ✅ **Feb 4, 2026:** Network module completed
- ✅ **Feb 4, 2026:** Compute module completed
- ✅ **Feb 4, 2026:** Security groups & IAM implemented
- ✅ **Feb 5, 2026:** Module communication mastered
- ✅ **Feb 5, 2026:** Infrastructure deployed successfully
- 📝 **Feb 6, 2026:** Project history documented

---

## Contact & References

**Terraform Cloud:** RAjAbhishek/Terraform_cli  
**Region:** ap-south-1  
**Project Location:** `/mnt/s/terraform/modules/`

**Related Files:**
- `blueprint/CHECKPOINT.md` - Detailed progress tracker
- `blueprint/FUTUREPLAN.md` - Future enhancements
- `blueprint/README.md` - Blueprint overview

---

**Last Updated:** February 6, 2026, 10:27 AM IST  
**Status:** Active Development ✅  
**Next Session:** Continue with Load Balancer implementation
