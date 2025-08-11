# eks-istio-demo

Terraform + Kubernetes demo repo to create an EKS cluster (eu-west-2), install Istio via Helm,
and deploy the Bookinfo demo app (with mTLS, routing examples and observability addons).

## Structure

- terraform/ : Terraform code to create VPC, EKS cluster, node group, and install Istio via Helm.
- k8s/       : Kubernetes manifests (Bookinfo, gateway, mtls, routing and addons).
- README.md  : This file.
- .gitignore : Terraform & local ignores.

## Quickstart (high level)

1. Install prerequisites: Terraform, AWS CLI, kubectl, helm, istioctl.
2. Configure AWS credentials for an account in `eu-west-2`.
3. From `/terraform`:
   ```bash
   terraform init
   terraform apply -var="aws_region=eu-west-2"
   ```
4. After apply completes, Terraform will optionally run `kubectl apply` to deploy k8s manifests.
5. Follow outputs to port-forward Grafana/Kiali/Jaeger or access the Ingress Gateway.

## Notes

- This repo uses the terraform-aws-modules/eks/aws module to simplify cluster creation.
- Istio is installed via Helm. Adjust the Istio version in `terraform/istio-install.tf`.
- The `k8s/` folder contains small helper manifests and pointers to the official Istio Bookinfo YAMLs.

## Files included

See `terraform/` and `k8s/` for Terraform & Kubernetes files.

