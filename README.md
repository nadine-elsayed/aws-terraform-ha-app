# Highly Available Web App – AWS + Terraform

This project deploys a highly available and scalable web application on AWS using Terraform. The environment is fully automated, modular, and follows best practices for security and reusability.  

It includes:

- **Networking:** Multi-AZ VPC with public and private subnets, Internet Gateway, NAT Gateway, and configured route tables  
- **Compute:** Auto Scaling EC2 instances with a Launch Template serving a custom Nginx page, behind an Application Load Balancer (ALB)  
- **Database:** RDS MySQL instance in private subnets with credentials securely stored in AWS Secrets Manager  
- **Storage:** S3 bucket for file uploads with versioning and server-side encryption  
- **IAM:** Least-privilege IAM roles and policies for EC2 to access S3 and Secrets Manager  
- **Terraform Best Practices:** Fully modular structure (`vpc/`, `ec2/`, `rds/`, `s3/`, `iam/`) with reusable `variables.tf` and `outputs.tf`  
- **Bonus Features Completed:** Remote state backend with S3 + DynamoDB and CI/CD pipeline using GitHub Actions  

This setup allows full automation of deployment, validation, and teardown, making it easy for anyone on the team to run, test, and maintain.

---

## **Pre-requisites**

1. Terraform >= 1.6.0  
2. AWS CLI configured with an IAM user having full Terraform permissions  
3. Git  

---

## **Deploy**

1. Clone the repository:
```bash
https://github.com/nadine-elsayed/aws-terraform-ha-app.git
cd aws-terraform-ha-app
````

2. Initialize Terraform (downloads providers & sets up backend if configured):

```bash
terraform init
```

3. Apply the infrastructure:

```bash
terraform apply -auto-approve
```

4. Verify outputs:

```bash
terraform output
```

* Look for:

  * `rds_endpoint` → RDS MySQL endpoint
  * `alb_dns_name` → ALB DNS name

---

## **Test Deployment**

* Open the ALB DNS in a browser → should display:
  `Hello from <Your Name>`

* Connect to RDS from EC2 or locally (if allowed) → check `users` table

* Upload a test file to S3 via EC2 → ensure it is stored and versioned

---

## **Destroy**

When finished, remove all resources:

```bash
terraform destroy -auto-approve
```

---

## **Bonus: Remote State + CI/CD (Optional)**

* State stored in S3 with DynamoDB locking
* GitHub Actions validates and applies Terraform on `main` branch pushes

To use CI/CD:

1. Add repository secrets:

   * `AWS_ACCESS_KEY_ID`
   * `AWS_SECRET_ACCESS_KEY`
2. Push to `main` → pipeline runs automatically

---


