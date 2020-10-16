pipeline {
	agent {
    node {
      label 'master'
      customWorkspace '/test/lab/'
    }
    }
    stages {
        stage('Git Checkout') {
            steps {
                checkout scm
            }
        }
    stage('Docker Build') {
      agent any
      steps {
        sh 'docker build -t nginx/${BUILD_NUMBER} .'
      }
    }
    stage('Docker Push') {
      agent any
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
          sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
          sh 'docker push nginx/${BUILD_NUMBER}'
        }
      }
    }
	stage('Deploy Image') {
      		agent any
      	steps {
        	script {
        	    ssh  -i ubuntu@${IP-Address} << EOF
    			docker pull nginx/${BUILD_NUMBER}
			docker stop my-nginx-container
			docker rm my-nginx-container
			docker run -d -p 80:80 nginx/${BUILD_NUMBER} --name my-nginx-container
    			EOF"""
}
      }
    }
  }
}