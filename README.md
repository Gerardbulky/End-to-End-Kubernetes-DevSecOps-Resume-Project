# ArgoCD DevSecOps Kubernetes Project using AWS EKS, Terraform, Jenkins and Hashicorp Vault.

## Overview
This project demonstrates the integration of ArgoCD with DevSecOps practices to ensure continuous delivery and security of applications.

## Prerequisites
- Kubernetes cluster
- ArgoCD installed
- Git repository for your application

## Step 1: We need to create an IAM user and generate the AWS Access key

Create a new IAM User on AWS and give it to the AdministratorAccess for testing purposes (not recommended for your Organization's Projects)

Go to the AWS IAM Service and click on **Users**.

![IAM](images/your-image-file.png)

Click on **Create user**

![IAM](images/your-image-file.png)

Provide the name to your user and click on **Next**.

![IAM](images/your-image-file.png)

Select the Attach policies directly option and search for AdministratorAccess then select it.

Click on the **Next**.

![IAM](images/your-image-file.png)

Click on **Create user**

![IAM](images/your-image-file.png)

Now, Select your created user then click on Security credentials and generate access key by clicking on **Create access key**.

![IAM](images/your-image-file.png)


Select the **Command Line Interface (CLI)** then select the checkmark for the confirmation and click on **Next**.

![IAM](images/your-image-file.png)

Provide the **Description** and click on the **Create access key**.

![IAM](images/your-image-file.png)


Here, you will see that you got the credentials and also you can download the CSV file for the future.

![IAM](images/your-image-file.png)


## Step 2: We will install Terraform & AWS CLI to deploy our Jenkins Server(EC2) on AWS
Install & Configure Terraform and AWS CLI on your local machine to create Jenkins Server on AWS Cloud

#### Terraform Installation Script

````sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
````

#### AWSCLI Installation Script

````sh
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip -y
unzip awscliv2.zip
sudo ./aws/install
````

#### Configure AWS CLI

Now, Configure both the tools

#### Configure Terraform

Edit the file /etc/environment using the below command and add the highlighted lines and add your keys at the blur space.

````sh
sudo vim /etc/environment
````

![IAM](images/your-image-file.png)


After doing the changes, restart your machine to reflect the changes of your environment variables.

Run the below command, and add your keys

````sh
aws configure
````

![IAM](images/your-image-file.png)

### PEM Directory
We are now going to create a **Download** directory to store the PEM file
```sh
mkdir -p /home/ubuntu/Downloads
```
Then run your command to create a  key pair called "Jenkins-key" and output it, in the /home/ubuntu/Download directory:
```sh
aws ec2 create-key-pair --key-name Jenkins-key --query "KeyMaterial" --output text > /home/ubuntu/Downloads/Jenkins-key.pem
```
Verify the File Exists
```sh
ls -l /home/ubuntu/Downloads/
```
Set Proper Permissions
```sh
chmod 400 /home/ubuntu/Downloads/Jenkins-key.pem
```

<!-- ### Creating DynamoDB Table Manually
We are going to create a DynamoDB table for remote locking, to lock our Terraform files.
```sh
aws dynamodb create-table \
    --table-name Lock-Files \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region us-east-1
``` -->


## Step 3: Deploy the Jenkins Server(EC2) using Terraform
Clone the Git repository- https://github.com/Gerardbulky/End-to-End-Kubernetes-DevSecOps-Resume-Project.git

Navigate to the **Jenkins-Terraform-Infra**

Do some modifications to the backend.tf file such as changing the bucket name and dynamodb table(make sure you have created both manually on AWS Cloud).

![IAM](images/your-image-file.png)

Now, you have to replace the Pem File name as you have some other name for your Pem file. To provide the Pem file name that is already created on AWS

![IAM](images/your-image-file.png)


Initialize the backend by running the below command

````sh
terraform init
````

![IAM](images/your-image-file.png)

Run the below command to check the syntax error

````sh
terraform validate
````

Run the below command to get the blueprint of what kind of AWS services will be created.

````sh
terraform plan -var-file=variables.tfvars
````

![IAM](images/your-image-file.png)

Now, run the below command to create the infrastructure on AWS Cloud which will take 3 to 4 minutes maximum

````sh
terraform apply -var-file=variables.tfvars --auto-approve
````

![IAM](images/your-image-file.png)

Now, connect to your Jenkins-Server by clicking on Connect.

![IAM](images/your-image-file.png)

Copy the ssh command and paste it on your local machine.

![IAM](images/your-image-file.png)

## Step 4: Configure the Jenkins
Now, we logged into our **Jenkins server**.

![IAM](images/your-image-file.png)


We have installed some services such as Jenkins, Docker, Sonarqube, Terraform, Kubectl, AWS CLI, and Trivy.

Let’s validate whether all our installed or not.

````sh
jenkins --version
docker --version
docker ps
terraform --version
kubectl version
aws --version
trivy --version
vault version
````
![IAM](images/your-image-file.png)

Now, we have to configure Jenkins. So, copy the public IP of your Jenkins Server and paste it on your favorite browser with an 8080 port.

![IAM](images/your-image-file.png)

Now, run the below command to get the administrator password and paste it on your Jenkins.

````sh
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
````

![IAM](images/your-image-file.png)

Click on **Install suggested plugins**

![IAM](images/your-image-file.png)

After installing the plugins, continue as admin

![IAM](images/your-image-file.png)

Click on **Save and Finish**

![IAM](images/your-image-file.png)

Click on **Start using Jenkins**

![IAM](images/your-image-file.png)

### Install and setup Vault

```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install vault
```
**Installation setup to start vault to run with systemctl: Option 1**


Systemd Service (Recommended) Instead of nohup, create a systemd service so Vault restarts automatically:


```sh
sudo vi /etc/systemd/system/vault.service
```
```sh
Try this:

[Unit]
Description=Vault server
After=network.target

[Service]
ExecStart=/usr/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
KillMode=process
Restart=on-failure
LimitMEMLOCK=infinity
User=vault
Group=vault

[Install]
WantedBy=multi-user.target

OR

[Unit]
Description=HashiCorp Vault
Documentation=https://www.vaultproject.io/docs/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d/vault.hcl
ExecReload=/bin/kill --signal HUP $MAINPID
LimitNOFILE=65536
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Run the command below, uncomment the tcp under **HTTP listener** to expose your vault over http and uncomment **disable_mlock** and comment **HTTPS listener**.
```sh
sudo nano /etc/vault.d/vault.hcl
```
```sh
ui = true

disable_mlock = true

storage "file" {
  path = "/opt/vault/data"
}

# HTTP listener
listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}

api_addr = "http://0.0.0.0:8200"
cluster_addr = "https://0.0.0.0:8201"
```


Make the path for the date to be stored

```sh
sudo mkdir -p /opt/vault/data
```

Start the vault server
```sh
sudo systemctl daemon-reload
sudo systemctl enable vault
sudo systemctl start vault
sudo systemctl status vault
```

##### Set VAULT_ADDR environment variable
```sh
export VAULT_ADDR
```
```sh
export VAULT_ADDR='http://0.0.0.0:8200'
```

To initialize Vault use vault operator init

```sh
vault operator init -key-shares=1 -key-threshold=1
```
Copy the **Unseal Key** and **Initial Root** and paste on a nodepad. 
```sh
echo $VAULT_TOKEN
```
```sh
vault operator unseal
```
```sh
vault login <root token>
```

```sh
export VAULT_TOKEN=<root token>
```

Go to **IP Address:8200** — Shows the UI of the HashiCorp Vault Page

### Set App role

```sh
vault auth enable approle
```
Create a named role **Jenkins**:

```sh
vault write auth/approle/role/jenkins-role \
token_num_uses=0 \
secret_id_num_uses=0 \
policies="jenkins"
```

Now, we need the role ID which will help us to integrate with Jenkins
```sh
vault read auth/approle/role/jenkins-role/role-id
```

Get a SecretID issued against the AppRole:
```sh
vault write -f auth/approle/role/jenkins-role/secret-id
```

Install Vault Plugin & Integrate vault with Jenkins:
Navigate to **Manage Jenkins** ==> **Plugins** ==> **Available Plugins** ==> Select **Hashicorp Vault Plugins** 


### Integrate vault with Jenkins

Navigate to **Manage Jenkins** ==> **Credentials** ==> **global** ==> Click on **Add Credential** 

Select credential type as **Vault AppRole Credentials** and fill out the role ID, Secret ID, ID, Description and click on **Add**.

### Create Secrets in Vault
Enable Secrets where path = "secrets" and it will using key value pair

```sh
vault secrets enable -path=secrets kv
```

Write a Secret in Vault at path “secrets/creds/secret-text” with key as secret and value as jenkins123

```sh
vault write secrets/creds/secret-text secret="jenkins123"
```
We now create a policy to give permission to approle to retrieve secrets

```sh
vi jenkins-policy.hcl
```
```sh
path "secrets/creds/*" {
    capabilities = ["read"]
} 
```

Create a policy named “jenkins” and use “jenkins-policy.hcl” as its content

```sh
vault policy write jenkins jenkins-policy.hcl
```


In other for Jenkins to access our credentials, we need to provide the Path to where the secret are stored in Hashicorp Vault.

Navigate to **Manage Jenkins** ==> **Credentials** ==> ***Global*** ==> Click on **add credential**, Select **Vault Secret Text Credentials** and add the Path of the Secrets stored in Vault. Click the **Test Vault Secrets retrival** to check if jenkins can retrieve secrets from Hashicorp Vault.




## Step 5: We will deploy the EKS Cluster using Jenkins
Now, go back to your Jenkins Server terminal and configure the AWS.

![IAM](images/your-image-file.png)

Click on **Manage Jenkins**

![IAM](images/your-image-file.png)

Click on **Plugins**

![IAM](images/your-image-file.png)

Select the **Available plugins** and install the following plugins and click on **Install**

````sh
AWS Credentials
Pipeline: AWS Steps
````
![IAM](images/your-image-file.png)


Once, both the plugins are installed, restart your Jenkins service.

Now, we have to set our AWS credentials on Jenkins

Go to **Manage Plugins** and click on **Credentials**

![IAM](images/your-image-file.png)

Click on **global**.


Click on **Add credentials**


Select **AWS Credentials** as **Kind** and add the **ID** same as shown in the below snippet except for your AWS Access Key & Secret Access key and click on **Create**.

![IAM](images/your-image-file.png)

Now, Go to the **Dashboard** and click Create a **job**

![IAM](images/your-image-file.png)

Select the **Pipeline** and provide the name to your **Jenkins Pipeline** then click on **OK**.

![IAM](images/your-image-file.png)

Now, Go to the GitHub Repository in which the Jenkins Pipeline code is located to deploy the EKS service using Terraform.

https://github.com/Gerardbulky/End-to-End-Kubernetes-DevSecOps-Resume-Project/blob/master/Jenkins-Pipeline-Code/Jenkinsfile-EKS-Terraform


Copy the entire code and paste it here

**Note:** There will be some configurations like backend.tf files that need to be updated from your side. Kindly do that to avoid errors.

EKS-Terraform Code- https://github.com/Gerardbulky/End-to-End-Kubernetes-DevSecOps-Resume-Project/tree/master/EKS-TF

After pasting the Jenkinsfile code, click on **Save** & **Apply**.

![IAM](images/your-image-file.png)


Click on **Build**


You can see our **Pipeline** was **successful**

![IAM](images/your-image-file.png)


You can validate how many resources have been created by going to the **console logs**

![IAM](images/your-image-file.png)


Now, we will configure the EKS Cluster on the Jenkins Server

Run the below command to configure the EKS Cluster

````sh
aws eks update-kubeconfig --region us-east-1 --name Resume-EKS-Cluster

````
To validate whether the EKS Cluster was successfully configured or not. Run the below command

````sh
kubectl get nodes
````

## Step 6: We will install ArgoCD Controller on EKS Cluster and make publicly available
Create resume namespace

````sh
kubectl create namespace resume
````
![IAM](images/your-image-file.png)

Now, we will configure the argoCD controller on our EKS cluster.

Create a new namespace named argocd and apply the manifest file on the EKS cluster.

````sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.4.7/manifests/install.yaml

````
![IAM](images/your-image-file.png)

Validate whether the argocd controller is deployed or not using the below command.

````sh
kubectl get pods -n argocd
````

As we have to access our ArgoCD controller through GUI, we need to set up the LoadBalancer for it.

Run the below command to set up the load balancer which will expose the argoCD controller publicly.

````sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
````
![IAM](images/your-image-file.png)

Now, you will see Load Balancer on the AWS console.

![IAM](images/your-image-file.png)

Copy the LoadBalancer DNS and paste it into your favorite browser.

Click on **Advanced**.

![IAM](images/your-image-file.png)

Click on the highlighted link

![IAM](images/your-image-file.png)

Here, you can see the ArgoCD login page. But we can’t do anything because we don’t know the password of the admin user.

![IAM](images/your-image-file.png)

Now, we need an admin password to log in to our argoCD.

There is one pre-requisite which is jq to get the password by using filtration.

````sh
sudo apt install jq -y
````
![IAM](images/your-image-file.png)

Store the ArgoCD DNS name in the variable

```sh
export ARGOCD_SERVER=$(kubectl get svc argocd-server -n argocd -o json | jq -r '.status.loadBalancer.ingress[0].hostname')
```
```sh
echo $ARGOCD_SERVER
```

![IAM](images/your-image-file.png)

Run the below command to get the password.

```sh
export ARGO_PWD=`kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`
echo $ARGO_PWD

```

Enter the username and password in argoCD and click on SIGN IN.

![IAM](images/your-image-file.png)

Here is our **ArgoCD Dashboard**.

Click on **CREATE APPLICATION**.

![IAM](images/your-image-file.png)

Provide the name of your **Application name**, the **Project name** will be **default**, and **SYNC POLICY** will be **Automatic** then scroll down.

![IAM](images/your-image-file.png)

Provide the **GitHub Repo**, enter the path where your deployment file is located, then, **Cluster URL** will be https://kubernetes.default.svc and in the end, **namespace** will be **resume** but you can write another namespace name.

Click on **CREATE**.

![IAM](images/your-image-file.png)
## Step 7: Install the required plugins and configure the plugins to deploy our Resume Application Version1
Install the following plugins by going to **Dashboard** -> **Manage Jenkins** -> **Plugins** -> **Available Plugins**

```sh
Docker
Docker Commons
Docker Pipeline
Docker API
docker-build-step
Eclipse Temurin installer
NodeJS
OWASP Dependency-Check
SonarQube Scanner
Pipeline: Github
```

![IAM](images/your-image-file.png)

Now, we have to configure our Sonarqube.

To do that, copy your Jenkins Server public IP and paste it on your favorite browser with a 9000 port

The username and password will be **admin**

Click on **Log In**.

![IAM](images/your-image-file.png)

Update the password

![IAM](images/your-image-file.png)

Click on **Administration** then **Security**, and select **Users**

![IAM](images/your-image-file.png)

Click on **Update tokens**

![IAM](images/your-image-file.png)

Click on **Generate**

![IAM](images/your-image-file.png)

Copy the **token** and keep it somewhere safe and click on **Done**.

![IAM](images/your-image-file.png)

Now, we have to configure **webhooks** for quality checks.

Click on **Administration** then, **Configuration** and select **Webhooks**

![IAM](images/your-image-file.png)

Click on **Create**

![IAM](images/your-image-file.png)

Provide the name to your project and in the URL, provide the jenkins server public ip with port 8080 and add sonarqube-webhook in suffix and click on Create.

http://<jenkins-server-public-ip:8080/sonarqube-webhook/

![IAM](images/your-image-file.png)

Here, you can see the **webhook**.


Now, we have to configure the installed plugins.

Go to **Dashboard** -> **Manage Jenkins** -> **Tools**

We are configuring jdk

Search for jdk and provide the configuration like below snippet.

![IAM](images/your-image-file.png)

Now, we will configure nodejs

Search for node and provide the configuration like the below snippet.

![IAM](images/your-image-file.png)

Now, we will configure the OWASP Dependency check

Search for Dependency-Check and provide the configuration like the below snippet.

![IAM](images/your-image-file.png)

Now, we will configure the docker

Search for docker and provide the configuration like the below snippet.

![IAM](images/your-image-file.png)

Now, we will configure sonarqube

Search for sonarqube and provide the configuration like the below snippet.

![IAM](images/your-image-file.png)

This is it, now click on **Apply** and **Save**.

Now, we have to store our generated token for Sonarqube in Jenkins

Go to **Dashboard** -> **Manage Jenkins** -> **Credentials**

Select the kind as **Secret text** and paste your token in **Secret** and keep other things as it is.

Click on **Create**

![IAM](images/your-image-file.png)

Token is created

![IAM](images/your-image-file.png)

Now, we have to set the path for Sonarqube in Jenkins

Go to **Dashboard** -> **Manage Jenkins** -> **System**

Search for **SonarQube installations**
Provide the **name** as it is, then in **Server URL** copy the sonarqube public IP (same as jenkins) with port 9000 and select the sonar token that we have added recently and click on **Apply** & **Save**.

![IAM](images/your-image-file.png)

Now, In our Jenkinsfile we are pushing our docker image to Dockerhub and then, we have to update the same image name with the new tag in the deployment file which is present on GitHub.

To do that, we need to store our Docker & GitHub credentials in Jenkins.

Go to **Dashboard** -> **Manage Jenkins** -> **Credentials**

Add your docker hub username and password in the respective field with ID **docker**.

Click on **Create**

![IAM](images/your-image-file.png)

Add GitHub credentials

Select the kind as **Secret text** and paste your GitHub Personal access token(not password) in **Secret** and keep other things as it is.

Click on **Create**

**Note:** If you haven’t generated your token then, you have it generated first then paste it in the Jenkins

![IAM](images/your-image-file.png)

Now, we are ready to create our Jenkins Pipeline to deploy our Resume Application.

Go to **Jenkins Dashboard**

Click on **New Item**

![IAM](images/your-image-file.png)

Provide the name of your **Pipeline** and click on **OK**.

![IAM](images/your-image-file.png)

This is the Jenkinsfile to deploy Resume Application Version 1 on EKS.

Copy and paste it into the Jenkins

https://github.com/Gerardbulky/End-to-End-Kubernetes-DevSecOps-Resume-Project/blob/main/Jenkins-Pipeline-Code/Jenkinsfile

Click **Apply** & **Save**.


Now, click on the build.

Our pipeline was successful.

![IAM](images/your-image-file.png)

Now, Go to the **ArgoCD Console**. You will see your application has been deployed or deploying

![IAM](images/your-image-file.png)

This is our Sonarqube which will show you the Code Smells and vulnerabilities in your source code.

![IAM](images/your-image-file.png)

This is our Dependency Check Results

![IAM](images/your-image-file.png)

Copy the DNS name of your load balancer from ArgoCD Console or you can go to AWS Console and copy the Load Balancer and hit the DNS on your favorite browser to view the Resume application.

![IAM](images/your-image-file.png)

## Step 8: We will deploy our Resume Application Version 2
Now, suppose we have done some modifications to our previous version to make it more good in the sense of GUI or anything else. Then, we will have to deploy our **Version 2** of our same application.

To do that, we will create a new pipeline. We can do it in the existing pipeline as well but this way you will be able to understand clearly.

We have a separate code for our Resume Version 2. In which Dockerfile is present, so we will build the image and push it on docker and then update the same manifest file instead of v1 we will replace it with v2 manually first.

Hope you get the high overview, what are we going to do next?

Let’s make it and finish our project.

Go to **Jenkins** -> **Dashboard** and click on **New item**

![IAM](images/your-image-file.png)

Provide the name to your **Pipeline name** and click on **OK**.

![IAM](images/your-image-file.png)

This is the Jenkinsfile to deploy Resume Application Version 2 on EKS.

Copy and paste it in the Jenkins

https://github.com/Gerardbulky/End-to-End-Kubernetes-DevSecOps-Resume-Project/blob/main/Jenkins-Pipeline-Code/Jenkinsfile-ResumeV2

Click **Apply** & **Save**.

![IAM](images/your-image-file.png)

Before going to **build** the pipeline, update the manifest file.

Replace the v1 with v2 in the image section.

![IAM](images/your-image-file.png)

Now, Once you click on the build to deploy our Resume Application Version 2.
You will see our **pipeline** was **successful**.

![IAM](images/your-image-file.png)

ArgoCD deployed our Application. Now, you can click on the service to get the LoadBalancer DNS name

![IAM](images/your-image-file.png)

Once you hit the DNS, you will see the application is live.

![IAM](images/your-image-file.png)

Now, you can view the new version of the resume application.

![IAM](images/your-image-file.png)

## Cleanup
## Step 9: We will destroy the created AWS Resources
Delete both the created **LoadBalancer** manually.

![IAM](images/your-image-file.png)

Select the **EKS-Terraform-Deploy** Pipeline.

Click on **Build with Parameters** and select the **destroy** and click on **Build**.

![IAM](images/your-image-file.png)

The Pipeline ran successfully which means the EKS Cluster has been deleted.

You can validate from the console as well.

![IAM](images/your-image-file.png)

Now, we have to delete our **Jenkins Server**.

To do that, just run the below command on your local machine from where you create Jenkins Server.

```sh
terraform destroy -var-file=variables.tfvars --auto-approve
```

Conclusion
Congratulations on completing the End-to-End DevSecOps Kubernetes Project! This project provides hands-on experience with DevOps practices, AWS services, Kubernetes, and continuous integration and deployment. Remember to build on this foundation and explore more advanced concepts in your DevOps journey. If you have any questions or want to share your experiences, don’t hesitate to reach out. Happy Learning!

## Security Practices

- **Static Code Analysis:** Integrate tools like SonarQube for static code analysis.
- **Dependency Scanning:** Use tools like OWASP Dependency-Check to scan for vulnerabilities in dependencies.
- **Container Scanning:** Use tools like Trivy to scan container images for vulnerabilities.
- **Continuous Monitoring:** Implement monitoring tools like Prometheus and Grafana to continuously monitor the application.