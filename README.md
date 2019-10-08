**Note: This project is a work in progress**

# Stack

Production ready stack to simplify deployment of Akash
## Layers and Components

- [Layer 0](layer0): Bare metal servers on packet, provisioned using Terraform
- [Layer 1](layer1): Kubernetes Cluster with Helm, and Container Storage Interfaces (CSI)
- [Layer 2](layer2): Observabilty (Prometheus and Graphana) and Key Management (Vault)
- [Layer 3](layer3): Akash Suite
- [Layer 4](layer4): Applications

- [Sanity Check](sanity): Cluster readiness checks for Akash
