# Cloud Resume Challenge – AWS

This repository contains my implementation of the **Cloud Resume Challenge** using AWS services, Terraform for Infrastructure as Code, and GitHub Actions for CI/CD.  
The project demonstrates a full end-to-end serverless architecture, automated deployments, and real-world DevOps practices.

---

## 🔗 Live Demo
🌐 **Website:** https://shatrujitbiswal.com  
---

## 🏗️ Architecture Overview

**Request flow:**
1. User visits the resume website hosted on **Amazon S3**
2. Content is served securely via **CloudFront (HTTPS)**
3. JavaScript calls a **serverless API**
4. **API Gateway** invokes a **Lambda function**
5. Lambda updates and reads the visitor count from **DynamoDB**
6. Response is returned and displayed on the website

---

## 🧰 Technology Stack

### Frontend
- HTML, CSS, JavaScript
- Amazon S3 (static website hosting)
- Amazon CloudFront (CDN + HTTPS)

### Backend
- AWS Lambda (Python)
- Amazon API Gateway (HTTP API)
- Amazon DynamoDB (NoSQL database)

### Infrastructure & DevOps
- Terraform (Infrastructure as Code)
- GitHub Actions (CI/CD)
- IAM (least-privilege security)

---

## 📂 Repository Structure

cloud-resume-challenge-aws/
├── frontend/
├── backend/
│   └── lambda/
├── terraform/
├── infrastructure/
├── .github/workflows/
└── README.md

---

## ⚙️ Infrastructure as Code (Terraform)

- All backend resources are provisioned using **Terraform**
- No manual configuration in the AWS Console
- Lambda code is packaged automatically using Terraform’s `archive_file`
- Infrastructure can be fully recreated using:
```
terraform init
terraform apply
```

<!-- ## 🔄 CI/CD Pipelines

### Backend CI/CD
- Runs on every push
- Validates Terraform configuration
- Deploys backend infrastructure using Terraform

### Frontend CI/CD
- Automatically deploys website files to S3
- Injects API Gateway endpoint into frontend JavaScript
- Invalidates CloudFront cache after deployment 

--- -->

## 🔐 Security Considerations

- No AWS credentials are exposed in frontend code
- DynamoDB is accessed only via Lambda
- IAM roles follow the principle of least privilege
- API Gateway permissions are scoped to the Lambda function

<!-- ---

## 🧪 Testing

- Python unit tests for Lambda logic
- API tested via browser and curl
- Infrastructure validated using terraform validate

--- 

## 📝 Blog Post

I documented what I learned while building this project:
➡️ <link-to-blog>

----->

## 👤 Author

**Shatrujit Biswal**  
GitHub: https://github.com/Shatrujit-Biswal  
LinkedIn: https://linkedin.com/in/shatrujit-biswal
