# Kubernetes RBAC & AWS RDS Integration Helm Chart

This Helm chart sets up Kubernetes Role-Based Access Control (RBAC) for secure access to workloads across multiple environments (`staging` and `production`) and integrates AWS RDS credentials securely into Kubernetes using secrets.

## Features

- Configures two namespaces: `staging` and `production`.
- Sets up RBAC roles and bindings:
  - `developer`: Full access to `staging`, no access to `production`.
  - `admin`: Full access to both `staging` and `production`.
- Integrates AWS RDS credentials for each environment as Kubernetes secrets.

## Prerequisites

- A Kubernetes cluster with Helm installed.
- Permissions to create namespaces, roles, role bindings, and secrets.
- AWS RDS credentials for each environment.

## Usage

### 1. Configure `values.yaml`

To customize the deployment, use the provided `values.yaml.example` file as a template. Copy this file and rename it to `values.yaml`, then fill in your specific values:

```yaml
# Example values.yaml
rdsUsernameStaging: your_staging_username
rdsPasswordStaging: your_staging_password
rdsUsernameProd: your_production_username
rdsPasswordProd: your_production_password
```

### 2. Deploy the Helm Chart

Install the Helm chart by running:

```bash
helm install <release-name> ./k8s-rbac-rds-integration -f values.yaml
```

Replace `<release-name>` with the desired name for your Helm release. This command will deploy the chart with the specified values, setting up namespaces, RBAC permissions, and RDS credentials for `staging` and `production`.

### 3. Verify Deployment

After deployment, verify that everything is set up correctly. You can check the notes by running:

```bash
helm get notes <release-name>
```

This will display information on validating the setup, including testing RBAC permissions and ensuring the secrets are correctly created.

For a detailed end-to-end test, use the provided `test_config.sh` script (see the `NOTES.txt` output for more information).

## Example Testing Commands

To manually validate permissions, you can use `kubectl` impersonation:

```bash
# Test developer access in staging (should succeed)
kubectl auth can-i get pods -n staging --as=developer

# Test developer access in production (should fail)
kubectl auth can-i get pods -n production --as=developer
```

## Possible Improvements

Here are some enhancements you could consider for production-level security and scalability:

1. **Use AWS Secrets Manager**: Instead of storing AWS RDS credentials directly in Kubernetes secrets, store them in AWS Secrets Manager. Then, assign IAM permissions to the application pods, allowing them to read secrets directly from AWS.

2. **Sync AWS Secrets with Kubernetes Secrets**: Use a solution like [kubernetes-external-secrets](https://github.com/external-secrets/kubernetes-external-secrets) or [AWS Secrets and Configuration Provider](https://aws.github.io/secrets-store-csi-driver-provider-aws/) to automatically sync AWS Secrets Manager secrets into Kubernetes as secrets, reducing manual secret management.

3. **Secrets Rotation**: Set up a process to rotate secrets regularly, using AWS Secrets Manager's automated rotation for dynamic databases or other tools.

4. **Least Privilege Principle for Pods**: Assign the least privileges needed for each application pod to interact with RDS, following AWS IAM roles best practices.

## Additional Notes

- Ensure that sensitive values are never committed directly into version control. Use Helm secrets or other secret management techniques to securely manage values in `values.yaml`.
- For production environments, always follow best practices for RBAC and secret management, keeping configurations secure and isolated by namespace.

## Troubleshooting

If you encounter issues with the deployment:

- Confirm that the Helm chart installed successfully and that all resources are created as expected.
- Check the `kubectl logs` for any errors related to access permissions.
- Verify that the Kubernetes contexts and permissions are correctly configured on your cluster.
