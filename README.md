# Uw2DevK8s

Test deployment of K8s CSI secrets manager pods and driver to pull secrets from AWS Secrets Manager on pod launch

Secrets are refreshed each time pod is launched, either via manual action or deployment replace. Secrets are not automatically refreshed on a live pod unless configured to do so. 