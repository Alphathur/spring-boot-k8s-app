# keep the newest codes if you want
# git pull origin master

# build maven jar file
mvn clean package -DskipTests

# generate a new tag
tag=$(date +"%Y%m%d-%H%M%S")
if [ $# -eq 1 ]; then
    tag=$1
fi

# build and push docker image
image=192.168.6.128:5000/spring-boot-k8s-app:$tag
imagename=spring-boot-k8s-app:$tag
docker build -t $image .
docker push $image

# update image tag
cp deploy/spring-boot-deployment.yaml deploy/spring-boot-deployment-tmp.yaml
sed -i s#spring-boot-k8s-app:[0-9]*-[0-9]*#$imagename# deploy/spring-boot-deployment-tmp.yaml

# deploy by yaml
kubectl apply -f deploy/spring-boot-deployment-tmp.yaml
