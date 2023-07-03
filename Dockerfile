FROM chef/inspec:5.22.3

RUN mkdir -p /etc/chef/accepted_licenses
COPY inspec-accepted-license /etc/chef/accepted_licenses/inspec

COPY /kube /root/.kube
COPY /aws /root/.aws

WORKDIR /