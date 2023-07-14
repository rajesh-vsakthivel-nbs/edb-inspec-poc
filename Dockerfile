FROM ubuntu:latest

RUN apt-get -y update; apt-get -y install curl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

CMD kubectl exec -it eo-web-lao-77569dcd86-5vrrz -n banking-lao-dev1 sh