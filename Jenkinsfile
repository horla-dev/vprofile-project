def COLOR_MAP = [
    'SUCCESS': 'good', 
    'FAILURE': 'danger',
]


pipeline {
    agent "any"
    tools {
        maven "maven"
        jdk "jdk17"
    }

    environment {
        awsCreds = "ecr:eu-north-1:awstoken"
        imageName = "864899862790.dkr.ecr.eu-north-1.amazonaws.com/vprofile"
        awsRegistry = "https://864899862790.dkr.ecr.eu-north-1.amazonaws.com"
        cluster = "vpro-cluster"
        service = "vprofile-servi"
    }

    stages{

        stage("Fetch code") {
            steps{
                git branch: 'docker', url: 'https://github.com/hkhcoder/vprofile-project.git'
            }
        }

        stage("Build Artifacts") {
            steps{
                sh 'mvn install -Dskiptest'

            }
            post {
                success{
                    echo 'Archiving Artifacts'
                    archiveArtifacts artifacts: '**/*.war'
                }
            }
        }

        stage("Unit Test") {
            steps{
                sh 'mvn test'
            }
        }

        stage("checkstyle Analysis") {
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }

        stage("Sonar Analysis") {
            environment {
                scannerHome = tool 'sonar'
            }

            steps{
                withSonarQubeEnv('sonarserver') {
                    sh '''
                         ${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vprofile \
                        -Dsonar.projectName=vprofile \
                        -Dsonar.projectVersion=1.0 \
                        -Dsonar.sources=src/ \
                        -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                        -Dsonar.junit.reportsPath=target/surefire-reports/ \
                        -Dsonar.jacoco.reportsPath=target/jacoco.exec \
                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml
                    '''
                }

            }
        }

        stage("Quality Gate") {
            steps{
                timeout( time: 1, unit: "HOURS") {
                    waitForQualityGate abortPipeline: true

                }

            }
        }

        stage('Build docker Image'){
            steps{
                script{
                    dockerImage = docker.build( imageName + ":$BUILD_NUMBER", "./Docker-files/app/multistage") 
                }
            }
        }

        stage("Push to ECR") {
            steps{
                script{

                    docker.withRegistry(awsRegistry, awsCreds ){
                        dockerImage.push("latest")
                        dockerImage.push("$BUILD_NUMBER")
                    }
                }
            }
        }

        stage(" Clean up") {
            steps{
                sh 'docker rmi -f $(docker images -a -q)'
            }
        }

        stage("Deploy to ECS") {
            steps{
                withAWS(credentials: 'awstoken', region: 'eu-north-1'){
            
                sh 'aws ecs update-service --service $service --cluster $cluster --force-new-deployment'

                }
            }
        }
    }

    post {
        always{
            echo 'Sending Notification'
            slackSend channel: '#devops-cicd',
            color: COLOR_MAP[currentBuild.currentResult],
            message: "*${currentBuild.currentResult}:* Job ${env.JOB_NAME} build ${env.BUILD_NUMBER} \n More info at: ${env.BUILD_URL}"

        }
    }
        
}
