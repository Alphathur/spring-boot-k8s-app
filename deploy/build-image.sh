cd ../
git pull origin master
mvn clean package -DskipTests
tag=$(date +"%Y%m%d-%H%M%S")
if [ $# -eq 1 ]; then
    tag=$1
fi
image=localhost:5000/spring-boot-k8s-app:$tag
docker build -t $image .
docker push $image
echo "$image"

cd deploy
sed -i s#192.168.6.128:5000/spring-boot-k8s-app:[0-9]*-[0-9]*#$image
grep "192.168.6.128:5000/spring-boot-k8s-app" spring-boot-deployment.yaml

cat spring-boot-deployment.yaml
# kubectl apply -f spring-boot-deployment.yaml
