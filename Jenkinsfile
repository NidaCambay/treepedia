pipeline {
  agent any

  environment {
    IMAGE_NAME = 'nidacambay/treepedia-site'
    INSTANCE_TYPE = 't2.micro'
    AMI_ID = 'ami-0d59d17fb3b322d0b'  // Ubuntu 24.04 LTS (us-east-1)
    KEY_NAME = 'firstkey'
    SECURITY_GROUP = 'treepedia-sg'
    REGION = 'us-east-1'
  }

  stages {
    stage('EC2 Başlat ve Yayına Al') {
      steps {
        withCredentials([[ 
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-creds' // Jenkins'e eklediğin AWS credential ID
        ]]) {
          sh """
            echo "[🔐] AWS Credentials yüklendi."

            SECURITY_GROUP="${SECURITY_GROUP}"
            REGION="${REGION}"
            KEY_NAME="${KEY_NAME}"
            AMI_ID="${AMI_ID}"
            INSTANCE_TYPE="${INSTANCE_TYPE}"
            IMAGE_NAME="${IMAGE_NAME}"

            echo "[🔍] Güvenlik grubu kontrol ediliyor..."
            aws ec2 describe-security-groups --group-names "\$SECURITY_GROUP" --region \$REGION &>/dev/null || \
            aws ec2 create-security-group --group-name "\$SECURITY_GROUP" --description "Treepedia SG" --region \$REGION

            aws ec2 authorize-security-group-ingress --group-name "\$SECURITY_GROUP" --protocol tcp --port 22 --cidr 0.0.0.0/0 --region \$REGION || true
            aws ec2 authorize-security-group-ingress --group-name "\$SECURITY_GROUP" --protocol tcp --port 80 --cidr 0.0.0.0/0 --region \$REGION || true

            echo "[🚀] EC2 başlatılıyor..."
            INSTANCE_ID=\$(aws ec2 run-instances \
              --image-id \$AMI_ID \
              --count 1 \
              --instance-type \$INSTANCE_TYPE \
              --key-name \$KEY_NAME \
              --security-groups "\$SECURITY_GROUP" \
              --region \$REGION \
              --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=TreepediaApp}]' \
              --user-data file://userdata.sh \
              --query 'Instances[0].InstanceId' \
              --output text)

            echo "🔎 Instance ID: \$INSTANCE_ID"

            echo "⏳ Instance running bekleniyor..."
            aws ec2 wait instance-running --instance-ids \$INSTANCE_ID --region \$REGION

            PUBLIC_IP=\$(aws ec2 describe-instances \
              --instance-ids \$INSTANCE_ID \
              --region \$REGION \
              --query 'Reservations[0].Instances[0].PublicIpAddress' \
              --output text)

            echo "✅ Treepedia yayında! 👉 http://\$PUBLIC_IP"
          """
        }
      }
    }
  }
}
