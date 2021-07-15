FROM  deepexi/java:v0.0.1
WORKDIR /opt/
COPY target/spring-boot-k8s-app.jar /opt/
EXPOSE 8080
CMD ["java","-Djava.security.egd=file:/dev/./urandom","-Xms400m","-Xmx400m","-jar","/opt/spring-boot-k8s-app.jar", "--spring.profiles.active=prod"]
