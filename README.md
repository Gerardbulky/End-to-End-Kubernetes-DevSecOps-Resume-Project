# ArgoCD DevSecOps Project

## Overview
This project demonstrates the integration of ArgoCD with DevSecOps practices to ensure continuous delivery and security of applications.

## Prerequisites
- Kubernetes cluster
- ArgoCD installed
- Git repository for your application

### PEM Directory
Create a directory for your PEM file
```sh
mkdir -p /home/ubuntu/Downloads
```
Then run your command to generate the key pair:
```sh
aws ec2 create-key-pair --key-name jenkins-key --query "KeyMaterial" --output text > /home/ubuntu/Downloads/jenkins-key.pem
```
Verify the File Exists
```sh
ls -l /home/ubuntu/Downloads/
```
Set Proper Permissions
```sh
chmod 400 /home/ubuntu/Downloads/Jenkins-key.pem
```

### Creating DynamoDB Table Manually
```sh
aws dynamodb create-table \
    --table-name Lock-Files \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-1

```

## Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-repo/argocd-devsecops-project.git
    cd argocd-devsecops-project
    ```

2. **Install ArgoCD:**
    Follow the [official ArgoCD installation guide](https://argo-cd.readthedocs.io/en/stable/getting_started/).

3. **Deploy the application:**
    ```sh
    kubectl apply -f application.yaml
    ```

## Usage

1. **Access ArgoCD UI:**
    ```sh
    kubectl port-forward svc/argocd-server -n argocd 8080:443
    ```
    Open your browser and navigate to `https://localhost:8080`.

2. **Login to ArgoCD:**
    Use the initial admin password to login. You can retrieve it with:
    ```sh
    kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
    ```

3. **Sync the application:**
    In the ArgoCD UI, find your application and click the "Sync" button to deploy it to your Kubernetes cluster.

## Security Practices

- **Static Code Analysis:** Integrate tools like SonarQube for static code analysis.
- **Dependency Scanning:** Use tools like OWASP Dependency-Check to scan for vulnerabilities in dependencies.
- **Container Scanning:** Use tools like Trivy to scan container images for vulnerabilities.
- **Continuous Monitoring:** Implement monitoring tools like Prometheus and Grafana to continuously monitor the application.

## Contributing
Contributions are welcome! Please open an issue or submit a pull request for any improvements.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For any questions or support, please contact [your-email@example.com](mailto:your-email@example.com).
