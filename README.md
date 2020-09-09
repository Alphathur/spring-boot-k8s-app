# Spring-Boot-K8s-App
A project to show how to run springboot application and mysql in kubernetes cluster

## Prerequisite
- Docker and kubernetes cluster
- Local registry ([setup guide](https://medium.com/htc-research-engineering-blog/setup-local-docker-repository-for-local-kubernetes-cluster-354f0730ed3a))
- kubectl
- Jdk 1.8
- Maven 3.x

## Setup application
### download this project
download or clone this project, use your master node ip to replace `192.168.6.128` in [deploy/spring-boot-deployment.yaml](https://github.com/Alphathur/spring-boot-k8s-app/blob/master/deploy/spring-boot-deployment.yaml#L30)
### start mysql database
```bash
kubectl apply -f deploy/mysql-pv.yaml
kubectl apply -f deploy/mysql-deployment.yaml
```
### start springboot application
```bash
sh deploy/auto-deploy.sh
```
### all pods are running
```bash
[root@k8s-master Desktop]# kubectl get pods -o wide
NAME                                             READY   STATUS    RESTARTS   AGE    IP            NODE        NOMINATED NODE   READINESS GATES
mysql-788465ddd-blq6z                            1/1     Running   0          108s   10.244.1.33   k8s-node1   <none>           <none>
spring-boot-k8s-app-deployment-bf6b8d8b4-xkcgb   1/1     Running   0          11m    10.244.2.25   k8s-node2   <none>           <none>
```
### Test your application
get node ip
```bash
[root@k8s-master Desktop]# kubectl get nodes -o wide
NAME         STATUS   ROLES    AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
k8s-master   Ready    master   45h   v1.19.0   192.168.6.128   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://18.6.1
k8s-node1    Ready    <none>   44h   v1.19.0   192.168.6.131   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://18.6.1
k8s-node2    Ready    <none>   44h   v1.19.0   192.168.6.132   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://18.6.1
```
use `http://{NodeIp}:{NodePort}` to test your api
```bash
[root@k8s-master Desktop]# curl http://192.168.6.132:32082
SpringBoot K8s Application
```
```bash
[root@k8s-master Desktop]# curl http://192.168.6.132:32082/students
[{"id":1,"name":"Andrew","age":22,"gender":"1","parent":"Sony","birth":"1998-06-23"},{"id":2,"name":"Tom","age":21,"gender":"0","parent":"Jackie","birth":"1999-01-23"},{"id":3,"name":"Johnson","age":20,"gender":"1","parent":"Mickey","birth":"1920-11-23"}]
```

### Uninstall application
```java
kubectl delete -f deploy/mysql-deployment.yaml
kubectl delete -f deploy/mysql-pv.yaml
kubectl delete -f deploy/spring-boot-deployment.yaml
```
