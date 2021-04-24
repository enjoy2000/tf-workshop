# Terraform workshop

Introduce terraform and basic usages with K8s.
- Setup EKS cluster
- Create a deployment with autoscale
- Create an ingress and route by host name

## Requirements

- An AWS account
- Get AWS access keys
![AWS keys](docs/aws_keys.png)
- Install terraform https://www.terraform.io/downloads.html
- Install AWS CLI `pip install awscli`
- Install Kubectl https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
- Install helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Steps

### Step 1 - Setup EKS cluster

- Checkout step-1 if you couldn't follow
- 
```
export AWS_PROFILE=tf-workshop
aws configure
```
Copy your credentials, then enter > enter
- Create providers.tf
- Create variables.tf
- Create main.tf
- `terraform apply`
- Run update-kubeconfig to set the config for `kubectl`
```
aws eks update-kubeconfig --name tf-workshop --region ap-southeast-1
```

### Step 2 - Create deployment with external load balancer

- Checkout step-2
- Create deploy.yaml
- `kubectl apply -f deploy.yaml`
- Verify by `kubectl describe deploy`
- `kubectl expose deploy/hello-world --type=LoadBalancer --name=my-service`
- Verify by `kubectl describe svc`
- `curl xxx-504933999.ap-southeast-1.elb.amazonaws.com:8080`
- Autoscale `kubectl autoscale deploy/hello-world --min=2 --max=3`
- Verify by `kubectl get pod`, you will see 2 pods are running

### Step 3 - Helm with nginx-ingress

- Install nginx-ingress
  - Add helm to required_providers
  - Config provider helm, copy from `kubernetes`
  - `terraform init`
- Create ingress with Netowrk Load Balancer (nlb + IP)
- Create ingress to `my-service` `8080` `kubectl apply -f ingress.yaml`
- Get ingress nginx external dns `kubectl -n ingress-nginx get svc`
- Get IP of ELB `nslookup {ELB domain}`
- Edit /etc/hosts file with nlb IP and retry (tf-workshop.com xx.xx.xx.xx)
- Destroy your resources if you don't want to burn your wallet ;)
```
terraform destroy
```
Delete the VPC from UI if needed.

## What's next?

- Remote backend for collaboration
- Helm charts for deployment
- Autoscale with external metric / Prometheous
- Resources management and monitoring

## Credit

https://github.com/HowDevOps/workshop-01
https://www.youtube.com/channel/UCQCGiKBavnhYuIADjiwFVhg
https://github.com/artberri/101-terraform

