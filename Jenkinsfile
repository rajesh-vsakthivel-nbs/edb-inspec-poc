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
                        image: edb-docker-dev-local.artifactory.aws.nbscloud.co.uk/pace-test/edbchefinspec:5.22.3
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


        // parameters {
        //
        //
        //   choice(name:'npmRunCmd', choices:['smokeTest'])
        //   choice(name:'maxInstances', choices:['26','13','1'], description: 'Number of instances to run')
        //   choice(name:'testEnvironment', choices:['dev','sit','pre'],description: 'Choose the targer environment to run tests')
        //   string(name:'testTags', defaultValue: '@smoketest',  description: 'Enter test tag (Eg, @smoketest)')
        //  }


        stages {

          

           stage('Run Tests') {

                 steps {
                     script {
                     container('test') {
                           try {
                           withCredentials([
                           string(credentialsId: 'npm_token', variable: 'NPM_TOKEN'),
                           string(credentialsId: 'cco_notprod_mongo_connection', variable: 'MONGO_CONNECTION_STRING'),
                           usernamePassword(credentialsId: 'cco_browserstack_creds', usernameVariable: 'BROWSERSTACK_USER_NAME', passwordVariable: 'BROWSERSTACK_KEY')
                           ]) {

                             sh '''
                             inspec exec basics.rb

                             '''

                         }
                       } catch (e)
                       {
                        
                       }
                     }
                     }
                 }

            } //End of stage


}

}