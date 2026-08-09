pipeline{
    agent{
        node{
            label 'AGENT-2'
        }
    }
    environment{
        COURSE = "jenkins"
        appVersion = "1.1.0"
        ACC_ID = "802346121661"
        PROJECT = "roboshop"
        COMPONENT = "catalogue"
    }
    options {
        timeout(time: 10, unit: 'MINUTES') 
        disableConcurrentBuilds()
    }

    stages {
        stage('Read Version') {
            steps {
                script{
                    def packageJSON = readJSON file: 'package.json'
                    appVersion  = packageJSON.version
                    echo " appVersion : ${appVersion}"
                }

            }
        }
        stage('Install Dependencies') {
            steps{
                script {
                    sh """
                        npm install
                    """
                }
            }
        }
        stage('Unit Test') {
            steps{
                script{
                    sh """
                        npm test
                    """
                }

            }
        }
        stage('sonar scan'){
            environment {
                def scannerHome = tool 'sonar-8.0'
            }
            steps {
                script{
                    withSonarQubeEnv('sonar-server') {
                        sh  "${scannerHome}/bin/sonar-scanner"
            
                    }
                }
            }
        }

            
        
        stage('Build Image') {
            steps{
                script {
                    withAWS(region:'us-east-1',credentials:'aws-cred') {
                        sh """
                            aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com
                            docker build -t ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .
                            docker images
                            docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                        """
                  }
                }
             }
        
        }
    }
}

