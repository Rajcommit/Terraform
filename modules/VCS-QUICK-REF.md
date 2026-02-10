# VCS Workflow Quick Reference

## 🚀 Quick Commands

```bash
# Start new feature
git checkout -b feature/your-feature-name

# Make changes, then commit
git add .
git commit -m "feat: description of change"
git push origin feature/your-feature-name

# Open PR on GitHub
# HCP Terraform runs plan automatically

# After PR approval and merge
# HCP Terraform runs apply (manual approval needed)
```

## 📋 Commit Message Convention

```
feat: new feature
fix: bug fix
docs: documentation
refactor: code refactoring
test: testing
chore: maintenance
```

## 🔗 Important Links

- **GitHub Repo:** https://github.com/Rajcommit/Terraform
- **HCP Terraform:** https://app.terraform.io/app/RAjAbhishek/workspaces/Terraform_cli
- **AWS Console:** https://ap-south-1.console.aws.amazon.com/

## ⚡ Workflow States

1. **PR Created** → Plan runs automatically
2. **PR Merged** → Apply queued (needs approval)
3. **Apply Approved** → Infrastructure updated
4. **Apply Complete** → Check AWS console

## 🎯 Current Task

Fix ALB security group issue using VCS workflow!
