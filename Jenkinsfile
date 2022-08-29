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
       environment{
         DOCKER_CREDS = credentials('dockerhub')
       }
       steps{
   
        script{
          sh "echo Server Initialization in progress"        
          sleep(time: 90, unit: "SECONDS")
          sh "echo Docker Deployment Triggered"
          def shellcmd = "bash ./cmds.sh ${BUILD_ID} ${DOCKER_CREDS_USR} ${DOCKER_CREDS_PSW}"
          sshagent(['server_ssh_key']){ 
            sh "scp -o StrictHostKeyChecking=no cmds.sh ec2-user@${EC2_PUBLIC_IP}:/home/ec2-user"
            sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} ${shellcmd}"
          }   
        }

     }

    }
   
  }  

}
