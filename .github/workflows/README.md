# GitHub Actions Workflows

This directory contains the CI/CD workflows for the Terraform Cloudflare wrapper module.

## Workflows

### 1. Terraform PR Checks (`terraform-pr-checks.yml`)

**Trigger**: Pull requests to `main` or `master` branches

**Purpose**: Validates pull requests before merging

**Jobs**:

1. **Terraform Quality Checks**
   - Format check (`terraform fmt -check -recursive`)
   - Initialize root and child modules
   - Validate root and child modules
   - Ensures code quality standards

2. **Terraform Tests**
   - Runs in parallel for each module with tests
   - Tests: `dns_networking`, `email_management`, `zero_trust_security`
   - Validates module logic without API calls

3. **Example Validation**
   - Validates the complete example configuration
   - Ensures examples are syntactically correct

4. **Summary**
   - Aggregates all check results
   - Provides clear pass/fail status

**Status Checks**: All jobs must pass for PR to be mergeable

### 2. Terraform Continuous Testing (`terraform-tests.yml`)

**Trigger**: 
- Push to `main` or `master` branches
- Manual workflow dispatch

**Purpose**: Continuous validation of the main branch

**Jobs**:

1. **Test All Modules**
   - Runs all module tests
   - Uploads test results as artifacts
   - Tracks test history

## Terraform Version

All workflows use **Terraform v1.10.0** to match the minimum required version in the module.

## Permissions

- **terraform-pr-checks.yml**: 
  - `contents: read` - Read repository contents
  - `pull-requests: write` - Comment on PRs with results

- **terraform-tests.yml**:
  - `contents: read` - Read repository contents

## Workflow Status

You can view workflow runs in the "Actions" tab of the repository.

### Status Badges

Add these badges to your README.md to show workflow status:

```markdown
![Terraform PR Checks](https://github.com/sdsdeliverio/terraform-cloudflare-wrapper/actions/workflows/terraform-pr-checks.yml/badge.svg)
![Terraform Tests](https://github.com/sdsdeliverio/terraform-cloudflare-wrapper/actions/workflows/terraform-tests.yml/badge.svg)
```

## Running Workflows Manually

The `terraform-tests.yml` workflow can be triggered manually:

1. Go to Actions tab
2. Select "Terraform Continuous Testing" workflow
3. Click "Run workflow"
4. Choose branch and click "Run workflow"

## Local Testing

Before pushing, run the same checks locally:

```bash
# Format check
terraform fmt -check -recursive

# Initialize and validate root
terraform init -backend=false
terraform validate

# Initialize and validate each module
for module in modules/*/; do
  (cd "$module" && terraform init -backend=false && terraform validate)
done

# Run tests
terraform test -test-directory=modules/dns_networking/tests
terraform test -test-directory=modules/email_management/tests
terraform test -test-directory=modules/zero_trust_security/tests
```

## Troubleshooting

### Format Check Fails

Run `terraform fmt -recursive` locally and commit the changes.

### Module Validation Fails

Check for:
- Syntax errors in `.tf` files
- Missing required variables
- Invalid resource configurations
- Provider configuration issues

### Tests Fail

Check for:
- Incorrect test assertions
- Missing test variables
- Logic errors in modules

### Example Validation Fails

The example validation may show warnings about missing variables, which is expected since we don't provide actual Cloudflare credentials in CI. As long as the syntax is valid, this is acceptable.

## Security

**Important**: Never commit Cloudflare API tokens or credentials to the repository. The workflows are designed to run without actual credentials, validating only syntax and logic.

## Updating Workflows

When updating workflows:

1. Test changes on a feature branch PR
2. Review workflow run logs carefully
3. Update this README if behavior changes
4. Consider backward compatibility

## Support

For issues with workflows:
1. Check workflow run logs in Actions tab
2. Review this documentation
3. Open an issue with workflow logs attached
