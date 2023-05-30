sudo ./mvnw clean package
sudo docker build --force-rm -t "petclinic-admin-server:dev" ./spring-petclinic-admin-server
sudo docker build --force-rm -t "petclinic-api-gateway:dev" ./spring-petclinic-api-gateway
sudo docker build --force-rm -t "petclinic-config-server:dev" ./spring-petclinic-config-server
sudo docker build --force-rm -t "petclinic-customers-service:dev" ./spring-petclinic-customers-service
sudo docker build --force-rm -t "petclinic-discovery-server:dev" ./spring-petclinic-discovery-server
sudo docker build --force-rm -t "petclinic-hystrix-dashboard:dev" ./spring-petclinic-hystrix-dashboard
sudo sudo docker build --force-rm -t "petclinic-vets-service:dev" ./spring-petclinic-vets-service
sudo docker build --force-rm -t "petclinic-visits-service:dev" ./spring-petclinic-visits-service
sudo docker build --force-rm -t "petclinic-grafana-server:dev" ./docker/grafana
sudo docker build --force-rm -t "petclinic-prometheus-server:dev" ./docker/prometheus