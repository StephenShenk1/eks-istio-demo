provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = "istio-system"
  create_namespace = false
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istio-discovery"
  namespace  = "istio-system"
  depends_on = [helm_release.istio_base]
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = "istio-system"
  depends_on = [helm_release.istiod]
}

# After Istio is installed, we apply Bookinfo and addons using local-exec
resource "null_resource" "apply_k8s_manifests" {
  provisioner "local-exec" {
    command = <<EOT
kubectl apply -n demo -f ../k8s/bookinfo.yaml || true
kubectl apply -n demo -f ../k8s/bookinfo-gateway.yaml || true
kubectl apply -n demo -f ../k8s/mtls.yaml || true
kubectl apply -n demo -f ../k8s/routing.yaml || true
kubectl apply -n istio-system -f ../k8s/addons.yaml || true
    EOT
  }
  depends_on = [helm_release.istio_ingress]
}
