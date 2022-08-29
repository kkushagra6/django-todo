pipeline{

  agent any

  stages{
 
    stage("build"){
      steps{
        script{
          sh "docker build -t kkushagra6/docker_todo:v$BUILD_ID ."         

        } 
      }
    }
 
    stage("authenticate"){
      steps{
        script{

          withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
           
            sh "echo $PASS | docker login -u $USER --password-stdin"
            sh 'docker push kkushagra6/docker_todo:v$BUILD_ID'
          }
        }
      }
    }
    
    stage("Provision"){
        environment{
          AWS_ACCESS_KEY_ID = credentials('access_id')
          AWS_SECRET_ACCESS_KEY = credentials('secret_id')
        }
    steps{
  
        script{
          sh "terraform init"
          sh "terraform apply --auto-approve"
          EC2_PUBLIC_IP = sh(script: "terraform output ec2_public_ip", returnStdout: true).trim()
             }
          } 
    }


    stage("Deploy"){
      steps{
        script{
          sh "echo Server Deployment in progress"        
           }

     }

    }
   
  }  

}
