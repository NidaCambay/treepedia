pipeline {
  agent any

  environment {
    IMAGE_NAME = 'nidacambay/treepedia-site'
    INSTANCE_TYPE = 't2.micro'
    AMI_ID = 'ami-0d59d17fb3b322d0b'
    KEY_NAME = 'firstkey'
    SECURITY_GROUP_NAME = 'treepedia-sg'
    REGION = 'us-east-1'
  }

  stages {
    stage('EC2 Başlat ve Yayına Al') {
      steps {
        withCredentials([[ 
          $class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-creds'
        ]]) {
          sh """
            echo "[🔐] AWS Credentials yüklendi."

            echo "[🌐] Default VPC alınıyor..."
            DEFAULT_VPC_ID=\$(aws ec2 describe-vpcs --region $REGION \
              --filters Name=isDefault,Values=true \
              --query 'Vpcs[0].VpcId' --output text)

            echo "🌐 Default VPC ID: \$DEFAULT_VPC_ID"

            echo "[🔍] Güvenlik grubu kontrol ediliyor..."
            SG_ID=\$(aws ec2 describe-security-groups --region $REGION \
              --filters Name=group-name,Values=$SECURITY_GROUP_NAME Name=vpc-id,Values=\$DEFAULT_VPC_ID \
              --query 'SecurityGroups[0].GroupId' \
              --output text 2>/dev/null)

            echo "📦 Güvenlik Grubu ID: \$SG_ID"

            if [ -z "\$SG_ID" ] || [ "\$SG_ID" = "None" ]; then
              echo "[🛠️] Güvenlik grubu oluşturuluyor..."
              SG_ID=\$(aws ec2 create-security-group \
                --group-name $SECURITY_GROUP_NAME \
                --description "Allow HTTP and SSH" \
                --vpc-id \$DEFAULT_VPC_ID \
                --region $REGION \
                --query 'GroupId' --output text)

              echo "[🔐] Erişim kuralları ekleniyor..."
              aws ec2 authorize-security-group-ingress --group-id \$SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0 --region $REGION
              aws ec2 authorize-security-group-ingress --group-id \$SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0 --region $REGION
            else
              echo "[✅] Var olan güvenlik grubu kullanılacak: \$SG_ID"
            fi

            echo "[🚀] EC2 başlatılıyor..."
            INSTANCE_ID=\$(aws ec2 run-instances \
              --image-id $AMI_ID \
              --count 1 \
              --instance-type $INSTANCE_TYPE \
              --key-name $KEY_NAME \
              --security-group-ids \$SG_ID \
              --region $REGION \
              --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=TreepediaApp}]' \
              --user-data file://userdata.sh \
              --query 'Instances[0].InstanceId' \
              --output text)

            echo "🆔 EC2 Instance ID: \$INSTANCE_ID"

            echo "⏳ Bekleniyor, EC2 çalışmaya geçsin..."
            aws ec2 wait instance-running --instance-ids \$INSTANCE_ID --region $REGION

            PUBLIC_IP=\$(aws ec2 describe-instances \
              --instance-ids \$INSTANCE_ID \
              --region $REGION \
              --query 'Reservations[0].Instances[0].PublicIpAddress' \
              --output text)

            echo "🌍 Yayın başladı! Treepedia: http://\$PUBLIC_IP"
          """
        }
      }
    }
  }
}
