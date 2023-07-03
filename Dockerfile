FROM chef/inspec:5.22.3

RUN mkdir -p /etc/chef/accepted_licenses
COPY inspec-accepted-license /etc/chef/accepted_licenses/inspec
COPY package.json /home/jenkins/agent/workspace/CCO/ACTIVE_JOBS/Test-Jobs/adhoc-regression-tests-applicationCreationUtility
RUN apt-get update && \
    apt-get -y install curl && \
    apt-get -y install build-essential
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN apt-get -y install nodejs npm

RUN apt-get -y install sudo

RUN apt-get install -y p7zip \
    p7zip-full \
    unace \
    zip \
    unzip \
    xz-utils \
    sharutils \
    uudeview \
    mpack \
    arj \
    cabextract \
    file-roller \
    && rm -rf /var/lib/apt/lists/*

#install and set-up aws-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
unzip awscliv2.zip && \
 ./aws/install





COPY /kube /root/.kube
COPY /aws /root/.aws

