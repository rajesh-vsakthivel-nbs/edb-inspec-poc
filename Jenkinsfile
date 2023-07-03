



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


        // parameters {
        //
        //
        //   choice(name:'npmRunCmd', choices:['smokeTest'])
        //   choice(name:'maxInstances', choices:['26','13','1'], description: 'Number of instances to run')
        //   choice(name:'testEnvironment', choices:['dev','sit','pre'],description: 'Choose the targer environment to run tests')
        //   string(name:'testTags', defaultValue: '@smoketest',  description: 'Enter test tag (Eg, @smoketest)')
        //  }


        stages {

          stage('Prepare') {

                steps {
                    script {
                    container('test') {
                      withCredentials([
                      string(credentialsId: 'npm_token', variable: 'NPM_TOKEN')
                      ]) {

                        sh """
                        cp .npmrc-CI .npmrc


                        mkdir -p /BDD/wrk
                        mkdir -p reports/BDD
                        mkdir -p test/reports/json-results
                        ls -lart

                         echo "Starting the NPM test ... "
                         npm install

                        """
                    }
                    }
                    }
                }

           } //End of stage


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
                             export NODE_OPTIONS=--max-old-space-size=8192
                             npm run ${npmRunCmd} -- --serverUrls.environment=${testEnvironment}
                             cp -r test/reports/json-results ${WORKSPACE}
                             cp -a test/reports/json-results/. ${WORKSPACE}/reports/BDD

                             '''

                         }
                       }
                       finally {
                         //cucumber fileIncludePattern: 'reports/*.json'
                         archiveArtifacts  'test/reports/**'
                         publishHTML (target : [allowMissing: false,
                                       alwaysLinkToLastBuild: true,
                                       keepAll: true,
                                       reportDir: 'test/reports',
                                       reportFiles: 'index.html',
                                       reportName: 'Test Reports',
                                       reportTitles: 'Test Report'])
                       }
                     }
                     }
                 }

            } //End of stage


}

}