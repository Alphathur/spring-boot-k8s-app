# Spring-Boot-K8s-App
Run spring boot application and mysql on kubernetes cluster

## Prerequisite
- Docker and kubernetes cluster
- Local registry ([setup guide](https://docs.docker.com/registry/deploying/))
- kubectl
- Jdk 1.8
- Maven 3.x

## Setup application
### Replace your registry node ip
Download or clone the project, Use your registry node ip to replace `192.168.6.128` in [deploy/spring-boot-deployment.yaml](https://github.com/Alphathur/spring-boot-k8s-app/blob/master/deploy/spring-boot-deployment.yaml#L30). and cd to the project's root directory
### Create mysql secret to store database configuration
Note: my root password for mysql is `mysql520` and database user to connect spring application is `root`, all values in the [deploy/mysql-secret.yaml](https://github.com/Alphathur/spring-boot-k8s-app/blob/master/deploy/mysql-secret.yaml) are required to be base64 encoded, you can print base64 encode values easily from the terminal
```bash
echo "mysql520" | base64
bXlzcWw1MjAK
echo "root" | base64
cm9vdAo=
```
create mysql secret
```bash
kubectl apply -f deploy/mysql-secret.yaml
```
### Start mysql database
```bash
kubectl apply -f deploy/mysql-pv.yaml
kubectl apply -f deploy/mysql-deployment.yaml
```
### Start spring boot application
```bash
sh deploy/auto-deploy.sh
```
## Application started
### All pods are running
```bash
[root@k8s-master Desktop]# kubectl get pods -o wide
NAME                                             READY   STATUS    RESTARTS   AGE    IP            NODE        NOMINATED NODE   READINESS GATES
mysql-788465ddd-blq6z                            1/1     Running   0          108s   10.244.1.33   k8s-node1   <none>           <none>
spring-boot-k8s-app-deployment-bf6b8d8b4-xkcgb   1/1     Running   0          11m    10.244.2.25   k8s-node2   <none>           <none>
```
### Test your application
Get all nodes ip
```bash
[root@k8s-master Desktop]# kubectl get nodes -o wide
NAME         STATUS   ROLES    AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION               CONTAINER-RUNTIME
k8s-master   Ready    master   45h   v1.19.0   192.168.6.128   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://18.6.1
k8s-node1    Ready    <none>   44h   v1.19.0   192.168.6.131   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://18.6.1
k8s-node2    Ready    <none>   44h   v1.19.0   192.168.6.132   <none>        CentOS Linux 7 (Core)   3.10.0-957.12.2.el7.x86_64   docker://18.6.1
```
Test your api by `http://{NodeIp}:{NodePort}`, normally you will be able to access the api by using any of the nodes ip
```bash
[root@k8s-master Desktop]# curl http://192.168.6.132:32082
SpringBoot K8s Application
[root@k8s-master Desktop]# curl http://192.168.6.131:32082
SpringBoot K8s Application
```
```bash
[root@k8s-master Desktop]# curl http://192.168.6.132:32082/students
[{"id":1,"name":"Andrew","age":22,"gender":"1","parent":"Sony","birth":"1998-06-23"},{"id":2,"name":"Tom","age":21,"gender":"0","parent":"Jackie","birth":"1999-01-23"},{"id":3,"name":"Johnson","age":20,"gender":"1","parent":"Mickey","birth":"1920-11-23"}]
```

## Uninstall application
```java
kubectl delete -f deploy/mysql-deployment.yaml
kubectl delete -f deploy/mysql-secret.yaml
kubectl delete -f deploy/mysql-pv.yaml
kubectl delete -f deploy/spring-boot-deployment.yaml
```
