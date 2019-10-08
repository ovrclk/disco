## Version

v1.15.4-k3s.1

## Images

- quay.io/k8scsi/csi-node-driver-registrar:v1.2.0
- docker.io/packethost/csi-packet:1c039e3
- quay.io/k8scsi/csi-provisioner:v1.4.0
- quay.io/k8scsi/csi-attacher:v2.0.0

### Snapshot

`kubectl get nodes -o json | jq '.items[] | .status.images[]'`

```json
{
  "names": [
    "docker.io/packethost/csi-packet@sha256:3a8c01a297f503bf313641ef282e2713523a8bdac4184117cd47ac81fc0bcb63",
    "docker.io/packethost/csi-packet:1c039e3"
  ],
  "sizeBytes": 76884203
}
{
  "names": [
    "gcr.io/kubernetes-helm/tiller@sha256:be79aff05025bd736f027eaf4a1b2716ac1e09b88e0e9493c962642519f19d9c",
    "gcr.io/kubernetes-helm/tiller:v2.14.2"
  ],
  "sizeBytes": 30875059
}
{
  "names": [
    "docker.io/rancher/klipper-helm@sha256:72690de1ae2259a41075e87ff453936a74e0f2dbf2ad1dd96a4f72136a48038d",
    "docker.io/rancher/klipper-helm:v0.1.5"
  ],
  "sizeBytes": 27089525
}
{
  "names": [
    "docker.io/library/traefik@sha256:e1e1b1dadfaab6d64f420f4352356e98e289fc7c8bf9f47387866f221c60e4e6",
    "docker.io/library/traefik:1.7.14"
  ],
  "sizeBytes": 23626773
}
{
  "names": [
    "quay.io/k8scsi/csi-provisioner:v1.4.0"
  ],
  "sizeBytes": 20068761
}
{
  "names": [
    "quay.io/k8scsi/csi-attacher:v2.0.0"
  ],
  "sizeBytes": 17305293
}
{
  "names": [
    "docker.io/coredns/coredns@sha256:cfa7236dab4e3860881fdf755880ff8361e42f6cba2e3775ae48e2d46d22f7ba",
    "docker.io/coredns/coredns:1.6.3"
  ],
  "sizeBytes": 14191001
}
{
  "names": [
    "quay.io/k8scsi/csi-node-driver-registrar:v1.2.0"
  ],
  "sizeBytes": 7676183
}
{
  "names": [
    "docker.io/rancher/klipper-lb@sha256:2cff68f14dd050a5ab16b59a55d5ba34d6edc3f6edfc1ec5bd4e437d4ba47290",
    "docker.io/rancher/klipper-lb:v0.1.1"
  ],
  "sizeBytes": 2708144
}
{
  "names": [
    "k8s.gcr.io/pause@sha256:f78411e19d84a252e53bff71a4407a5686c46983a2c2eeed83929b888179acea",
    "k8s.gcr.io/pause:3.1"
  ],
  "sizeBytes": 317164
}
```
### DaemonSet

```
apiVersion: extensions/v1beta1
kind: DaemonSet
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"apps/v1","kind":"DaemonSet","metadata":{"annotations":{},"name":"csi-node","namespace":"kube-system"},"spec":{"selector":{"matchLabels":{"app":"csi-packet-driver"}},"template":{"metadata":{"labels":{"app":"csi-packet-driver"}},"spec":{"containers":[{"args":["--v=5","--csi-address=$(ADDRESS)","--kubelet-registration-path=/var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/csi.sock"],"env":[{"name":"ADDRESS","value":"/csi/csi.sock"},{"name":"KUBE_NODE_NAME","valueFrom":{"fieldRef":{"fieldPath":"spec.nodeName"}}}],"image":"quay.io/k8scsi/csi-node-driver-registrar:v1.2.0","imagePullPolicy":"IfNotPresent","name":"csi-driver-registrar","volumeMounts":[{"mountPath":"/csi","name":"plugin-dir"},{"mountPath":"/registration","name":"registration-dir"}]},{"args":["--endpoint=$(CSI_ENDPOINT)","--nodeid=$(KUBE_NODE_NAME)"],"env":[{"name":"CSI_ENDPOINT","value":"unix:///csi/csi.sock"},{"name":"KUBE_NODE_NAME","valueFrom":{"fieldRef":{"fieldPath":"spec.nodeName"}}}],"image":"docker.io/packethost/csi-packet:1c039e3","imagePullPolicy":"Always","name":"packet-driver","securityContext":{"privileged":true},"volumeMounts":[{"mountPath":"/var/lib/rancher/k3s/agent/kubelet/pods","mountPropagation":"Bidirectional","name":"kubelet-dir"},{"mountPath":"/sbin/iscsiadm","name":"iscsiadm"},{"mountPath":"/csi","name":"plugin-dir"},{"mountPath":"/sys/devices","name":"sys-devices"},{"mountPath":"/dev","name":"dev"},{"mountPath":"/etc","name":"etc"},{"mountPath":"/run/udev","name":"run-udev"},{"mountPath":"/var/lib/iscsi","name":"var-lib-iscsi"},{"mountPath":"/lib/modules","name":"lib-modules"},{"mountPath":"/usr/share/ca-certificates/","name":"ca-certs-alternative","readOnly":true}]}],"hostNetwork":true,"serviceAccount":"csi-node-sa","volumes":[{"hostPath":{"path":"/var/lib/rancher/k3s/agent/kubelet/plugins_registry","type":"Directory"},"name":"registration-dir"},{"hostPath":{"path":"/var/lib/rancher/k3s/agent/kubelet/pods","type":"Directory"},"name":"kubelet-dir"},{"hostPath":{"path":"/var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/","type":"DirectoryOrCreate"},"name":"plugin-dir"},{"hostPath":{"path":"/sbin/iscsiadm","type":"File"},"name":"iscsiadm"},{"hostPath":{"path":"/dev","type":"Directory"},"name":"dev"},{"hostPath":{"path":"/etc/"},"name":"etc"},{"hostPath":{"path":"/var/lib/iscsi/","type":"DirectoryOrCreate"},"name":"var-lib-iscsi"},{"hostPath":{"path":"/sys/devices","type":"Directory"},"name":"sys-devices"},{"hostPath":{"path":"/run/udev/","type":"Directory"},"name":"run-udev"},{"hostPath":{"path":"/lib/modules","type":"Directory"},"name":"lib-modules"},{"hostPath":{"path":"/usr/share/ca-certificates/","type":"DirectoryOrCreate"},"name":"ca-certs-alternative"}]}}}}
  creationTimestamp: "2019-10-08T09:38:30Z"
  generation: 1
  name: csi-node
  namespace: kube-system
  resourceVersion: "423"
  selfLink: /apis/extensions/v1beta1/namespaces/kube-system/daemonsets/csi-node
  uid: d2c80c36-4369-4861-8f9c-aa9e4481b87d
spec:
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: csi-packet-driver
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: csi-packet-driver
    spec:
      containers:
      - args:
        - --v=5
        - --csi-address=$(ADDRESS)
        - --kubelet-registration-path=/var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/csi.sock
        env:
        - name: ADDRESS
          value: /csi/csi.sock
        - name: KUBE_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        image: quay.io/k8scsi/csi-node-driver-registrar:v1.2.0
        imagePullPolicy: IfNotPresent
        name: csi-driver-registrar
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /csi
          name: plugin-dir
        - mountPath: /registration
          name: registration-dir
      - args:
        - --endpoint=$(CSI_ENDPOINT)
        - --nodeid=$(KUBE_NODE_NAME)
        env:
        - name: CSI_ENDPOINT
          value: unix:///csi/csi.sock
        - name: KUBE_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        image: docker.io/packethost/csi-packet:1c039e3
        imagePullPolicy: Always
        name: packet-driver
        resources: {}
        securityContext:
          privileged: true
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/lib/rancher/k3s/agent/kubelet/pods
          mountPropagation: Bidirectional
          name: kubelet-dir
        - mountPath: /sbin/iscsiadm
          name: iscsiadm
        - mountPath: /csi
          name: plugin-dir
        - mountPath: /sys/devices
          name: sys-devices
        - mountPath: /dev
          name: dev
        - mountPath: /etc
          name: etc
        - mountPath: /run/udev
          name: run-udev
        - mountPath: /var/lib/iscsi
          name: var-lib-iscsi
        - mountPath: /lib/modules
          name: lib-modules
        - mountPath: /usr/share/ca-certificates/
          name: ca-certs-alternative
          readOnly: true
      dnsPolicy: ClusterFirst
      hostNetwork: true
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: csi-node-sa
      serviceAccountName: csi-node-sa
      terminationGracePeriodSeconds: 30
      volumes:
      - hostPath:
          path: /var/lib/rancher/k3s/agent/kubelet/plugins_registry
          type: Directory
        name: registration-dir
      - hostPath:
          path: /var/lib/rancher/k3s/agent/kubelet/pods
          type: Directory
        name: kubelet-dir
      - hostPath:
          path: /var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/
          type: DirectoryOrCreate
        name: plugin-dir
      - hostPath:
          path: /sbin/iscsiadm
          type: File
        name: iscsiadm
      - hostPath:
          path: /dev
          type: Directory
        name: dev
      - hostPath:
          path: /etc/
          type: ""
        name: etc
      - hostPath:
          path: /var/lib/iscsi/
          type: DirectoryOrCreate
        name: var-lib-iscsi
      - hostPath:
          path: /sys/devices
          type: Directory
        name: sys-devices
      - hostPath:
          path: /run/udev/
          type: Directory
        name: run-udev
      - hostPath:
          path: /lib/modules
          type: Directory
        name: lib-modules
      - hostPath:
          path: /usr/share/ca-certificates/
          type: DirectoryOrCreate
        name: ca-certs-alternative
  templateGeneration: 1
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
status:
  currentNumberScheduled: 1
  desiredNumberScheduled: 1
  numberAvailable: 1
  numberMisscheduled: 0
  numberReady: 1
  observedGeneration: 1
  updatedNumberScheduled: 1
```

## Logs (Pre Provision)

### kublet
```
Oct 08 09:41:16 k1.ovrclk.net k3s[11703]: E1008 09:41:16.069020   11703 goroutinemap.go:150] Operation for "/var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/csi.sock" failed. No retries permitted until 2019-10-08 09:43:18.068964228 +0000 UTC m=+294.756846874 (durationBeforeRetry 2m2s). Error: "RegisterPlugin error -- failed to get plugin info using RPC GetInfo at socket /var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/csi.sock, err: rpc error: code = Unimplemented desc = unknown service pluginregistration.Registration"
```

### packet-driver
```
{"level":"info","msg":"started","time":"2019-10-08T09:39:05Z","version":"1c039e3"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"Starting server","node":"k1.ovrclk.net","time":"2019-10-08T09:39:05Z"}
{"address":"//csi/csi.sock","level":"info","msg":"Listening for connections","proto":"unix","time":"2019-10-08T09:39:05Z"}
{"level":"info","msg":"PacketIdentityServer.GetPluginInfo called","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/GetPluginInfo","GRPC.request":"","level":"info","msg":"GRPC response: name:\"net.packet.csi\" vendor_version:\"1c039e3\" ","time":"2019-10-08T09:39:06Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetInfo called","node":"k1.ovrclk.net","time":"2019-10-08T09:39:07Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetInfo","GRPC.request":"","level":"info","msg":"GRPC response: node_id:\"k1.ovrclk.net\" ","time":"2019-10-08T09:39:07Z"}
```

### csi-driver-registrar
```
I1008 09:39:00.396246       1 main.go:110] Version: v1.2.0-0-g6ef000ae
I1008 09:39:00.396272       1 main.go:120] Attempting to open a gRPC connection with: "/csi/csi.sock"
I1008 09:39:00.396279       1 connection.go:151] Connecting to unix:///csi/csi.sock
I1008 09:39:06.626105       1 main.go:127] Calling CSI driver to discover driver name
I1008 09:39:06.626127       1 connection.go:180] GRPC call: /csi.v1.Identity/GetPluginInfo
I1008 09:39:06.626134       1 connection.go:181] GRPC request: {}
I1008 09:39:06.627616       1 connection.go:183] GRPC response: {"name":"net.packet.csi","vendor_version":"1c039e3"}
I1008 09:39:06.628109       1 connection.go:184] GRPC error: <nil>
I1008 09:39:06.628117       1 main.go:137] CSI driver name: "net.packet.csi"
I1008 09:39:06.628135       1 node_register.go:58] Starting Registration Server at: /registration/net.packet.csi-reg.sock
I1008 09:39:06.628229       1 node_register.go:67] Registration Server started at: /registration/net.packet.csi-reg.sock
I1008 09:39:07.025889       1 main.go:77] Received GetInfo call: &InfoRequest{}
I1008 09:39:07.034070       1 main.go:87] Received NotifyRegistrationStatus call: &RegistrationStatus{PluginRegistered:true,Error:,}
```

## Logs (Post Provision)

### kubelet
```
Oct 08 09:50:39 k1.ovrclk.net k3s[11703]: I1008 09:50:39.541039   11703 event.go:258] Event(v1.ObjectReference{Kind:"PersistentVolumeClaim", Namespace:"akash-sanity-1570528238", Name:"sanity-pvc", UID:"b71827b4-9e13-43f7-80a8-efbf446bb6bb", APIVersion:"v1", ResourceVersion:"653", FieldPath:""}): type: 'Normal' reason: 'ExternalProvisioning' waiting for a volume to be created, either by external provisioner "net.packet.csi" or manually created by system administrator
Oct 08 09:50:39 k1.ovrclk.net k3s[11703]: I1008 09:50:39.541559   11703 event.go:258] Event(v1.ObjectReference{Kind:"PersistentVolumeClaim", Namespace:"akash-sanity-1570528238", Name:"sanity-pvc", UID:"b71827b4-9e13-43f7-80a8-efbf446bb6bb", APIVersion:"v1", ResourceVersion:"653", FieldPath:""}): type: 'Normal' reason: 'ExternalProvisioning' waiting for a volume to be created, either by external provisioner "net.packet.csi" or manually created by system administrator
Oct 08 09:50:39 k1.ovrclk.net k3s[11703]: E1008 09:50:39.811161   11703 factory.go:678] Error scheduling akash-sanity-1570528238/sanity-pod: pod has unbound immediate PersistentVolumeClaims; retrying
Oct 08 09:50:39 k1.ovrclk.net k3s[11703]: E1008 09:50:39.820339   11703 scheduler.go:485] error selecting node for pod: pod has unbound immediate PersistentVolumeClaims
Oct 08 09:50:45 k1.ovrclk.net k3s[11703]: I1008 09:50:45.226291   11703 event.go:258] Event(v1.ObjectReference{Kind:"PersistentVolumeClaim", Namespace:"akash-sanity-1570528238", Name:"sanity-pvc", UID:"b71827b4-9e13-43f7-80a8-efbf446bb6bb", APIVersion:"v1", ResourceVersion:"653", FieldPath:""}): type: 'Normal' reason: 'ExternalProvisioning' waiting for a volume to be created, either by external provisioner "net.packet.csi" or manually created by system administrator
Oct 08 09:50:45 k1.ovrclk.net k3s[11703]: E1008 09:50:45.417645   11703 factory.go:678] Error scheduling akash-sanity-1570528238/sanity-pod: pod has unbound immediate PersistentVolumeClaims; retrying
Oct 08 09:50:45 k1.ovrclk.net k3s[11703]: E1008 09:50:45.417671   11703 scheduler.go:485] error selecting node for pod: pod has unbound immediate PersistentVolumeClaims
Oct 08 09:50:47 k1.ovrclk.net k3s[11703]: I1008 09:50:47.867470   11703 reconciler.go:288] attacherDetacher.AttachVolume started for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") from node "k1.ovrclk.net"
Oct 08 09:50:47 k1.ovrclk.net k3s[11703]: I1008 09:50:47.959856   11703 reconciler.go:203] operationExecutor.VerifyControllerAttachedVolume started for volume "default-token-4mxmd" (UniqueName: "kubernetes.io/secret/92fef253-ca60-48e3-ae8e-ef6826ff6d3b-default-token-4mxmd") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b")
Oct 08 09:50:47 k1.ovrclk.net k3s[11703]: I1008 09:50:47.960108   11703 reconciler.go:203] operationExecutor.VerifyControllerAttachedVolume started for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b")
Oct 08 09:50:47 k1.ovrclk.net k3s[11703]: E1008 09:50:47.960329   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:48.460260533 +0000 UTC m=+745.148143131 (durationBeforeRetry 500ms). Error: "Volume has not been added to the list of VolumesInUse in the node's volume status for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") "
Oct 08 09:50:48 k1.ovrclk.net k3s[11703]: I1008 09:50:48.462104   11703 reconciler.go:203] operationExecutor.VerifyControllerAttachedVolume started for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b")
Oct 08 09:50:48 k1.ovrclk.net k3s[11703]: E1008 09:50:48.462320   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:49.462243959 +0000 UTC m=+746.150126529 (durationBeforeRetry 1s). Error: "Volume has not been added to the list of VolumesInUse in the node's volume status for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") "
Oct 08 09:50:49 k1.ovrclk.net k3s[11703]: I1008 09:50:49.466599   11703 reconciler.go:203] operationExecutor.VerifyControllerAttachedVolume started for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b")
Oct 08 09:50:49 k1.ovrclk.net k3s[11703]: E1008 09:50:49.466804   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:51.466741244 +0000 UTC m=+748.154623751 (durationBeforeRetry 2s). Error: "Volume has not been added to the list of VolumesInUse in the node's volume status for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") "
Oct 08 09:50:51 k1.ovrclk.net k3s[11703]: I1008 09:50:51.474987   11703 reconciler.go:203] operationExecutor.VerifyControllerAttachedVolume started for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b")
Oct 08 09:50:51 k1.ovrclk.net k3s[11703]: E1008 09:50:51.479844   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:55.479781838 +0000 UTC m=+752.167664385 (durationBeforeRetry 4s). Error: "Volume not attached according to node status for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") "
Oct 08 09:50:54 k1.ovrclk.net k3s[11703]: I1008 09:50:54.316597   11703 operation_generator.go:358] AttachVolume.Attach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") from node "k1.ovrclk.net"
Oct 08 09:50:54 k1.ovrclk.net k3s[11703]: I1008 09:50:54.316780   11703 event.go:258] Event(v1.ObjectReference{Kind:"Pod", Namespace:"akash-sanity-1570528238", Name:"sanity-pod", UID:"92fef253-ca60-48e3-ae8e-ef6826ff6d3b", APIVersion:"v1", ResourceVersion:"668", FieldPath:""}): type: 'Normal' reason: 'SuccessfulAttachVolume' AttachVolume.Attach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
Oct 08 09:50:55 k1.ovrclk.net k3s[11703]: I1008 09:50:55.491309   11703 reconciler.go:203] operationExecutor.VerifyControllerAttachedVolume started for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b")
Oct 08 09:50:55 k1.ovrclk.net k3s[11703]: I1008 09:50:55.496360   11703 operation_generator.go:1437] Controller attach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") device path: ""
Oct 08 09:50:55 k1.ovrclk.net k3s[11703]: I1008 09:50:55.692429   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:50:55 k1.ovrclk.net k3s[11703]: I1008 09:50:55.696844   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:50:55 k1.ovrclk.net k3s[11703]: E1008 09:50:55.858905   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:50:55 k1.ovrclk.net k3s[11703]: E1008 09:50:55.859055   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:56.359034549 +0000 UTC m=+753.046916974 (durationBeforeRetry 500ms). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:50:56 k1.ovrclk.net k3s[11703]: I1008 09:50:56.511701   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:50:56 k1.ovrclk.net k3s[11703]: I1008 09:50:56.516468   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:50:56 k1.ovrclk.net k3s[11703]: E1008 09:50:56.653324   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:50:56 k1.ovrclk.net k3s[11703]: E1008 09:50:56.653824   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:57.6537525 +0000 UTC m=+754.341635011 (durationBeforeRetry 1s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:50:57 k1.ovrclk.net k3s[11703]: I1008 09:50:57.823552   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:50:57 k1.ovrclk.net k3s[11703]: I1008 09:50:57.828097   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:50:57 k1.ovrclk.net k3s[11703]: E1008 09:50:57.962424   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:50:57 k1.ovrclk.net k3s[11703]: E1008 09:50:57.962903   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:50:59.96283464 +0000 UTC m=+756.650717129 (durationBeforeRetry 2s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:51:00 k1.ovrclk.net k3s[11703]: I1008 09:51:00.123748   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:51:00 k1.ovrclk.net k3s[11703]: I1008 09:51:00.128413   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:51:00 k1.ovrclk.net k3s[11703]: E1008 09:51:00.263783   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:51:00 k1.ovrclk.net k3s[11703]: E1008 09:51:00.264341   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:51:04.264248989 +0000 UTC m=+760.952131520 (durationBeforeRetry 4s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:51:04 k1.ovrclk.net k3s[11703]: I1008 09:51:04.443450   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:51:04 k1.ovrclk.net k3s[11703]: I1008 09:51:04.448071   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:51:04 k1.ovrclk.net k3s[11703]: E1008 09:51:04.582853   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:51:04 k1.ovrclk.net k3s[11703]: E1008 09:51:04.583395   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:51:12.583305321 +0000 UTC m=+769.271187842 (durationBeforeRetry 8s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:51:12 k1.ovrclk.net k3s[11703]: I1008 09:51:12.783655   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:51:12 k1.ovrclk.net k3s[11703]: I1008 09:51:12.788414   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:51:12 k1.ovrclk.net k3s[11703]: E1008 09:51:12.921761   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:51:12 k1.ovrclk.net k3s[11703]: E1008 09:51:12.922290   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:51:28.922216873 +0000 UTC m=+785.610099389 (durationBeforeRetry 16s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:51:23 k1.ovrclk.net k3s[11703]: I1008 09:51:23.720492   11703 trace.go:116] Trace[729856802]: "Get /api/v1/namespaces/kube-system/pods/csi-node-srtdr/log" (started: 2019-10-08 09:50:25.340144121 +0000 UTC m=+722.028026617) (total time: 58.380267342s):
Oct 08 09:51:23 k1.ovrclk.net k3s[11703]: Trace[729856802]: [58.380263243s] [58.375847887s] Transformed response object
Oct 08 09:51:23 k1.ovrclk.net k3s[11703]: I1008 09:51:23.726282   11703 log.go:172] http: superfluous response.WriteHeader call from github.com/rancher/k3s/vendor/k8s.io/apiserver/pkg/server/httplog.(*respLogger).WriteHeader (httplog.go:184)
Oct 08 09:51:26 k1.ovrclk.net k3s[11703]: E1008 09:51:26.283895   11703 goroutinemap.go:150] Operation for "/var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/csi.sock" failed. No retries permitted until 2019-10-08 09:53:28.283839312 +0000 UTC m=+904.971721985 (durationBeforeRetry 2m2s). Error: "RegisterPlugin error -- failed to get plugin info using RPC GetInfo at socket /var/lib/rancher/k3s/agent/kubelet/plugins/net.packet.csi/csi.sock, err: rpc error: code = Unimplemented desc = unknown service pluginregistration.Registration"
Oct 08 09:51:29 k1.ovrclk.net k3s[11703]: I1008 09:51:29.055018   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:51:29 k1.ovrclk.net k3s[11703]: I1008 09:51:29.056883   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:51:29 k1.ovrclk.net k3s[11703]: E1008 09:51:29.190995   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:51:29 k1.ovrclk.net k3s[11703]: E1008 09:51:29.191466   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:52:01.191394986 +0000 UTC m=+817.879277512 (durationBeforeRetry 32s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:52:01 k1.ovrclk.net k3s[11703]: I1008 09:52:01.391555   11703 operation_generator.go:629] MountVolume.WaitForAttach entering for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath ""
Oct 08 09:52:01 k1.ovrclk.net k3s[11703]: I1008 09:52:01.396287   11703 operation_generator.go:638] MountVolume.WaitForAttach succeeded for volume "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb" (UniqueName: "kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342") pod "sanity-pod" (UID: "92fef253-ca60-48e3-ae8e-ef6826ff6d3b") DevicePath "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
Oct 08 09:52:01 k1.ovrclk.net k3s[11703]: E1008 09:52:01.531149   11703 csi_attacher.go:337] kubernetes.io/csi: attacher.MountDevice failed: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21
Oct 08 09:52:01 k1.ovrclk.net k3s[11703]: E1008 09:52:01.531652   11703 nestedpendingoperations.go:270] Operation for "\"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\"" failed. No retries permitted until 2019-10-08 09:53:05.531554553 +0000 UTC m=+882.219437078 (durationBeforeRetry 1m4s). Error: "MountVolume.MountDevice failed for volume \"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" (UniqueName: \"kubernetes.io/csi/net.packet.csi^51e533b3-a38e-4ebf-917f-6f90920c1342\") pod \"sanity-pod\" (UID: \"92fef253-ca60-48e3-ae8e-ef6826ff6d3b\") : rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21"
Oct 08 09:52:24 k1.ovrclk.net k3s[11703]: I1008 09:52:24.098998   11703 trace.go:116] Trace[880451703]: "Get /api/v1/namespaces/kube-system/pods/csi-node-srtdr/log" (started: 2019-10-08 09:50:30.740991707 +0000 UTC m=+727.428874233) (total time: 1m53.357925044s):
Oct 08 09:52:24 k1.ovrclk.net k3s[11703]: Trace[880451703]: [1m53.357922502s] [1m53.353923807s] Transformed response object
```

### node / packet-driver

```
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:50:55Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:50:55Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:50:55Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:50:55Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:50:55Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:50:55Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:50:56Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:50:56Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:50:56Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:50:56Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:50:56Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:50:56Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:50:57Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:50:57Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:50:57Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:50:57Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:50:57Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:50:57Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:00Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:51:00Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:00Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:51:00Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:51:00Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:51:00Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:04Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:51:04Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:04Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:51:04Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:51:04Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:51:04Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:12Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:51:12Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:12Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:51:12Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:51:12Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:51:12Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:29Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:51:29Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:51:29Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:51:29Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:51:29Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:51:29Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeGetCapabilities called","node":"k1.ovrclk.net","time":"2019-10-08T09:52:01Z"}
{"GRPC.call":"/csi.v1.Node/NodeGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:STAGE_UNSTAGE_VOLUME \u003e \u003e ","time":"2019-10-08T09:52:01Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"NodeStageVolume called","node":"k1.ovrclk.net","time":"2019-10-08T09:52:01Z"}
{"args":"--mode discovery --portal 10.144.144.135 --type sendtargets --discover","command":"iscsiadm","error":"exit status 21","level":"error","msg":"Error","out":"iscsiadm: No portals found\n","time":"2019-10-08T09:52:01Z"}
{"endpoint":"unix:///csi/csi.sock","fsType":"ext4","level":"info","method":"NodeStageVolume","msg":"iscsiadmin discover error, exit status 21","node":"k1.ovrclk.net","staging_target_path":"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount","time":"2019-10-08T09:52:01Z","volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342","volume_name":"volume-51e533b3"}
{"GRPC.call":"/csi.v1.Node/NodeStageVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e staging_target_path:\"/var/lib/rancher/k3s/agent/kubelet/plugins/kubernetes.io/csi/pv/pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb/globalmount\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = iscsiadmin discover error, exit status 21","time":"2019-10-08T09:52:01Z"}
```

### controller / csi-attacher

```
I1008 09:39:03.266522       1 main.go:85] Version: v2.0.0-0-g27b83ca
I1008 09:39:03.267608       1 connection.go:151] Connecting to unix:///csi/csi.sock
I1008 09:39:06.210998       1 common.go:111] Probing CSI driver for readiness
I1008 09:39:06.211015       1 connection.go:180] GRPC call: /csi.v1.Identity/Probe
I1008 09:39:06.211020       1 connection.go:181] GRPC request: {}
I1008 09:39:06.212151       1 connection.go:183] GRPC response: {}
I1008 09:39:06.212769       1 connection.go:184] GRPC error: <nil>
I1008 09:39:06.212818       1 connection.go:180] GRPC call: /csi.v1.Identity/GetPluginInfo
I1008 09:39:06.212824       1 connection.go:181] GRPC request: {}
I1008 09:39:06.213491       1 connection.go:183] GRPC response: {"name":"net.packet.csi","vendor_version":"1c039e3"}
I1008 09:39:06.213851       1 connection.go:184] GRPC error: <nil>
I1008 09:39:06.213857       1 main.go:128] CSI driver name: "net.packet.csi"
I1008 09:39:06.213862       1 connection.go:180] GRPC call: /csi.v1.Identity/GetPluginCapabilities
I1008 09:39:06.213865       1 connection.go:181] GRPC request: {}
I1008 09:39:06.214461       1 connection.go:183] GRPC response: {"capabilities":[{"Type":{"Service":{"type":1}}}]}
I1008 09:39:06.214921       1 connection.go:184] GRPC error: <nil>
I1008 09:39:06.214925       1 connection.go:180] GRPC call: /csi.v1.Controller/ControllerGetCapabilities
I1008 09:39:06.214928       1 connection.go:181] GRPC request: {}
I1008 09:39:06.215419       1 connection.go:183] GRPC response: {"capabilities":[{"Type":{"Rpc":{"type":1}}},{"Type":{"Rpc":{"type":2}}},{"Type":{"Rpc":{"type":3}}}]}
I1008 09:39:06.216309       1 connection.go:184] GRPC error: <nil>
I1008 09:39:06.216329       1 main.go:152] CSI driver supports ControllerPublishUnpublish, using real CSI handler
I1008 09:39:06.216404       1 controller.go:113] Starting CSI attacher
I1008 09:39:06.216829       1 reflector.go:123] Starting reflector *v1beta1.CSINode (10m0s) from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.216898       1 reflector.go:161] Listing and watching *v1beta1.CSINode from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.216829       1 reflector.go:123] Starting reflector *v1.Node (10m0s) from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.216966       1 reflector.go:161] Listing and watching *v1.Node from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.216835       1 reflector.go:123] Starting reflector *v1beta1.VolumeAttachment (10m0s) from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.217006       1 reflector.go:161] Listing and watching *v1beta1.VolumeAttachment from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.216881       1 reflector.go:123] Starting reflector *v1.PersistentVolume (10m0s) from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.217140       1 reflector.go:161] Listing and watching *v1.PersistentVolume from k8s.io/client-go/informers/factory.go:133
I1008 09:39:06.316560       1 shared_informer.go:123] caches populated
I1008 09:46:17.229984       1 reflector.go:370] k8s.io/client-go/informers/factory.go:133: Watch close - *v1.PersistentVolume total 0 items received
I1008 09:47:07.227062       1 reflector.go:370] k8s.io/client-go/informers/factory.go:133: Watch close - *v1beta1.CSINode total 2 items received
I1008 09:47:25.229722       1 reflector.go:370] k8s.io/client-go/informers/factory.go:133: Watch close - *v1beta1.VolumeAttachment total 0 items received
I1008 09:48:48.227573       1 reflector.go:370] k8s.io/client-go/informers/factory.go:133: Watch close - *v1.Node total 11 items received
I1008 09:49:06.228962       1 reflector.go:235] k8s.io/client-go/informers/factory.go:133: forcing resync
I1008 09:49:06.229013       1 reflector.go:235] k8s.io/client-go/informers/factory.go:133: forcing resync
I1008 09:50:45.419485       1 controller.go:205] Started PV processing "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:45.419505       1 csi_handler.go:444] CSIHandler: processing PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:45.419516       1 csi_handler.go:448] CSIHandler: processing PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb": no deletion timestamp, ignoring
I1008 09:50:45.420235       1 controller.go:205] Started PV processing "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:45.420258       1 csi_handler.go:444] CSIHandler: processing PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:45.420268       1 csi_handler.go:448] CSIHandler: processing PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb": no deletion timestamp, ignoring
I1008 09:50:47.879324       1 controller.go:175] Started VA processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:47.879369       1 csi_handler.go:89] CSIHandler: processing VA "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:47.879389       1 csi_handler.go:116] Attaching "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:47.879408       1 csi_handler.go:249] Starting attach operation for "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:47.879570       1 csi_handler.go:215] Adding finalizer to PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:47.891041       1 csi_handler.go:224] PV finalizer added to "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:47.891100       1 csi_handler.go:542] Found NodeID k1.ovrclk.net in CSINode k1.ovrclk.net
I1008 09:50:47.891212       1 csi_handler.go:177] VA finalizer added to "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:47.891256       1 csi_handler.go:191] NodeID annotation added to "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:47.892158       1 controller.go:205] Started PV processing "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:47.892207       1 csi_handler.go:444] CSIHandler: processing PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:47.892245       1 csi_handler.go:448] CSIHandler: processing PV "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb": no deletion timestamp, ignoring
I1008 09:50:47.902939       1 connection.go:180] GRPC call: /csi.v1.Controller/ControllerPublishVolume
I1008 09:50:47.903001       1 connection.go:181] GRPC request: {"node_id":"k1.ovrclk.net","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1570527546484-8081-net.packet.csi"},"volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342"}
I1008 09:50:54.308320       1 connection.go:183] GRPC response: {"publish_context":{"AttachmentId":"c631ab93-fa62-4bc4-8c22-36d7b102266a","VolumeId":"51e533b3-a38e-4ebf-917f-6f90920c1342","VolumeName":"volume-51e533b3"}}
I1008 09:50:54.309920       1 connection.go:184] GRPC error: <nil>
I1008 09:50:54.309952       1 csi_handler.go:129] Attached "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.309974       1 util.go:35] Marking as attached "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316013       1 util.go:48] Marked as attached "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316062       1 csi_handler.go:135] Fully attached "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316098       1 csi_handler.go:105] CSIHandler: finished processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316178       1 controller.go:175] Started VA processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316210       1 csi_handler.go:89] CSIHandler: processing VA "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316240       1 csi_handler.go:116] Attaching "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316267       1 csi_handler.go:249] Starting attach operation for "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316492       1 csi_handler.go:209] PV finalizer is already set on "pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"
I1008 09:50:54.316541       1 csi_handler.go:542] Found NodeID k1.ovrclk.net in CSINode k1.ovrclk.net
I1008 09:50:54.316597       1 csi_handler.go:169] VA finalizer is already set on "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316624       1 csi_handler.go:183] NodeID annotation is already set on "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:54.316671       1 connection.go:180] GRPC call: /csi.v1.Controller/ControllerPublishVolume
I1008 09:50:54.316696       1 connection.go:181] GRPC request: {"node_id":"k1.ovrclk.net","volume_capability":{"AccessType":{"Mount":{"fs_type":"ext4"}},"access_mode":{"mode":1}},"volume_context":{"storage.kubernetes.io/csiProvisionerIdentity":"1570527546484-8081-net.packet.csi"},"volume_id":"51e533b3-a38e-4ebf-917f-6f90920c1342"}
I1008 09:50:56.987814       1 connection.go:183] GRPC response: {}
I1008 09:50:56.989194       1 connection.go:184] GRPC error: rpc error: code = Unknown desc = error attempting to attach 51e533b3-a38e-4ebf-917f-6f90920c1342 to 2b764f26-a703-4415-a294-142be3c72e97, POST https://api.packet.net/storage/51e533b3-a38e-4ebf-917f-6f90920c1342/attachments: 422 Instance is already attached to this volume
I1008 09:50:56.989236       1 csi_handler.go:412] Saving attach error to "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:56.995384       1 csi_handler.go:423] Saved attach error to "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:56.995491       1 csi_handler.go:99] Error processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa": failed to attach: rpc error: code = Unknown desc = error attempting to attach 51e533b3-a38e-4ebf-917f-6f90920c1342 to 2b764f26-a703-4415-a294-142be3c72e97, POST https://api.packet.net/storage/51e533b3-a38e-4ebf-917f-6f90920c1342/attachments: 422 Instance is already attached to this volume
I1008 09:50:56.995651       1 controller.go:175] Started VA processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:56.995705       1 csi_handler.go:89] CSIHandler: processing VA "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:56.995732       1 csi_handler.go:111] "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa" is already attached
I1008 09:50:56.995764       1 csi_handler.go:105] CSIHandler: finished processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:56.996198       1 controller.go:141] Ignoring VolumeAttachment "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa" change
I1008 09:50:57.995826       1 controller.go:175] Started VA processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:57.995878       1 csi_handler.go:89] CSIHandler: processing VA "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
I1008 09:50:57.995904       1 csi_handler.go:111] "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa" is already attached
I1008 09:50:57.995927       1 csi_handler.go:105] CSIHandler: finished processing "csi-38853ef68f955e2132a9ba0e35976886f648e07c7b847a1aefa3110353411aaa"
```

### controller / packet-driver
```
{"level":"info","msg":"started","time":"2019-10-08T09:39:05Z","version":"1c039e3"}
{"level":"info","msg":"Creating provider","project_id":"48e3616c-8a10-4aa5-8d39-ec6cb2cd8014","time":"2019-10-08T09:39:05Z"}
{"facility_id":"2b70eb8f-fa18-47c0-aba7-222a842362fd","level":"info","msg":"facility found","project_id":"48e3616c-8a10-4aa5-8d39-ec6cb2cd8014","time":"2019-10-08T09:39:06Z"}
{"endpoint":"unix:///csi/csi.sock","level":"info","msg":"Starting server","node":"k1.ovrclk.net","time":"2019-10-08T09:39:06Z"}
{"address":"//csi/csi.sock","level":"info","msg":"Listening for connections","proto":"unix","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"PacketIdentityServer.Probe called with args: \u0026csi.ProbeRequest{XXX_NoUnkeyedLiteral:struct {}{}, XXX_unrecognized:[]uint8(nil), XXX_sizecache:0}","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/Probe","GRPC.request":"","level":"info","msg":"GRPC response: ","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"PacketIdentityServer.GetPluginInfo called","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/GetPluginInfo","GRPC.request":"","level":"info","msg":"GRPC response: name:\"net.packet.csi\" vendor_version:\"1c039e3\" ","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"PacketIdentityServer.GetPluginCapabilities called","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/GetPluginCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003cservice:\u003ctype:CONTROLLER_SERVICE \u003e \u003e ","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Controller/ControllerGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:CREATE_DELETE_VOLUME \u003e \u003e capabilities:\u003crpc:\u003ctype:PUBLISH_UNPUBLISH_VOLUME \u003e \u003e capabilities:\u003crpc:\u003ctype:LIST_VOLUMES \u003e \u003e ","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"PacketIdentityServer.Probe called with args: \u0026csi.ProbeRequest{XXX_NoUnkeyedLiteral:struct {}{}, XXX_unrecognized:[]uint8(nil), XXX_sizecache:0}","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/Probe","GRPC.request":"","level":"info","msg":"GRPC response: ","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"PacketIdentityServer.GetPluginInfo called","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/GetPluginInfo","GRPC.request":"","level":"info","msg":"GRPC response: name:\"net.packet.csi\" vendor_version:\"1c039e3\" ","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"PacketIdentityServer.GetPluginCapabilities called","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Identity/GetPluginCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003cservice:\u003ctype:CONTROLLER_SERVICE \u003e \u003e ","time":"2019-10-08T09:39:06Z"}
{"GRPC.call":"/csi.v1.Controller/ControllerGetCapabilities","GRPC.request":"","level":"info","msg":"GRPC response: capabilities:\u003crpc:\u003ctype:CREATE_DELETE_VOLUME \u003e \u003e capabilities:\u003crpc:\u003ctype:PUBLISH_UNPUBLISH_VOLUME \u003e \u003e capabilities:\u003crpc:\u003ctype:LIST_VOLUMES \u003e \u003e ","time":"2019-10-08T09:39:06Z"}
{"level":"info","msg":"CreateVolume called","time":"2019-10-08T09:50:39Z","volume_name":"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"}
{"level":"info","msg":"Volume requested","planID":"87728148-3155-4992-a730-8d1e6aca8a32","sizeRequestGiB":10,"time":"2019-10-08T09:50:39Z","volume_name":"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb"}
{"GRPC.call":"/csi.v1.Controller/CreateVolume","GRPC.request":"name:\"pvc-b71827b4-9e13-43f7-80a8-efbf446bb6bb\" capacity_range:\u003crequired_bytes:1073741824 \u003e volume_capabilities:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e parameters:\u003ckey:\"plan\" value:\"standard\" \u003e ","level":"info","msg":"GRPC response: volume:\u003ccapacity_bytes:10737418240 volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e ","time":"2019-10-08T09:50:45Z"}
{"GRPC.call":"/csi.v1.Controller/ControllerPublishVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" node_id:\"k1.ovrclk.net\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"info","msg":"GRPC response: publish_context:\u003ckey:\"AttachmentId\" value:\"c631ab93-fa62-4bc4-8c22-36d7b102266a\" \u003e publish_context:\u003ckey:\"VolumeId\" value:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" \u003e publish_context:\u003ckey:\"VolumeName\" value:\"volume-51e533b3\" \u003e ","time":"2019-10-08T09:50:54Z"}
{"GRPC.call":"/csi.v1.Controller/ControllerPublishVolume","GRPC.request":"volume_id:\"51e533b3-a38e-4ebf-917f-6f90920c1342\" node_id:\"k1.ovrclk.net\" volume_capability:\u003cmount:\u003cfs_type:\"ext4\" \u003e access_mode:\u003cmode:SINGLE_NODE_WRITER \u003e \u003e volume_context:\u003ckey:\"storage.kubernetes.io/csiProvisionerIdentity\" value:\"1570527546484-8081-net.packet.csi\" \u003e ","level":"error","msg":"GRPC error: rpc error: code = Unknown desc = error attempting to attach 51e533b3-a38e-4ebf-917f-6f90920c1342 to 2b764f26-a703-4415-a294-142be3c72e97, POST https://api.packet.net/storage/51e533b3-a38e-4ebf-917f-6f90920c1342/attachments: 422 Instance is already attached to this volume ","time":"2019-10-08T09:50:56Z"}
```

## volumes

```
$ curl -s https://metadata.packet.net/metadata | jq '.volumes'

[
  {
    "ips": [
      "10.144.144.133",
      "10.144.145.138"
    ],
    "name": "volume-40e826a5",
    "capacity": {
      "size": "10",
      "unit": "gb"
    },
    "iqn": "iqn.2013-05.com.daterainc:tc:01:sn:9c791ef25608a08c"
  },
  {
    "ips": [
      "10.144.144.135",
      "10.144.145.210"
    ],
    "name": "volume-51e533b3",
    "capacity": {
      "size": "10",
      "unit": "gb"
    },
    "iqn": "iqn.2013-05.com.daterainc:tc:01:sn:35f488b87b3c6dae"
  }
]
```

## iscsiadm
```
$ iscsiadm --mode discovery --type sendtargets --portal 10.144.144.135 --discover

iscsiadm: No portals found
```
