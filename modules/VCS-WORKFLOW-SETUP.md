# VCS-Driven Workflow Setup Guide

## 🎯 Goal
Set up GitOps workflow where code changes trigger automatic Terraform plans and applies through HCP Terraform (Terraform Cloud).

---

## 📋 Prerequisites

✅ **Already Done:**
- Git repository: `git@github.com:Rajcommit/Terraform.git`
- HCP Terraform account: Organization "RAjAbhishek"
- Workspace: "Terraform_cli"
- Code committed and pushed to GitHub

---

## 🔧 Step-by-Step Setup

### **Step 1: Connect GitHub to HCP Terraform**

1. **Go to HCP Terraform:**
   - Visit: https://app.terraform.io
   - Login to your account
   - Navigate to organization: **RAjAbhishek**

2. **Go to Workspace Settings:**
   - Click on workspace: **Terraform_cli**
   - Go to **Settings** → **Version Control**

3. **Connect to GitHub:**
   - Click **Connect to version control**
   - Select **GitHub.com**
   - Authorize HCP Terraform to access your GitHub account
   - Select repository: **Rajcommit/Terraform**
   - Set **Working Directory**: `modules`
   - Click **Create workspace**

### **Step 2: Configure Workspace Settings**

1. **Set Terraform Working Directory:**
   - Settings → General
   - Terraform Working Directory: `modules`
   - Save settings

2. **Configure Auto-Apply (Optional):**
   - Settings → General
   - **Auto Apply**: 
     - ✅ Enable for automatic applies (risky but convenient)
     - ❌ Disable for manual approval (safer for production)
   - Recommendation: **Disable for now** (manual approval)

3. **Set VCS Triggers:**
   - Settings → Version Control
   - **VCS branch**: `master` (or `main`)
   - **Automatic Run Triggering**: ✅ Enabled
   - **Pull Request Runs**: ✅ Enabled (runs plan on PRs)

4. **Configure AWS Credentials:**
   - Settings → Variables
   - Add **Environment Variables**:
     - `AWS_ACCESS_KEY_ID` (mark as sensitive)
     - `AWS_SECRET_ACCESS_KEY` (mark as sensitive)
     - `AWS_DEFAULT_REGION` = `ap-south-1`

---

## 🚀 The VCS-Driven Workflow

### **Workflow Diagram:**

```
┌─────────────────────────────────────────────────────────────┐
│  Developer Workflow                                         │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  1. Create Feature Branch                                   │
│     git checkout -b feature/add-alb-security-group          │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  2. Make Changes to Terraform Code                          │
│     - Edit loadbalancer.tf                                  │
│     - Add security group resource                           │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  3. Commit and Push                                         │
│     git add .                                               │
│     git commit -m "feat: add ALB security group"            │
│     git push origin feature/add-alb-security-group          │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  4. Open Pull Request on GitHub                             │
│     - Go to GitHub repository                               │
│     - Click "Compare & pull request"                        │
│     - Add description                                       │
│     - Create PR                                             │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  5. HCP Terraform Automatically:                            │
│     ✓ Detects new PR                                        │
│     ✓ Runs terraform init                                   │
│     ✓ Runs terraform plan                                   │
│     ✓ Posts plan as PR comment                              │
│     ✓ Shows: "2 to add, 1 to change, 0 to destroy"         │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  6. Review Plan in PR                                       │
│     - Team reviews the plan                                 │
│     - Check what will be created/changed                    │
│     - Discuss in PR comments                                │
│     - Request changes if needed                             │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  7. Approve and Merge PR                                    │
│     - Approve PR on GitHub                                  │
│     - Click "Merge pull request"                            │
│     - Delete feature branch                                 │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  8. HCP Terraform Automatically:                            │
│     ✓ Detects merge to master                               │
│     ✓ Runs terraform plan again                             │
│     ✓ Waits for manual approval (if auto-apply disabled)    │
│     OR                                                       │
│     ✓ Runs terraform apply (if auto-apply enabled)          │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  9. Manual Approval (if needed)                             │
│     - Go to HCP Terraform UI                                │
│     - Review plan one more time                             │
│     - Click "Confirm & Apply"                               │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  10. Infrastructure Updated! 🎉                             │
│      - Resources created in AWS                             │
│      - State stored in HCP Terraform                        │
│      - Full audit trail in Git + HCP Terraform              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🧪 Test the Workflow

Let's test with a simple change:

### **Test 1: Add a Tag to VPC**

```bash
# 1. Create feature branch
git checkout -b test/add-vpc-tag

# 2. Edit network.tf - add a tag
# In module/network/network.tf, add to VPC tags:
#   TestTag = "VCS-Workflow-Test"

# 3. Commit and push
git add module/network/network.tf
git commit -m "test: add test tag to VPC"
git push origin test/add-vpc-tag

# 4. Open PR on GitHub
# 5. Watch HCP Terraform run plan automatically
# 6. Review plan in PR comments
# 7. Merge PR
# 8. Approve apply in HCP Terraform UI
```

### **Test 2: Fix Load Balancer Security Group (Real Change)**

```bash
# 1. Create feature branch
git checkout -b feature/fix-alb-security-group

# 2. Edit loadbalancer.tf
# Add security group resource (see below)

# 3. Commit and push
git add module/loadbalancer/loadbalancer.tf
git commit -m "feat: add ALB security group in loadbalancer module"
git push origin feature/fix-alb-security-group

# 4. Open PR
# 5. Review plan
# 6. Merge and apply
```

---

## 📝 Example: Fix ALB Security Group

**Current Issue:** `main.tf` references `module.network.alb_security_group_id` which doesn't exist.

**Solution:** Create security group in loadbalancer module.

**Add to `module/loadbalancer/loadbalancer.tf`:**

```hcl
# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project_name}-alb-sg"
    }
  )
}
```

**Update ALB resource to use it:**

```hcl
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]  # ← Use local SG
  subnets            = var.public_subnet_ids
  
  tags = merge(
    local.common_tags,
    {
      Name = "${var.environment}-alb"
    }
  )
}
```

**Remove from `module/loadbalancer/variable.tf`:**

```hcl
# DELETE THIS VARIABLE - no longer needed
# variable "alb_security_group" {
#   description = "The security group ID for the Application Load Balancer"
#   type        = string
# }
```

**Update `main.tf`:**

```hcl
module "loadbalancer" {
  source            = "./module/loadbalancer"
  environment       = var.environment
  # alb_security_group removed - created internally now
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  project_name      = "miniserver"
}
```

---

## 🎓 Benefits of VCS-Driven Workflow

### **1. Version Control**
- Every change tracked in Git
- Full history of infrastructure changes
- Easy rollback with `git revert`

### **2. Code Review**
- Team reviews changes before apply
- Catch errors early
- Knowledge sharing

### **3. Automation**
- No manual `terraform plan` needed
- Consistent process every time
- Reduces human error

### **4. Audit Trail**
- Who changed what, when
- Why (commit messages)
- What was the result (plan output)

### **5. Collaboration**
- Multiple people can work safely
- Feature branches prevent conflicts
- Clear approval process

### **6. Safety**
- Plan runs before apply
- Manual approval gate
- Can't accidentally destroy resources

---

## 🔒 Security Best Practices

### **1. Protect Master Branch**
- Settings → Branches → Add rule
- Branch name pattern: `master`
- ✅ Require pull request reviews
- ✅ Require status checks (Terraform plan)
- ✅ Require branches to be up to date

### **2. Sensitive Variables**
- Never commit secrets to Git
- Use HCP Terraform variables (marked sensitive)
- Use AWS IAM roles when possible

### **3. State File Security**
- State stored in HCP Terraform (encrypted)
- Never commit `.tfstate` files
- Access controlled by HCP Terraform

---

## 📊 Monitoring and Notifications

### **1. Slack Integration**
- Settings → Notifications
- Add Slack webhook
- Get notified on:
  - Plan started
  - Plan completed
  - Apply started
  - Apply completed
  - Errors

### **2. Email Notifications**
- Settings → Notifications
- Add email addresses
- Configure notification preferences

---

## 🐛 Troubleshooting

### **Issue: Plan not running on PR**
**Solution:** 
- Check VCS settings in workspace
- Ensure "Pull Request Runs" is enabled
- Verify GitHub webhook is active

### **Issue: AWS credentials error**
**Solution:**
- Check environment variables in workspace
- Ensure credentials are marked as sensitive
- Verify IAM permissions

### **Issue: Working directory error**
**Solution:**
- Settings → General
- Set Terraform Working Directory: `modules`
- Save and retry

---

## 📚 Next Steps

1. **Complete Setup:**
   - Connect GitHub to HCP Terraform
   - Configure workspace settings
   - Add AWS credentials

2. **Test Workflow:**
   - Create test branch
   - Make small change
   - Open PR and watch automation

3. **Fix ALB Security Group:**
   - Use VCS workflow to fix the issue
   - Experience the full process

4. **Add More Features:**
   - Continue with load balancer
   - Add database layer
   - Implement monitoring

---

## 🎯 Success Criteria

You'll know it's working when:
- ✅ PR triggers automatic plan
- ✅ Plan results appear as PR comment
- ✅ Merge triggers apply workflow
- ✅ Infrastructure updates automatically
- ✅ Full audit trail in Git + HCP Terraform

---

**Ready to experience production-grade GitOps? Let's do this! 🚀**
