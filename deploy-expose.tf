
resource "kubernetes_deployment" "echoserver" {
  metadata {
    name = "echoserver"
    labels = {
      App = "echoserver"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "echoserver"
      }
    }
    template {
      metadata {
        labels = {
          App = "echoserver"
        }
      }
      spec {
        container {
          image = "paulbouwer/hello-kubernetes:1.8" #"k8s.gcr.io/e2e-test-images/echoserver:2.5"

          name  = "nginx-c"

          port {
            container_port = 8080
          }
          resources {
            requests = {
              cpu    = "1"
            }
          }
        }
      }
    }
  }
}

# arn:aws:iam::230278678315:user/jakob
# Expose the deployment
resource "kubernetes_service" "echoserver" {
  metadata {
    name = "echoserver"
  }
  spec {
    selector = {
      App = kubernetes_deployment.echoserver.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer" #"ClusterIP"
  }
}
# Ingress
  
resource "kubernetes_ingress_v1" "node" {
  metadata {
    name = "echoserver"
    annotations = {
    "alb.ingress.kubernetes.io/scheme" =  "internet-facing"
    #"alb.ingress.kubernetes.io/scheme" = "internet-facing"
    "alb.ingress.kubernetes.io/target-type" = "ip"
    }
  }

  spec {
    ingress_class_name = "alb"
    rule {
      host = "echo.digitalclouds.se"
      http {
        path {
          path = "/"
          path_type = "Exact"
          backend {
            service {
              name = kubernetes_service.echoserver.metadata.0.name
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
/*
*/
