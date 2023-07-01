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
                  containers:
                  - name: jnlp
                    image: ccoe-docker.artifactory.aws.nbscloud.co.uk/cloudbees-core-agent:1.18.0
                    resources:
                      requests:
                        memory: "500Mi"
                        cpu: "100m"
                      limits:
                        memory: "4Gi"
                        cpu: "2"
                  - name: test
                    image: edb-docker-dev-local.artifactory.aws.nbscloud.co.uk/pace-test/edbchefinspec:5.22.3
                    command:
                    - sleep
                    args:
                    - 99d
                    resources:
                      requests:
                        memory: "4Gi"
                        cpu: "2"
                      limits:
                        memory: "12Gi"
                        cpu: "8"
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
       
 stage('Run Tests') {

            steps {
                script {
                    container('test') {
                        withCredentials([
                                string(credentialsId: 'npm_token', variable: 'NPM_TOKEN')
                        ]) {

                            sh  """
                          
                                 echo "inspec Rajesh ... "
                                 inspec --chef-license=accept-silent
                                 inspec exec examples/profile/controls/kubernetespods.rb -t k8s://
                            
                             

                                """
                        }
                    }
                }
            }

        } //End of Lint Check stage
        
    }
}
