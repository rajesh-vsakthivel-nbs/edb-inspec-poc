def BUILDSTATUS = 'INITIALVALUE'
pipeline {


    agent {
        kubernetes {
            cloud 'kubernetes-edbhub-dev'
            yaml """\
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      annotations:
                        cluster-autoscaler.kubernetes.io/safe-to-evict: "false"
                    spec:
                      nodeSelector:
                        cbjAgent: true
                      tolerations:
                      - key: "cbjAgent"
                        operator: "Equal"
                        value: "true"
                        effect: "NoSchedule"
                      serviceAccountName: "jenkins"
                      initContainers:
                      - name: wait-for-jenkins-connection
                        image: cicd-docker-prod.artifactory.aws.nbscloud.co.uk/cicd-cloudbees-core-agent:v0.1.1
                        imagePullPolicy: IfNotPresent
                        command: ["/bin/sh", "-c"]
                        args: ["counter=0; while [ \$counter -lt 30 ] && [ \$(curl -sw '%{http_code}' '${env.JENKINS_URL}' -o /dev/null) -eq 000 ]; do sleep 1; echo 'Waiting for jenkins connection ...'; counter=\$((counter+1)); done"]
                      containers:
                      - name: jnlp
                        image: cicd-docker-prod.artifactory.aws.nbscloud.co.uk/cicd-cloudbees-core-agent:v0.1.1
                        imagePullPolicy: IfNotPresent
                        resources:
                          requests:
                            memory: "500Mi"
                            cpu: "100m"
                          limits:
                            memory: "4Gi"
                            cpu: "2"
                      - name: test
                        image: edb-docker-dev-local.artifactory.aws.nbscloud.co.uk/pace-test/chefinspec:1.0.0
                        command:
                        - sleep
                        args:
                        - 99d
                        resources:
                          requests:
                            memory: "6Gi"
                            cpu: "2"
                          limits:
                            memory: "12Gi"
                            cpu: "4"
                        volumeMounts:
                        - mountPath: /tmp
                          name: temp-volume
                      volumes:
                      - name: temp-volume
                        emptyDir: {}
                      - name: ccoe-aws-cert
                        secret:
                          secretName: ccoe-aws-cert
                      - name: jenkins-docker-cfg
                        projected:
                          sources:
                          - secret:
                              name: artifactory-docker
                              items:
                                - key: .dockerconfigjson
                                  path: config.json
                """.stripIndent()
        }
    }

    stages {
        stage('Prepare') {

            steps {
                script {
                    container('test') {
                        withCredentials([
                                string(credentialsId: 'npm_token', variable: 'NPM_TOKEN')
                        ]) {

                            sh """
                                kubectl get pods --namespace banking-lao-dev1
                                inspec 
                              
                                kubectl -n banking-lao-dev1 exec -it eo-web-lao-77569dcd86-5vrrz  -- inspec 

                        """
                        }
                    }
                }
            }

        } //End of Prepare stage

    }

}