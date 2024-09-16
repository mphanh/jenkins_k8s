node {
  stage('git checkout'){
    git branch: 'main', url: 'https://github.com/mphanh/jenkins_k8s.git'
  }
  stage('sending dockerfile to ansible server over ssh'){
    sshagent(['ansible']) {
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip>'
      sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/jenkins-k8s/* ubuntu@<ip>:/home/ubuntu'
    }
  }
  stage('docker image build'){
    sshagent(['ansible']) {
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> cd /home/ubuntu/ '
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> docker build -t $JOB_NAME:v1.@BUILD_ID .'
  }
  stage('docker image tag'){
    sshagent(['ansible']) {
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> cd /home/ubuntu/ '
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> docker tag $JOB_NAME:v1.@BUILD_ID mpa1998/$JOB_NAME:v1.$BUILD_ID'
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> docker tag $JOB_NAME:v1.@BUILD_ID mpa1998/$JOB_NAME:latest'
  }
  stage('push docker image'){
    sshagent(['ansible']) {
      withCredentials([string(credentialsId: 'dockerhub', variable: 'docker_pwd')]) {
        sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> docker login -u mpa1998 -p ${docker_pwd}'
        sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> docker push mpa1998/$JOB_NAME:v1.$BUILD_ID'
        sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ip> docker push mpa1998/$JOB_NAME:latest'
      }
    }
  }
}