#!/bin/bash
set -e

STACK_NAME="eks-nlb-stack"
REGION="us-east-1"

aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://eks-nlb.yaml \
  --parameters file://parameters.json \
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