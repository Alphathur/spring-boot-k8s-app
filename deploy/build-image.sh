git pull origin master
mvn clean package -DskipTests
tag=$(date +"%Y%m%d-%H%M%S")
if [ $# -eq 1 ]; then
    tag=$1
fi
image=localhost:5000/spring-boot-k8s-app:$tag
imagename=spring-boot-k8s-app:$tag

docker build -t $image .
docker push $image
echo "$image"

echo "$imagename"
pwd

cp deploy/spring-boot-deployment.yaml deploy/spring-boot-deployment-tmp.yaml

sed -i s#spring-boot-k8s-app:[0-9]*-[0-9]*#$imagename# deploy/spring-boot-deployment-tmp.yaml

kubectl apply -f deploy/spring-boot-deployment-tmp.yaml
