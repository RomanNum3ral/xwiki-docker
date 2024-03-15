#! /bin/bash

sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo docker network create -d bridge xwiki-nw
sudo docker run --net=xwiki-nw --name postgres-xwiki -v /my/path/postgres:/var/lib/postgresql/data -ePOSTGRES_ROOT_PASSWORD=password -e POSTGRES_USER=xwiki -e POSTGRES_PASSWORD=password -e POSTGRES_DB=xwiki -e POSTGRES_INITDB_ARGS="--encoding=UTF8" -d postgres:9.5
sudo docker run -d --net=xwiki-nw --name xwiki -p 8080:8080 -v /my/path/xwiki:/usr/local/xwiki -e DB_USER=xwiki -e DB_PASSWORD=password -e DB_DATABASE=xwiki -e DB_HOST=postgres-xwiki xwiki:lts-postgres-tomcat
