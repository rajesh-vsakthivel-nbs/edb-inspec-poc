FROM ubuntu:latest

RUN apt-get -y update; apt-get -y install curl sudo dpkg

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

COPY inspec_5.22.3-1_amd64.deb .
RUN sudo dpkg -i ./inspec_5.22.3-1_amd64.deb

COPY /kube /root/.kube
