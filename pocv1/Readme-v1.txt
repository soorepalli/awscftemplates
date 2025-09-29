
Below Script is useful to create NLB, Targetgroup, EKS Cluster
Script: eks-nlb-v3.yaml
Parameters: parameters.json
Executable Command:
aws cloudformation create-stack \
  --stack-name baxmos-nlg-eks-stack \
  --template-body file://eks-nlb-v3.yaml \
  --parameters file://parameters.json \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  
 
(DNS / Route53 integration not included) 
Testing Result: Success

EKS Cluster Configuration with service ingress Controllers
===============================================================
Step 1: aws eks update-kubeconfig --region us-east-1 --name BaxMos-EKS-Cluster
Testing Result: Success
Step 2: 
a. kubectl apply -f nginx-http-controller.yaml
Testing Result: Success

b. kubectl apply -f nginx-tcp-controller.yaml
Testing Result: Success

Check Pods:
kubectl get pods -n ingress-nginx
kubectl get pods -n nginx-tcp

Check Services:
kubectl get svc -n ingress-nginx
kubectl get svc -n nginx-tcp

Understanding the Ingress with NLB
====================================
Connect with NLB Target Groups

HTTP → Forward port 80 of NLB → TargetGroup → NodePort 30080.
HTTPS → Forward port 443 of NLB → TargetGroup → NodePort 30443.
TCP (example MySQL) → Forward port 3306 of NLB → TargetGroup → NodePort 30306.

Below Script is useful to create NLB, Targetgroup, EKS Cluster with DNS Integration
Script Name: eks-nlb-dns-v1.yaml
parameters: parameters-dns.json

Executable command:
aws cloudformation create-stack \
  --stack-name MyEKSWithNLBStack \
  --template-body file://eks-nlb-dns-v1.yaml \
  --parameters file://parameters-dns.json \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

(DNS parameter Values required to configure the DNS Services)

Without DNS Parameters(empty) / Dummy Values, then below script is useful:
Script: eks-nlb-dns-v2.yaml




