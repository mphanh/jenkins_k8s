node {
  stage('git checkout'){
    git branch: 'main', url: 'https://github.com/mphanh/jenkins_k8s.git'
  }
  stage('sending dockerfile to ansible server over ssh'){
    sshagent(['ansible']) {
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip>'
      sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/<pipeline-name>/* ubuntu@<ansible-ip>:/home/ubuntu'
    }
  }
  stage('docker image build'){
    sshagent(['ansible']) {
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> cd /home/ubuntu/ '
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> docker build -t $JOB_NAME:v1.$BUILD_ID .'
    }
  }
  stage('docker image tag'){
    sshagent(['ansible']) {
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> cd /home/ubuntu/ '
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> docker tag $JOB_NAME:v1.$BUILD_ID mpa1998/$JOB_NAME:v1.$BUILD_ID'
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> docker tag $JOB_NAME:v1.$BUILD_ID mpa1998/$JOB_NAME:latest'
    }
  }
  stage('push docker image'){
    sshagent(['ansible']) {
      withCredentials([string(credentialsId: 'dockerhub', variable: 'docker_pwd')]) {
        sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> docker login -u mpa1998 -p ${docker_pwd}'
        sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> docker push mpa1998/$JOB_NAME:v1.$BUILD_ID'
        sh 'ssh -o StrictHostKeyChecking=no ubuntu@<ansible-ip> docker push mpa1998/$JOB_NAME:latest'
      }
    }
  }
  stage('copy files from jenkins to k8s'){
    sshagent(['k8s']){
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<k8s-ip>'
      sh 'scp -o StrictHostKeyChecking=no /var/lib/jenkins/workspace/<pipeline-name>/* ubuntu@<k8s-ip>:/home/ubuntu'
    }
  }
  stage('k8s deployment'){
    sshagent(['k8s']){
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<k8s-ip> cd /home/ubuntu/ '
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<k8s-ip> kubectl apply -f deployment.yaml'
      sh 'ssh -o StrictHostKeyChecking=no ubuntu@<k8s-ip> kubectl apply -f service.yaml'
    }
  }
}