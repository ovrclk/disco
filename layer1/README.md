# layer 1

## Kubernetes

# Packet CSI deploy
Copy deploy/template/secret.yaml to a local file:

```
cp deploy/template/secret.yaml packet-cloud-config.yaml
```

Replace the placeholder in the copy with your token. When you're done, the packet-cloud-config.yaml should look something like this:

```
apiVersion: v1
kind: Secret
metadata:
  name: packet-cloud-config
  namespace: kube-system
stringData:
  cloud-sa.json: |
    {
    "apiKey": "abc123abc123abc123",
    "projectID": "abc123abc123abc123"
    }
```

```
kubectl apply -f ./packet-cloud-config.yaml
```
