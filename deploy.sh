cat /home/jenkins/hub.docker.com.passwd.txt | docker login --username robsdudeson --password-stdin
docker-compose -f /home/jenkins/blog/docker-compose.deploy.yml pull app
docker-compose -f /home/jenkins/blog/docker-compose.deploy.yml up -d --no-deps app
