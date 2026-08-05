pipeline{
    agent{
        node{
            label 'AGENT-1'
        }
    }
    environment{
        COURSE = "jenkins"
        appVersion = ""
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
            script{
                sh """
                    npm install
                """
            }
        }
        stage('Build Image') {
            script {
                sh """
                    docker build -t catalogue:${appVersion} .
                    docker images
                """
            }

        }
    }

}
