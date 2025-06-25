#!/bin/bash
set -e

KEY_NAME="firstkey"
SECURITY_GROUP_NAME="jenkins-sg"
INSTANCE_TAG="JenkinsServer"
AWS_REGION="us-east-1"

echo "🚨 Jenkins altyapısını kaldırma işlemi başlatıldı..."

# 1. EC2 Instance ID'yi etiketle bul
INSTANCE_ID=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=$INSTANCE_TAG" "Name=instance-state-name,Values=running,stopped" \
  --query 'Reservations[].Instances[].InstanceId' --output text)

if [ -z "$INSTANCE_ID" ]; then
  echo "⚠️ EC2 instance bulunamadı. Belki zaten silinmiş olabilir."
else
  echo "🗑 EC2 instance siliniyor: $INSTANCE_ID"
  aws ec2 terminate-instances --instance-ids "$INSTANCE_ID"
  echo "⏳ EC2 instance sonlandırılıyor..."
  aws ec2 wait instance-terminated --instance-ids "$INSTANCE_ID"
  echo "✅ EC2 instance tamamen silindi."
fi

# 2. Security Group sil
SG_ID=$(aws ec2 describe-security-groups \
  --group-names "$SECURITY_GROUP_NAME" \
  --query 'SecurityGroups[0].GroupId' --output text 2>/dev/null || true)

if [ -n "$SG_ID" ]; then
  echo "🗑 Güvenlik grubu siliniyor: $SECURITY_GROUP_NAME ($SG_ID)"
  aws ec2 delete-security-group --group-id "$SG_ID"
  echo "✅ Güvenlik grubu silindi."
else
  echo "⚠️ Security group '$SECURITY_GROUP_NAME' bulunamadı ya da zaten silinmiş."
fi

# 3. PEM dosyası yerelse silinebilir ama AWS'deki key pair silinmeyecek çünkü elle yükledin

echo "🎉 Tüm kaynaklar başarıyla temizlendi."
