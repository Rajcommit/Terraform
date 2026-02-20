# 🏗️ MiniServer Multi-Tier AWS Architecture

**Generated**: 2026-02-20  
**Region**: ap-south-1 (Mumbai)  
**Organization**: RajBuild  
**Workspace**: Terraform_cli

---

## 📊 Architecture Diagrams

- **Visual Diagram**: `architecture-diagram.png` (Python Diagrams library)
- **Editable Diagram**: `architecture-diagram.drawio` (Draw.io/diagrams.net compatible)

---

## 🎯 Architecture Overview

Production-ready 3-tier web application infrastructure with:
- **High Availability**: Multi-AZ deployment across 2 availability zones
- **Auto Scaling**: Dynamic scaling (2-4 instances) based on demand
- **Security**: Private subnets, security groups, IAM roles, Secrets Manager
- **Database**: MySQL RDS + Redis cache for performance
- **Load Balancing**: Application Load Balancer with health checks

---

## 🏛️ Infrastructure Components

### **Network Layer** (VPC: 10.2.0.0/16)

| Component | Details |
|-----------|---------|
| **VPC** | 10.2.0.0/16 (65,536 IPs) |
| **Public Subnets** | 10.2.0.0/24, 10.2.1.0/24 (512 IPs each) |
| **Private Subnets** | 10.2.10.0/24, 10.2.11.0/24 (512 IPs each) |
| **Internet Gateway** | Public internet access |
| **NAT Gateway** | Private subnet outbound access |
| **Route Tables** | Separate for public/private |

### **Compute Layer**

| Component | Configuration |
|-----------|---------------|
| **Auto Scaling Group** | Min: 2, Max: 4, Desired: 2 |
| **Instance Type** | t3.micro (2 vCPU, 1GB RAM) |
| **AMI** | Amazon Linux 2023 |
| **Web Server** | Apache (auto-installed via user data) |
| **Monitoring** | CloudWatch detailed monitoring |
| **IAM Role** | SSM + CloudWatch permissions |

### **Load Balancer**

| Component | Configuration |
|-----------|---------------|
| **Type** | Application Load Balancer (Layer 7) |
| **Scheme** | Internet-facing |
| **Subnets** | Public subnets (Multi-AZ) |
| **Target Group** | HTTP:80 with health checks |
| **Health Check** | Path: /, Interval: 30s, Timeout: 5s |
| **Listener** | HTTP:80 → Target Group |

### **Database Layer**

#### MySQL RDS
| Component | Configuration |
|-----------|---------------|
| **Engine** | MySQL 8.0 |
| **Instance** | db.t3.micro (2 vCPU, 1GB RAM) |
| **Storage** | 20GB gp3 |
| **Database** | appdb |
| **Port** | 3306 |
| **Subnets** | Private (Multi-AZ capable) |
| **Credentials** | AWS Secrets Manager |

#### Redis Cache
| Component | Configuration |
|-----------|---------------|
| **Engine** | Redis 7 |
| **Node Type** | cache.t3.micro |
| **Nodes** | 1 |
| **Port** | 6379 |
| **Subnets** | Private |
| **Use Case** | Session storage, caching |

### **Security & Management**

| Component | Purpose |
|-----------|---------|
| **Secrets Manager** | Stores DB credentials (auto-generated 16-char password) |
| **IAM Role** | EC2 instance permissions (SSM, CloudWatch) |
| **Security Groups** | 4 groups (ALB, EC2, RDS, Redis) |
| **CloudWatch** | Metrics, logs, monitoring |

---

## 🔄 Traffic Flow

### **Inbound User Request**
```
Internet User
    ↓ (HTTPS/HTTP)
Internet Gateway
    ↓ (HTTP:80)
Application Load Balancer (Public Subnet)
    ↓ (Target Group)
EC2 Instances (Private Subnet - Auto Scaling)
    ↓
├─→ MySQL RDS (Port 3306) - Persistent Data
└─→ Redis Cache (Port 6379) - Session/Cache
```

### **Outbound Traffic (Private Instances)**
```
EC2 Instance (Private Subnet)
    ↓
NAT Gateway (Public Subnet)
    ↓
Internet Gateway
    ↓
Internet (Updates, APIs, etc.)
```

---

## 🔒 Security Architecture

### Security Groups

#### 1. ALB Security Group
```
Ingress:
  - HTTP (80) from 0.0.0.0/0
Egress:
  - All traffic
```

#### 2. EC2 Security Group
```
Ingress:
  - SSH (22) from 0.0.0.0/0
  - HTTP (80) from ALB Security Group only
  - HTTPS (443) from 0.0.0.0/0
Egress:
  - All traffic
```

#### 3. RDS Security Group
```
Ingress:
  - MySQL (3306) from VPC CIDR (10.2.0.0/16)
Egress:
  - All traffic
```

#### 4. Redis Security Group
```
Ingress:
  - Redis (6379) from VPC CIDR (10.2.0.0/16)
Egress:
  - All traffic
```

### IAM Permissions
- **AmazonSSMManagedInstanceCore**: Session Manager access (no SSH keys needed)
- **CloudWatchAgentServerPolicy**: Metrics and logs collection

---

## 📈 High Availability & Scalability

- ✅ **Multi-AZ**: Resources across 2 availability zones (ap-south-1a, ap-south-1b)
- ✅ **Auto Scaling**: 2-4 instances based on demand
- ✅ **Load Balancing**: Traffic distributed across healthy instances
- ✅ **Health Checks**: Automatic instance replacement if unhealthy
- ✅ **Private Subnets**: EC2 isolated from direct internet access
- ✅ **NAT Gateway**: Secure outbound internet for private instances

---

## 💰 Cost Optimization

| Strategy | Benefit |
|----------|---------|
| **t3.micro instances** | Burstable, cost-effective ($0.0104/hour) |
| **gp3 storage** | Better price/performance than gp2 |
| **Single NAT Gateway** | Shared across AZs (cost vs HA tradeoff) |
| **Auto Scaling** | Scales down during low traffic |
| **Single-AZ RDS** | Cost savings (can enable Multi-AZ later) |

**Estimated Monthly Cost**: ~$50-80 USD (varies with usage)

---

## 🚀 Deployment

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured
- HCP Terraform account (RajBuild organization)

### Deploy
```bash
cd /mnt/s/terraform/modules
terraform init
terraform plan
terraform apply
```

### Access Instances
```bash
# Via AWS Session Manager (no SSH keys needed)
aws ssm start-session --target <instance-id>
```

---

## 📊 Monitoring

- **CloudWatch Metrics**: CPU, memory, network, disk
- **Health Checks**: ALB monitors instance health every 30s
- **Detailed Monitoring**: Enabled on all EC2 instances
- **Logs**: Application logs via CloudWatch agent

---

## 🔮 Future Enhancements

- [ ] **SSL/TLS**: ACM certificate + HTTPS listener
- [ ] **WAF**: Web Application Firewall rules
- [ ] **CloudWatch Alarms**: CPU, memory, unhealthy targets
- [ ] **SNS Notifications**: Email/SMS alerts
- [ ] **S3 Bucket**: Backups and static assets
- [ ] **CloudFront CDN**: Global content delivery
- [ ] **Bastion Host**: Secure SSH access
- [ ] **Multi-AZ RDS**: High availability database
- [ ] **RDS Read Replicas**: Database scaling
- [ ] **Secrets Rotation**: Automated credential rotation

---

## 📝 Resource Summary

| Resource Type | Count | Location |
|---------------|-------|----------|
| VPC | 1 | ap-south-1 |
| Subnets | 4 (2 public + 2 private) | Multi-AZ |
| Internet Gateway | 1 | VPC |
| NAT Gateway | 1 | Public Subnet |
| Application Load Balancer | 1 | Public Subnets |
| Auto Scaling Group | 1 | Private Subnets |
| EC2 Instances | 2-4 | Private Subnets |
| RDS MySQL | 1 | Private Subnets |
| ElastiCache Redis | 1 | Private Subnets |
| Security Groups | 4 | VPC |
| Secrets Manager | 1 | Regional |
| IAM Role | 1 | Account |

---

## 🛠️ CI/CD Integration

- **GitHub**: Rajcommit/Terraform
- **HCP Terraform**: RajBuild/Terraform_cli
- **GitHub Actions**: Automated validation on push/PR
- **VCS-Driven**: GitOps workflow for infrastructure changes

---

## 📚 Documentation Files

- `ARCHITECTURE.md` - This file (architecture overview)
- `architecture-diagram.png` - Visual diagram
- `architecture-diagram.drawio` - Editable diagram
- `CHECKPOINT.md` - Project progress tracker
- `PROJECT_HISTORY.md` - Complete session history
- `EARLY_SESSIONS_SUMMARY.md` - Detailed session logs
- `FUTUREPLAN.md` - Planned enhancements

---

**Last Updated**: 2026-02-20T11:40:00+05:30  
**Status**: ✅ Deployed & Running  
**Terraform Version**: ~> 6.0
