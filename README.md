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

The credentials used will need the following permissions to run the terraform EKS setup

"autoscaling:AttachInstances",
                "autoscaling:CreateAutoScalingGroup",
                "autoscaling:CreateLaunchConfiguration",
                "autoscaling:CreateOrUpdateTags",
                "autoscaling:DeleteAutoScalingGroup",
                "autoscaling:DeleteLaunchConfiguration",
                "autoscaling:DeleteTags",
                "autoscaling:Describe*",
                "autoscaling:DetachInstances",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:UpdateAutoScalingGroup",
                "autoscaling:SuspendProcesses",
                "ec2:AllocateAddress",
                "ec2:AssignPrivateIpAddresses",
                "ec2:Associate*",
                "ec2:AttachInternetGateway",
                "ec2:AttachNetworkInterface",
                "ec2:AuthorizeSecurityGroupEgress",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:CreateDefaultSubnet",
                "ec2:CreateDhcpOptions",
                "ec2:CreateEgressOnlyInternetGateway",
                "ec2:CreateInternetGateway",
                "ec2:CreateNatGateway",
                "ec2:CreateNetworkInterface",
                "ec2:CreateRoute",
                "ec2:CreateRouteTable",
                "ec2:CreateSecurityGroup",
                "ec2:CreateSubnet",
                "ec2:CreateTags",
                "ec2:CreateVolume",
                "ec2:CreateVpc",
                "ec2:CreateVpcEndpoint",
                "ec2:DeleteDhcpOptions",
                "ec2:DeleteEgressOnlyInternetGateway",
                "ec2:DeleteInternetGateway",
                "ec2:DeleteNatGateway",
                "ec2:DeleteNetworkInterface",
                "ec2:DeleteRoute",
                "ec2:DeleteRouteTable",
                "ec2:DeleteSecurityGroup",
                "ec2:DeleteSubnet",
                "ec2:DeleteTags",
                "ec2:DeleteVolume",
                "ec2:DeleteVpc",
                "ec2:DeleteVpnGateway",
                "ec2:Describe*",
                "ec2:DetachInternetGateway",
                "ec2:DetachNetworkInterface",
                "ec2:DetachVolume",
                "ec2:Disassociate*",
                "ec2:ModifySubnetAttribute",
                "ec2:ModifyVpcAttribute",
                "ec2:ModifyVpcEndpoint",
                "ec2:ReleaseAddress",
                "ec2:RevokeSecurityGroupEgress",
                "ec2:RevokeSecurityGroupIngress",
                "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
                "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
                "ec2:CreateLaunchTemplate",
                "ec2:CreateLaunchTemplateVersion",
                "ec2:DeleteLaunchTemplate",
                "ec2:DeleteLaunchTemplateVersions",
                "ec2:DescribeLaunchTemplates",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:GetLaunchTemplateData",
                "ec2:ModifyLaunchTemplate",
                "ec2:RunInstances",
                "eks:CreateCluster",
                "eks:DeleteCluster",
                "eks:DescribeCluster",
                "eks:ListClusters",
                "eks:UpdateClusterConfig",
                "eks:UpdateClusterVersion",
                "eks:DescribeUpdate",
                "eks:TagResource",
                "eks:UntagResource",
                "eks:ListTagsForResource",
                "eks:CreateFargateProfile",
                "eks:DeleteFargateProfile",
                "eks:DescribeFargateProfile",
                "eks:ListFargateProfiles",
                "eks:CreateNodegroup",
                "eks:DeleteNodegroup",
                "eks:DescribeNodegroup",
                "eks:ListNodegroups",
                "eks:UpdateNodegroupConfig",
                "eks:UpdateNodegroupVersion",
                "iam:AddRoleToInstanceProfile",
                "iam:AttachRolePolicy",
                "iam:CreateInstanceProfile",
                "iam:CreateOpenIDConnectProvider",
                "iam:CreateServiceLinkedRole",
                "iam:CreatePolicy",
                "iam:CreatePolicyVersion",
                "iam:CreateRole",
                "iam:DeleteInstanceProfile",
                "iam:DeleteOpenIDConnectProvider",
                "iam:DeletePolicy",
                "iam:DeletePolicyVersion",
                "iam:DeleteRole",
                "iam:DeleteRolePolicy",
                "iam:DeleteServiceLinkedRole",
                "iam:DetachRolePolicy",
                "iam:GetInstanceProfile",
                "iam:GetOpenIDConnectProvider",
                "iam:GetPolicy",
                "iam:GetPolicyVersion",
                "iam:GetRole",
                "iam:GetRolePolicy",
                "iam:List*",
                "iam:PassRole",
                "iam:PutRolePolicy",
                "iam:RemoveRoleFromInstanceProfile",
                "iam:TagOpenIDConnectProvider",
                "iam:TagRole",
                "iam:UntagRole",
                "iam:UpdateAssumeRolePolicy",
                // Following permissions are needed if cluster_enabled_log_types is enabled
                "logs:CreateLogGroup",
                "logs:DescribeLogGroups",
                "logs:DeleteLogGroup",
                "logs:ListTagsLogGroup",
                "logs:PutRetentionPolicy",
                // Following permissions for working with secrets_encryption example
                "kms:CreateAlias",
                "kms:CreateGrant",
                "kms:CreateKey",
                "kms:DeleteAlias",
                "kms:DescribeKey",
                "kms:GetKeyPolicy",
                "kms:GetKeyRotationStatus",
                "kms:ListAliases",
                "kms:ListResourceTags",
                "kms:ScheduleKeyDeletion"
            ],
            "Resource": "*"

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

# Retrieve DNS address of LB for accessing game (assumes kubectl is accessible from your shell and using default cluster name and namespace)  
aws eks --region eu-west-2 update-kubeconfig --name "my-task-cluster"  
kubectl describe ingress game-2048 -n game-2048 | grep Address | cut -d : -f2 | sed 's/^ *//g'  
Access returned address in browser to play game  

# Remove EKS cluster and deployed apps  
To destroy stack unfortunately need to manually delete ELB and target group otherwise ELB/target group created by AWS LB controller doesnt get deleted and causes destroy to fail leaving orphaned resources. Im working on fixing/automating this step.  
#NOTE: If you get Error: Kubernetes cluster unreachable: the server has asked for the client to provide credentials
then you'll need to do a terraform refresh on the EKS config to allow destroy to work
delete relevant loadbalancer via cmdline  
delete relevant targetgroup via cmdline  
terraform destroy  
#Intermittently destroy fails and end up having to delete the following state manually (namespace sometimes ends up in terminating state)  
terraform state rm kubernetes_namespace.game-2048  
#and sometimes have to manually delete the vpc as its hung up on a security group  

# Remove S3 state file / database lock   
cd remote-state  
sh ./destroy_remote.sh  

TODO!!!!!!  
1) work out how to delete ELB created by AWS lB controller so tidy destroy can occur. Looks like will need to search specific tags and delete 
2) output DNS address for LB endpoint to 2048 URL used to access game via terraform outputs rather than using kubectl  
3) with time would have liked to have run all this in a jenkinsfile with terraform client running in docker  

