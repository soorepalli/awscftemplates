#!/bin/bash
set -e

STACK_NAME="eks-nlb-stack"
REGION="us-east-1"

NLB_DNS=$(aws cloudformation describe-stacks --stack-name $STACK_NAME \
  --query "Stacks[0].Outputs[?OutputKey=='NLBDNSName'].OutputValue" --output text)

if [[ -z "$NLB_DNS" ]]; then
  echo "Error: NLB DNS name is empty. Ensure CloudFormation stack created successfully."
  exit 1
fi

echo "Testing connectivity via NLB: $NLB_DNS"

curl -v http://$NLB_DNS/
