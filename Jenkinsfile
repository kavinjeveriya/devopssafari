def AgentLabel
if (BRANCH_NAME == "dev") {
    AgentLabel = "dev"
} else if (BRANCH_NAME == "stage") {
    AgentLabel = "stage"
} 


def Imagetag
if (BRANCH_NAME == "dev") {
    Imagetag = "devlope"
} else if (BRANCH_NAME == "stage") {
    Imagetag = "stage"
} 

pipeline {
    agent { label AgentLabel }
    environment {
        IMAGE_TAG = "${Imagetag}"
        GIT_COMMIT_HASH = sh(
                script: "printf \$(git rev-parse --short ${GIT_COMMIT})",
                returnStdout: true)
    }
    stages {
        stage('Image Building') {
            steps {
                // Image Build 
                sh '''#!/bin/bash
                sudo docker build . -f Dockerfile -t devopssafari/${IMAGE_TAG}_app:${GIT_COMMIT_HASH} 
                '''
            }
            post {
                failure {
                slackSend channel: 'testing', message: "*****Docker image building is unsuccessful*****"
                }
            }
        }
        stage('Image Push') {
            steps {
                // Image pushing to docker hub
                sh('''#!/bin/bash
                echo latest version of image is ${GIT_COMMIT_HASH} 
                ''')
            }
            post {
                failure {
                slackSend channel: 'testing', message: "*****Docker image push to docker repo is unsuccessful*****"
                }
            }
        }
        stage('Deploy pods') {
            steps {
                sh('''#!/bin/bash
                echo "Deploying the pods with ${BRANCH_NAME}"
                if sudo docker ps -a | grep ${IMAGE_TAG}_app
                then
                sudo docker rm -f ${IMAGE_TAG}_app
                fi
                sudo docker run -dit -p 5000:5000 --name ${IMAGE_TAG}_app devopssafari/${IMAGE_TAG}_app:${GIT_COMMIT_HASH}
		''')
            }
            post {
                failure {
                slackSend channel: 'testing', message: "*****Pods are not deploy*****"
                }
            }
        }
        stage('Remove image') {
            steps {
                sh('''#!/bin/bash
                echo "Deploying the pods with ${BRANCH_NAME}"
                ''')
            }
            post {
                failure {
                slackSend channel: 'testing', message: "*****Removing Docker image is unsuccessful*****"
                }
            }
        }
    }
    post {
        always {
            notifySlack(currentBuild.currentResult)
        }
    }
}

def notifySlack(String buildStatus = 'STARTED') {
    def color
    if (buildStatus == 'STARTED') {
        color = '#D4DADF'
    } else if (buildStatus == 'SUCCESS' ) {
        color = 'good'
    } else if (buildStatus == 'UNSTABLE') {
        color = 'warning'
    } else {
        color = 'danger'
    }
    def msg = "`${env.JOB_NAME}` build number #${env.BUILD_NUMBER}:`${buildStatus}`\n${env.BUILD_URL}   "
    slackSend(channel: '#testing', color: color, message: msg)
}