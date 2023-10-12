# Collect Metrics 

First build a container using the Dockerfile file

For now the script support is limited to 2 scripts (refer to scripts/metrics directory)

- metrics.sh
- network-metrics.sh (uses monitor.sh)

These scripts will be copied to the /run/collect-metrics/scripts folder in the container

```bash
podman build -t quay.io/<user-name>/collect-metrics:dev .

```

```bash
podman run --privileged --cap-add=NET_ADMIN --user 0:0 -it quay.io/<user-name>/collect-metrics:dev /run/collect-metrics/scripts/metrics.sh 

```

Check the output log of the running podman instance

```bash
podman log <running-instance>


```

## Use with oc adm collect-metrics cli

```bash
oc adm collect-metrics  --image quay.io/luzuccar/collect-metrics:v0.0.1 --src-dir /run/collect-metrics/archives --command /run/collect-metrics/scripts/metrics.sh --cmd-args 10 --cmd-args 25 --keep true

/oc adm collect-metrics  --image quay.io/luzuccar/collect-metrics:v0.0.1 --src-dir /run/collect-metrics/archives --command /run/collect-metrics/scripts/metrics.sh --cmd-args 10 --cmd-args 25 
[collect-metrics      ] OUT Using collect-metrics plug-in image: quay.io/luzuccar/collect-metrics:v0.0.1
I1012 07:10:56.699590  448809 collectmetrics.go:259] executing script /run/collect-metrics/scripts/metrics.sh
I1012 07:10:56.699598  448809 collectmetrics.go:260] arguments [10 25]
When opening a support case, bugzilla, or issue please include the following summary data along with any other requested information:
ClusterID: 20c4df62-3583-4a6e-910b-ea66fb09cd65
ClusterVersion: Stable at "4.13.0-0.okd-2023-08-04-164726"
ClusterOperators:
	All healthy and stable


clusterrole.rbac.authorization.k8s.io/system:openshift:scc:privileged added to
[collect-metrics      ] OUT namespace/openshift-collect-metrics created
[collect-metrics      ] OUT pod for plug-in image quay.io/luzuccar/collect-metrics:v0.0.1 created
[collect-metrics-scripting] POD 2023-10-12T05:11:07.330563981Z Metrics collection completed
[collect-metrics-scripting] OUT waiting for collect-metrics to complete
[collect-metrics-scripting] OUT downloading collect-metrics output
WARNING: cannot use rsync: rsync not available in container
[collect-metrics-scripting] OUT ./okd-cp1.lab.okd.lan-metrics_2023_10_12_05.tar.gz
Ignoring the following flags because they only apply to rsync: -z
[collect-metrics      ] OUT namespace/openshift-collect-metrics deleted


Reprinting Cluster State:
When opening a support case, bugzilla, or issue please include the following summary data along with any other requested information:
ClusterID: 20c4df62-3583-4a6e-910b-ea66fb09cd65
ClusterVersion: Stable at "4.13.0-0.okd-2023-08-04-164726"
ClusterOperators:
	All healthy and stable


```
