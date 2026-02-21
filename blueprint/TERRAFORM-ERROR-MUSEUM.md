# 🏛️ Terraform Error Museum
## A Collection of Errors, Solutions, and Lessons Learned

**Project**: Multi-Tier AWS Infrastructure
**Owner**: Raj
**Started**: February 2026
**Purpose**: Learn from every mistake, never repeat them

---

## 📊 Error Statistics
- **Total Errors Encountered**: 15+
- **Errors Resolved**: 15
- **Success Rate**: 100%
- **Most Common Error Type**: Circular Dependencies (5 occurrences)
- **Hardest Error**: Circular dependency in main.tf (took 3 attempts)
- **Fastest Fix**: Typo fixes (< 1 minute)

---

## 🎯 Error Categories

### 🔄 Circular Dependencies (5 errors)
### 📝 Syntax Errors (4 errors)
### 🔗 Reference Errors (3 errors)
### 📦 Module Errors (2 errors)
### 🔧 Configuration Errors (1 error)

---

## 🔄 CIRCULAR DEPENDENCY ERRORS

### Error #1: Output Variable Circular Reference
**Date**: 2026-02-16, 01:00 AM
**File**: `/mnt/s/terraform/modules/module/database/output.tf`

**Error Message**:
```
Error: Cycle: module.database.output.dbusername (expand), 
module.database.var.db_username (expand)
```

**What Happened**:
```hcl
# output.tf
output "dbusername" {
    value = var.db_username  # ❌ Outputting input variable
}

# database.tf
resource "aws_db_instance" "mysql" {
    username = var.db_username  # Uses the variable
}
```

**Why It Failed**:
- Tried to output a variable that's used by a resource
- Created loop: variable → resource → output → variable
- Terraform couldn't determine execution order

**Solution**:
```hcl
# Remove the output entirely, or output resource attribute
output "rds_endpoint" {
    value = aws_db_instance.mysql.endpoint  # ✅ From resource
}
```

**Lesson Learned**:
- Output GENERATED data (from resources), not INPUT data (from variables)
- Variables flow IN, outputs flow OUT
- Never create loops in data flow

**Real-World Analogy**:
Like asking someone to tell you what you just told them - creates confusion!

---

### Error #2: Module Self-Reference in main.tf
**Date**: 2026-02-16, 02:11 AM
**File**: `/mnt/s/terraform/modules/main.tf`

**Error Message**:
```
Error: Cycle: module.database.output.dbpassword (expand), 
module.database.var.db_password (expand), 
module.database.aws_db_instance.mysql
```

**What Happened**:
```hcl
# main.tf
module "database" {
  db_username = module.database.dbusername  # ❌ Self-reference!
  db_password = module.database.db_password # ❌ Self-reference!
}
```

**Why It Failed**:
- Module trying to get values from itself
- Can't reference module outputs as module inputs
- Chicken-and-egg problem

**Solution**:
```hcl
# Option 1: Use direct values
module "database" {
  db_username = "dbadmin"
  db_password = "ChangeMe123!"
}

# Option 2: Use defaults in module
# Don't pass these variables at all
```

**Lesson Learned**:
- Module can't reference its own outputs as inputs
- Use default values in module variables
- Pass values from OTHER modules, not same module

**Real-World Analogy**:
Like trying to lift yourself up by pulling your own hair!

---

### Error #3: Wrong Subnet Group Reference
**Date**: 2026-02-16, 02:08 AM
**File**: `/mnt/s/terraform/modules/module/database/database.tf`

**Error Message**:
```
Error: Cycle: module.database.var.db_username (expand), 
module.database.aws_db_instance.mysql
```

**What Happened**:
```hcl
resource "aws_db_instance" "mysql" {
    db_subnet_group_name = var.private_subnet_ids.rds  # ❌ Wrong!
}
```

**Why It Failed**:
- Tried to access `.rds` property on a list
- Lists don't have named properties
- Wrong data type (list vs string)

**Solution**:
```hcl
# First create subnet group
resource "aws_db_subnet_group" "main" {
    name       = "${var.project_name}-db-subnet"
    subnet_ids = var.private_subnet_ids  # ✅ Use list here
}

# Then reference it
resource "aws_db_instance" "mysql" {
    db_subnet_group_name = aws_db_subnet_group.main.name  # ✅ Use name
}
```

**Lesson Learned**:
- RDS needs subnet GROUP name, not subnet IDs
- Create subnet group first, then reference it
- Use resource references, not variable manipulation

**Real-World Analogy**:
Like giving someone a list of addresses instead of a building name!

---

### Error #4: Circular VPC CIDR Reference
**Date**: 2026-02-05 (Early sessions)
**File**: `/mnt/s/terraform/modules/main.tf`

**Error Message**:
```
Error: Cycle: module.network.vpc_cidr
```

**What Happened**:
```hcl
module "network" {
  vpc_cidr = module.network.vpc_cidr  # ❌ Self-reference!
}
```

**Why It Failed**:
- Trying to use network module's output as its own input
- Module can't reference itself during creation

**Solution**:
```hcl
# Option 1: Direct value
module "network" {
  vpc_cidr = "10.2.0.0/16"  # ✅
}

# Option 2: Use default in module
# Don't pass vpc_cidr at all
```

**Lesson Learned**:
- Module inputs come from: direct values, root variables, or OTHER modules
- Never: same module's outputs

---

### Error #5: Output Dependency Chain
**Date**: 2026-02-16, 01:53 AM
**File**: `/mnt/s/terraform/modules/module/database/output.tf`

**Error Message**:
```
Error: Cycle: module.database.output.rds_endpoint (expand), 
module.database.output.rds_port (expand), 
module.database.var.db_password (expand)
```

**What Happened**:
- Multiple outputs referencing variables used by resources
- Created complex dependency chain

**Solution**:
- Remove all variable outputs
- Keep only resource attribute outputs

**Lesson Learned**:
- Keep outputs simple
- Only output what external modules need
- Avoid complex dependency chains

---

## 📝 SYNTAX ERRORS

### Error #6: Variable Name Case Sensitivity
**Date**: 2026-02-15, 19:44 AM
**File**: `/mnt/s/terraform/modules/module/database/variable.tf`

**Error Message**:
```
Error: Reference to undeclared variable
```

**What Happened**:
```hcl
variable "Project_Name" {  # ❌ Capital letters
    type = string
}

# Later used as:
var.project_name  # ❌ Doesn't match!
```

**Why It Failed**:
- Terraform is case-sensitive
- `Project_Name` ≠ `project_name`

**Solution**:
```hcl
variable "project_name" {  # ✅ All lowercase
    type = string
}
```

**Lesson Learned**:
- Always use lowercase with underscores
- Terraform convention: `snake_case`
- Be consistent with naming

---

### Error #7: Function Case Sensitivity
**Date**: 2026-02-05 (Early sessions)
**File**: `/mnt/s/terraform/modules/module/compute/compute.tf`

**Error Message**:
```
Error: Unknown function "Length"
```

**What Happened**:
```hcl
count.index % Length(var.subnet_ids)  # ❌ Capital L
```

**Why It Failed**:
- Terraform functions are case-sensitive
- Must be lowercase

**Solution**:
```hcl
count.index % length(var.subnet_ids)  # ✅ Lowercase
```

**Lesson Learned**:
- All Terraform functions are lowercase
- `length()`, `merge()`, `join()`, etc.
- Never capitalize function names

---

### Error #8: CIDR Block Typo
**Date**: 2026-02-15, 23:35 PM
**File**: `/mnt/s/terraform/modules/module/database/security.tf`

**Error Message**:
```
Error: Incorrect attribute name
```

**What Happened**:
```hcl
ingress {
    cidr_block = [var.vpc_cidr]  # ❌ Singular
}
```

**Why It Failed**:
- AWS expects `cidr_blocks` (plural) for lists
- Used singular form

**Solution**:
```hcl
ingress {
    cidr_blocks = [var.vpc_cidr]  # ✅ Plural
}
```

**Lesson Learned**:
- `cidr_blocks` (plural) when using list `[]`
- `cidr_block` (singular) when using single string
- Check AWS documentation for exact attribute names

---

### Error #9: Merge Function Spacing
**Date**: 2026-02-15, 23:51 PM
**File**: `/mnt/s/terraform/modules/module/database/database.tf`

**Error Message**:
```
Warning: Inconsistent formatting
```

**What Happened**:
```hcl
tags = merge (  # ← Extra space
    local.common_tags,
    { Name = "value" }
)
```

**Why It Failed**:
- Not an error, but non-standard formatting
- Terraform prefers no space before `(`

**Solution**:
```hcl
tags = merge(  # ✅ No space
    local.common_tags,
    { Name = "value" }
)
```

**Lesson Learned**:
- Run `terraform fmt` to auto-fix formatting
- Follow Terraform style guide
- Consistency matters

---

## 🔗 REFERENCE ERRORS

### Error #10: Wrong Output Name
**Date**: 2026-02-05 (Early sessions)
**File**: `/mnt/s/terraform/modules/main.tf`

**Error Message**:
```
Error: Reference to undeclared output value
```

**What Happened**:
```hcl
subnet_ids = module.network.subnet_ids  # ❌ Wrong name
```

**Why It Failed**:
- Network module outputs `private_subnet_ids`
- Not `subnet_ids`

**Solution**:
```hcl
subnet_ids = module.network.private_subnet_ids  # ✅ Correct name
```

**Lesson Learned**:
- Check module's output.tf for exact names
- Output names must match exactly
- Use tab completion to avoid typos

---

### Error #11: Missing VPC ID
**Date**: 2026-02-05 (Early sessions)
**File**: `/mnt/s/terraform/modules/main.tf`

**Error Message**:
```
Error: Missing required argument "vpc_id"
```

**What Happened**:
```hcl
module "compute" {
  # vpc_id not passed
}
```

**Why It Failed**:
- Compute module needs VPC ID for security groups
- Variable has no default, so it's required

**Solution**:
```hcl
module "compute" {
  vpc_id = module.network.vpc_id  # ✅ Pass from network
}
```

**Lesson Learned**:
- Variables without defaults are required
- Pass values from other modules
- Check module's variable.tf for requirements

---

### Error #12: Template Interpolation
**Date**: 2026-02-04 (Early sessions)
**File**: `/mnt/s/terraform/modules/localfile.tf`

**Error Message**:
```
Error: Cannot include the given value in a string template
```

**What Happened**:
```hcl
"Subnets: ${module.network.private_subnet_ids}"  # ❌ List in string
```

**Why It Failed**:
- Tried to interpolate a list directly in string
- Lists need to be converted to strings

**Solution**:
```hcl
"Subnets: ${join(", ", module.network.private_subnet_ids)}"  # ✅
```

**Lesson Learned**:
- Use `join()` to convert lists to strings
- Can't directly interpolate complex types
- Use appropriate functions for data types

---

## 📦 MODULE ERRORS

### Error #13: Duplicate Locals Block
**Date**: 2026-02-16, 01:00 AM
**File**: `/mnt/s/terraform/modules/module/database/`

**Error Message**:
```
Error: Duplicate local value definition
A local value named "common_tags" was already defined at 
module/database/database.tf:2,3-8,4
```

**What Happened**:
```hcl
# database.tf
locals {
  common_tags = { ... }
}

# security.tf
locals {
  common_tags = { ... }  # ❌ Duplicate!
}
```

**Why It Failed**:
- Terraform combines ALL .tf files in a module
- Can't define same local twice

**Solution**:
```hcl
# Keep locals in ONE file only (database.tf)
# Remove from security.tf
# Both files can use local.common_tags
```

**Lesson Learned**:
- All .tf files in a module = one big file
- Define locals/variables/outputs once per module
- Can use them in any file within module

**Real-World Analogy**:
Like having two people with the same name in a small room - confusing!

---

### Error #14: Missing Required Argument
**Date**: 2026-02-16, 02:21 AM
**File**: `/mnt/s/terraform/modules/main.tf`

**Error Message**:
```
Error: Missing required argument
The argument "db_password" is required, but no definition was found.
```

**What Happened**:
```hcl
# variable.tf (in database module)
variable "db_password" {
    type = string
    # No default!
}

# main.tf
module "database" {
  # db_password not passed
}
```

**Why It Failed**:
- Variable has no default value
- Not passed in module call
- Therefore required

**Solution**:
```hcl
# Option 1: Add default in module
variable "db_password" {
    type    = string
    default = "ChangeMe123!"  # ✅
}

# Option 2: Pass in main.tf
module "database" {
  db_password = "ChangeMe123!"  # ✅
}
```

**Lesson Learned**:
- Variables without defaults are required
- Add defaults for optional variables
- Pass values for required variables

---

## 🔧 CONFIGURATION ERRORS

### Error #15: Security Group Missing Egress
**Date**: 2026-02-15, 19:52 PM
**File**: `/mnt/s/terraform/modules/module/database/security.tf`

**Error Message**:
```
Warning: Security group has no egress rules
```

**What Happened**:
```hcl
resource "aws_security_group" "rds" {
    ingress { ... }
    # No egress!
}
```

**Why It Failed**:
- Security groups need both ingress and egress
- Without egress, database can't respond

**Solution**:
```hcl
resource "aws_security_group" "rds" {
    ingress { ... }
    
    egress {  # ✅ Add egress
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
```

**Lesson Learned**:
- Always add egress rules
- Ingress = incoming, Egress = outgoing
- Both are needed for communication

---

## 📚 COMMON ERROR PATTERNS

### Pattern #1: Circular Dependencies
**Frequency**: 5 times
**Root Cause**: Misunderstanding data flow
**Prevention**: 
- Variables → Resources → Outputs (one direction)
- Never loop back
- Output generated data, not input data

### Pattern #2: Typos
**Frequency**: 4 times
**Root Cause**: Fast typing, not checking
**Prevention**:
- Use tab completion
- Run `terraform fmt`
- Run `terraform validate` frequently

### Pattern #3: Wrong References
**Frequency**: 3 times
**Root Cause**: Not checking module outputs
**Prevention**:
- Check output.tf for exact names
- Use IDE with autocomplete
- Read module documentation

---

## 🎯 ERROR PREVENTION CHECKLIST

Before running `terraform apply`:

- [ ] Run `terraform fmt` (fix formatting)
- [ ] Run `terraform validate` (check syntax)
- [ ] Check for circular dependencies
- [ ] Verify all module outputs exist
- [ ] Confirm variable names match
- [ ] Check function names are lowercase
- [ ] Verify resource references are correct
- [ ] Ensure all required variables are passed

---

## 💡 DEBUGGING TIPS

### Tip #1: Read Error Messages Carefully
- Error shows exact file and line number
- Shows what Terraform expected vs what it got
- Often suggests the fix

### Tip #2: Check Data Flow
```
Variables (IN) → Resources (PROCESS) → Outputs (OUT)
```
- Never create loops
- One direction only

### Tip #3: Use `terraform graph`
```bash
terraform graph | dot -Tpng > graph.png
```
- Visualize dependencies
- Spot circular references
- Understand resource relationships

### Tip #4: Validate Frequently
```bash
# After every change
terraform fmt
terraform validate
```

### Tip #5: Check Module Files
- Read variable.tf for inputs
- Read output.tf for outputs
- Check exact names and types

---

## 🏆 ACHIEVEMENTS UNLOCKED

- ✅ **Circular Dependency Master**: Resolved 5 circular dependencies
- ✅ **Syntax Ninja**: Fixed all typos and syntax errors
- ✅ **Module Expert**: Understood module communication
- ✅ **Reference Pro**: Mastered resource references
- ✅ **Debugging Champion**: 100% error resolution rate

---

## 📈 LEARNING PROGRESS

**Week 1**: Encountered 10 errors, learned module basics
**Week 2**: Encountered 5 errors, mastered circular dependencies
**Week 3**: Encountered 0 errors, building confidently!

**Trend**: Errors decreasing, confidence increasing! 📈

---

## 🎓 KEY LESSONS

1. **Data flows one way**: Variables → Resources → Outputs
2. **Terraform combines files**: All .tf files in module = one file
3. **Case matters**: Functions and variables are case-sensitive
4. **Check outputs**: Always verify exact output names
5. **Use defaults**: Make variables optional with defaults
6. **Format code**: Run `terraform fmt` regularly
7. **Validate often**: Catch errors early
8. **Read errors**: They tell you exactly what's wrong

---

## 🚀 NEXT LEVEL

**Errors I Want to Encounter** (to learn from):
- [ ] State locking issues
- [ ] Provider version conflicts
- [ ] Remote backend errors
- [ ] Workspace issues
- [ ] Import conflicts

**Why?** Each error teaches something new!

---

**Last Updated**: 2026-02-17
**Total Errors Documented**: 15
**Success Rate**: 100%
**Confidence Level**: High 🚀

---

*"Every error is a lesson. Every fix is progress. Every mistake makes you stronger."*

---

## 🔥 NEW SESSION ERRORS (Feb 20, 2026)

### Error #16: Deprecated GitHub Artifact Action Version
**Date**: 2026-02-20  
**File**: `.github/workflows/terraform.yml`

**Error Message**:
```
This request has been automatically failed because it uses a deprecated
version of actions/download-artifact: v3
```

**Why It Failed**:
- GitHub deprecated `download-artifact@v3` for this usage.

**Fix**:
```yaml
uses: actions/download-artifact@v4
```

**Prevention**:
- Periodically review Actions dependency versions.
- Prefer `@v4` for upload/download artifact actions.

---

### Error #17: Artifact Not Found (`tfplan`)
**Date**: 2026-02-20  
**File**: `.github/workflows/terraform.yml`

**Error Message**:
```
Unable to download artifact(s): Artifact not found for name: tfplan
No files were found with the provided path: modules/tfplan
```

**Why It Failed**:
- Plan created at repo root: `terraform plan -out=tfplan`
- Workflow tried uploading `modules/tfplan` (wrong path).

**Fix**:
```yaml
path: tfplan
```

**Prevention**:
- Keep output file path and artifact upload path identical.
- Verify with `pwd` + generated file location in CI.

---

### Error #18: Secrets Manager Name Scheduled-for-Deletion Conflict
**Date**: 2026-02-20  
**File**: `module/database/database.tf`

**Error Message**:
```
InvalidRequestException: You can't create this secret because a secret with this
name is already scheduled for deletion.
```

**Why It Failed**:
- Secret name was fixed and already reserved in AWS due to pending deletion.

**Fix Applied in Session**:
- Changed secret name target to a new suffix (`-v2`) to avoid collision.

**Alternative Fixes**:
- Restore existing secret before reuse.
- Force-delete the pending secret and recreate.
- Use `name_prefix` strategy to avoid hard collisions.

**Prevention**:
- Avoid strict fixed names when repeated create/destroy cycles are expected.

---

### Error #19: RDS Master Password Invalid Character Set
**Date**: 2026-02-20  
**File**: `module/database/database.tf`

**Error Message**:
```
InvalidParameterValue: MasterUserPassword is not a valid password.
Only printable ASCII characters besides '/', '@', '"', ' ' may be used.
```

**Why It Failed**:
- Random password included disallowed characters for RDS.

**Fix**:
```hcl
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
```

**Prevention**:
- Constrain password special chars to service-specific allowed set.

---

### Error #20: HCP Terraform Destroy with Saved Plan Discarded
**Date**: 2026-02-20  
**File**: `.github/workflows/terraform-destroy.yml`

**Error Message**:
```
Error: Saved plan is discarded
The given plan file can no longer be applied...
```

**Why It Failed**:
- Workflow split destroy into:
  - `plan -destroy -out=tfdestroy` in one job
  - `apply tfdestroy` in another job
- In HCP Terraform remote execution, saved plan handoff can be invalidated/discarded.

**Fix**:
- Removed saved destroy-plan artifact handoff.
- Updated workflow pattern:
  - prepare job: `terraform plan -destroy`
  - approved apply job: `terraform destroy -auto-approve`

**Prevention**:
- For HCP remote runs, avoid cross-job apply of local saved plan files.

---

## ✅ New Operational Practices Added

- Always live-watch runs after push:
```bash
gh run watch <run-id> --log
```
- For manual destroy:
```bash
gh workflow run "Terraform Destroy" -f confirm_destroy=DESTROY -f reason="cleanup"
```
- Kiro resume syntax reminder:
```bash
kiro-cli chat --agent terraform-teacher --resume
```

---

## 🧭 Session Process Learnings (Feb 20, 2026)

### Write Approval Rule (Collaboration Safety)
- Read-only actions can run without pause.
- Any file write/delete action must be explicitly approved first.
- If accidental edits happen, restore user state before continuing.

### HCP Terraform Destroy Strategy
- In HCP remote mode, avoid applying saved plan artifacts across CI jobs.
- Preferred pattern:
  - `terraform plan -destroy` (preview)
  - protected manual approval
  - `terraform destroy -auto-approve` (execution)

### GitHub Actions Triage Routine
- First check run summary:
```bash
gh run view <run-id>
```
- Then isolate failing steps:
```bash
gh run view <run-id> --log-failed
```
- Confirm fix by rerun + live watch:
```bash
gh run watch <run-id> --log
```

---

**Updated**: 2026-02-20  
**Total Errors Documented**: 20
