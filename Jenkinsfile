pipeline {
    agent any
    tools {
        "org.jenkinsci.plugins.terraform.TerraformInstallation" "terraform-0.12.5"
    }
    // parameters {
    //     string(name: 'LAMBDA_URL', defaultValue: '', description: 'URL to the Lamdba function')
    //     string(name: 'WORKSPACE', defaultValue: 'development', description:'worspace to use in Terraform')
    // }
    environment {
        TF_HOME = tool('terraform-0.12.5')
        TF_IN_AUTOMATION = "true"
        PATH = "$TF_HOME:$PATH"
        DYNAMODB_STATELOCK = "terraform-itrams-state-lock"
        PROJECT_S3_BUCKET = "terraform-itrams-remote-state"
        USER_ACCESS_KEY = credentials('user_access_key')
        USER_SECRET_KEY = credentials('user_secret_key')
    }
    stages {
        stage('NetworkInit'){
            steps {
                dir('module/'){
                    sh 'terraform --version'
                    sh "terraform init -input=false \
                     --backend-config='dynamodb_table=$DYNAMODB_STATELOCK' --backend-config='bucket=$NETWORKING_BUCKET' \
                     --backend-config='access_key=$USER_ACCESS_KEY' --backend-config='secret_key=$USER_SECRET_KEY'"
                    sh "echo \$PWD"
                    sh "whoami"
                }
            }
        }
        stage('NetworkPlan'){
            steps {
                dir('module/'){
                    script {
                        sh "terraform plan -var 'aws_access_key=$USER_ACCESS_KEY' -var 'aws_secret_key=$USER_SECRET_KEY' \
                        -out terraform-networking.tfplan;echo \$? > status"
                        stash name: "terraform-networking-plan", includes: "terraform-networking.tfplan"
                    }
                }
            }
        }
        stage('NetworkApply'){
            steps {
                script{
                    def apply = false
                    try {
                        input message: 'confirm apply', ok: 'Apply Config'
                        apply = true
                    } catch (err) {
                        apply = false
                        sh "terraform destroy -var 'aws_access_key=$USER_ACCESS_KEY' -var 'aws_secret_key=$USER_SECRET_KEY' -force"
                        currentBuild.result = 'UNSTABLE'
                    }
                    if(apply){
                        dir('module/'){
                            unstash "terraform-networking-plan"
                            sh 'terraform apply terraform-networking.tfplan'
                        }
                    }
                }
            }
        }
}
}