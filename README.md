# **Combination of IaaC and and Configuration management tool to deploy application on a demo environment**


## **<u>Task Description</u>** :
1. Use Terraform to deploy following things:
- VPC
- Public Subnets
- Private Subnets
- Launch Template
- Auto Scaling Group of EC2 Machine with Latest ubuntu image
- Application Load Balancer for above auto scaling group
- MySQL RDS
- SNS Topic and subscription
- Cloudwatch CPU and RAM utilization metric and Alert (Alerts should be sent to SNS Topic subscribers)

2. Deploy a sample application with Ansible
- Application should be deployed on auto scaling group created in previous step
- MySQL database connection should happen


Follow best practices while creating infrastructure.

```
```
## **<u>Creating Infrastructure on AWS cloud using Terraform</u>** :
-   Configuring S3 as backend to store tfstate file remotely.

-   Creating Network 
    - VPC
    - Public Subnets and Private Subnets
    - Public Route Table with Internet Gateway
    - Private Route Table with NAT Gateway
    - Public Application Loadbalancer and Security Group

![Alt-Text](screenshot/1-1.png)
```
```
![Alt-Text](screenshot/1.png)
```
```
![Alt-Text](screenshot/1-2.png)
```
```
![Alt-Text](screenshot/1-3.png)
```
```
![Alt-Text](screenshot/1-4.png)
```
```
![Alt-Text](screenshot/1-5.png)
```
```
![Alt-Text](screenshot/1-6.png)
```
```
![Alt-Text](screenshot/1-7.png)
```
```

-   Creating HA-EC2_ALB
    - Creating High Availability EC2 Application Loadbalancer setup in Private Subnet.
    - Created Auto Scaling Group and Target Group
    - Load Balancer listner rules
![Alt-Text](screenshot/2.png)
```
```
![Alt-Text](screenshot/2-2.png)
```
```
![Alt-Text](screenshot/2-3.png)
```
```

-   Bastion Host
    -  Created Bastion Host in public subnet for accessing the HA-EC2-ALB setup created in private subnets. 

![Alt-Text](screenshot/3.png)
```
```
![Alt-Text](screenshot/3-2.png)
```
```

- SNS Topic And Subscription Creation.

![Alt-Text](screenshot/4.png)
```
```
![Alt-Text](screenshot/4-2.png)
```
```
![Alt-Text](screenshot/4-3.png)
```
```
![Alt-Text](screenshot/5.png)
```
```

-   RDS MySQL
    - Created RDS MySQL db instance and allowed only internal traffic on mysql port i.e. 3306. 

![Alt-Text](screenshot/6.png)
```
```
![Alt-Text](screenshot/6-1.png)
```
```
![Alt-Text](screenshot/7.png)
```
```
-   Ansible Role
    - Created Ansible Role for deployment of Application on HA-EC2-ALB setup.
    - Created Ansible Dynamic Inventory.
    - Custom Ansible configuration.

![Alt-Text](screenshot/8.png)
```
```
![Alt-Text](screenshot/9.png)
```
```
-   Application Deployment
    - Application Deployed on url: http://application.amolovhal.com/Spring3HibernateApp/
    - Applciation Source Code: https://github.com/opstree/spring3hibernate

![Alt-Text](screenshot/10.png)
```
```
![Alt-Text](screenshot/11.png)
```
```
![Alt-Text](screenshot/12.png)
```
```
![Alt-Text](screenshot/13.png)
