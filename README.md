# DevOps Challenge

## Exercise
* EKS (Elastic Kubernetes Service)
  * Using node groups
* Convert the k8s yaml files to a helm chart
* Deploy helm chart to the EKS cluster
* Expose the application deployed in EKS via an ALB (Application Load Balancer)
    * We recommend using [AWS Load Balancer Controller](https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.2/)

### Terraform Requirements:
* Terraform code should be formatted using `terraform fmt`
* Terraform version must be 0.15.3 or higher
* State should be stored in s3 - ensure there is some way for to easily create and destroy the s3 bucket and dynamodb table

### Application
The application is the 2048 and application.yaml file needs to be converted into a helm chart (charts/ folder)
Please consider the following:
* Helm chart should be written in Helm 3
* What variables should be exposed out
* Consider namespacing and how you handle this


## Deploying

//TODO Please update here on how to create the s3 bucket, dynamo db for terraform state and any requirements for running the terraform code.

#Dependancies

These steps assume that the shell you are running these steps from have default valid credentials setup for accessing an AWS account  
AWS cli is available

The credentials used will need the following IAM permissions to run the terraform EKS setup
https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md


#Run the following  
#ensure following env variables are set and available in shell used to run terraform  

TFSTATE_BUCKET - set this to "terraform-remote-state-bucket-for-my-task"  
TFSTATE_KEY - set this to "staging/terraform.tfstate"  
TFSTATE_KEY_APPS - set this to "staging/apps/terraform.tfstate"
TFSTATE_REGION - set this to "eu-west-2"  

run env to check above env variables are set correctly  

cd provisionEKS/remote-state  
terraform init  
terraform apply  

# Apply EKS / infrastructure config
cd ..  
terraform init -backend-config="bucket=${TFSTATE_BUCKET}" -backend-config="key=${TFSTATE_KEY}" -backend-config="region=${TFSTATE_REGION}"  
terraform apply  

# Apply application deploys config  

cd app-deploys  
terraform init -backend-config="bucket=${TFSTATE_BUCKET}" -backend-config="key=${TFSTATE_KEY_APPS}" -backend-config="region=${TFSTATE_REGION}"  
terraform apply

# Retrieve DNS address of LB for accessing game (assumes kubectl is accessible from your shell and using default cluster name and namespace)  
aws eks --region eu-west-2 update-kubeconfig --name "my-task-cluster"  
kubectl describe ingress game-2048 -n game-2048 | grep Address | cut -d : -f2 | sed 's/^ *//g'  
After a short while (can be up to 3 mins before LB is in active state)  browse to address returned from the previous command in your favorite browser to play game  

# Remove EKS cluster and deployed apps  
#NOTE: If you get Error: Kubernetes cluster unreachable: the server has asked for the client to provide credentials  
then you'll need to do a "terraform refresh" on the EKS config in the parent directory to allow the app config destroy to work  


terraform destroy  


# Remove S3 state file / database lock   
cd remote-state  
sh ./destroy_remote.sh  

TODO!!!!!!  
2) output DNS address for LB endpoint to 2048 URL used to access game via terraform outputs rather than using kubectl  
3) with time would have liked to have run all this in a jenkinsfile with terraform client running in docker  
4) fix intermitent issue reported below (rerunning terraform apply works)

 Error: cannot patch "game-2048" with kind Ingress: Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1beta1-ingress?timeout=10s": dial tcp 10.0.1.199:9443: connect: connection refusedj4) fix intermitent issue Error: cannot patch "game-2048" with kind Ingress: Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1beta1-ingress?timeout=10s": dial tcp 10.0.1.199:9443: connect: connection refusedj4) fix intermitent issue Error: cannot patch "game-2048" with kind Ingress: Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1beta1-ingress?timeout=10s": dial tcp 10.0.1.199:9443: connect: connection refusedj4) fix intermitent issue Error: cannot patch "game-2048" with kind Ingress: Internal error occurred: failed calling webhook "vingress.elbv2.k8s.aws": Post "https://aws-load-balancer-webhook-service.kube-system.svc:443/validate-networking-v1beta1-ingress?timeout=10s": dial tcp 10.0.1.199:9443: connect: connection refusedj
