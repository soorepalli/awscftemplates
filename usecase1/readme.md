
---

### Scripts

#### `scripts/deploy.sh`

```bash
#!/bin/bash
set -e

STACK_NAME="eks-nlb-stack"
REGION="us-east-1"

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://cloudformation/eks-nlb.yaml \
  --parameters file://cloudformation/parameters.json \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

echo "Waiting for stack creation to complete..."
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

echo "Stack created successfully."

CLUSTER_NAME=$(aws cloudformation describe-stacks --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='EKSClusterName'].OutputValue" --output text)

echo "Updating kubeconfig for cluster: $CLUSTER_NAME"
aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION

kubectl apply -f k8s/ingress-controller.yaml
kubectl apply -f k8s/demo-app.yaml
```

#### `scripts/test.sh`

```bash
#!/bin/bash
set -e

STACK_NAME="eks-nlb-stack"
REGION="us-east-1"

NLB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='NLBDNSName'].OutputValue" --output text)

echo "Testing connectivity via NLB: $NLB_DNS"

curl -v http://$NLB_DNS/
```

---

## Execution Flow

1. Update `parameters.json` with your **VPC, subnets, and keypair**.
2. Run `scripts/deploy.sh` to create the stack and deploy manifests.
3. Run `scripts/test.sh` to validate the app is accessible via the NLB DNS.

---
