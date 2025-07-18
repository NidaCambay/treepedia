# 🌳 Treepedia – DevOps Bitirme Projesi

Treepedia, doğanın güzelliğini ön plana çıkaran statik bir web sayfasının Docker konteyneri içerisinde hazırlanıp Jenkins üzerinden otomatik olarak build ve deploy edilmesini amaçlayan bir DevOps projesidir.

---

## 🎯 Proje Amacı

Bu proje, Tech Istanbul DevOps Atölyesi bitirme ödevi kapsamında geliştirilmiştir.  
Amaç, statik içerikli bir web sayfasını modern DevOps yaklaşımlarıyla (CI/CD pipeline, Docker, Jenkins, AWS) otomatik şekilde yayına almaktır.

---

## 🛠️ Kullanılan Teknolojiler

| Teknoloji        | Açıklama      |
|------------------|---------------|
| **Docker**       | Uygulamanın konteynerleştirilmesi için kullanıldı |
| **Jenkins**      | Otomatik build, test ve deploy işlemleri |
| **AWS EC2**      | Web sunucusunun barındırıldığı bulut ortamı |
| **Nginx**        | Statik dosyaların sunulmasında kullanıldı |
| **Git & GitHub** | Kod sürüm kontrol sistemi |
| **Docker Hub**   | Build edilen imajların yüklendiği depo |

---

## 🔗 Proje Bağlantıları

- 📦 Docker Hub: [`nidacambay/treepedia-site`](https://hub.docker.com/r/nidacambay/treepedia-site)
- 💻 GitHub Repo: [`NidaCambay/treepedia`](https://github.com/NidaCambay/treepedia.git)

---

## 🚀 Kurulum ve Çalıştırma

### 1. Reponun Klonlanması

```bash
git clone https://github.com/NidaCambay/treepedia.git
cd treepedia

```
### 2. Docker Image Build

```bash
docker build -t nidacambay/treepedia-site .

```

### 3. Docker Container Çalıştırma

```bash
docker run -d -p 8080:80 nidacambay/treepedia-site

```

🚀 Tarayıcıdan http://localhost:8080 adresine giderek siteyi görebilirsiniz.

2️ Jenkins Sunucusu

```bash
cd infra
bash jenkins-install.sh

```
Arayüz: http://Jenkins-IP:8080 Giriş şifresi almak için:

```bash
ssh -i jenkins-key.pem ubuntu@<Jenkins-IP>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

```
🔌 Jenkins Plugin ve Credential Ayarları
🧪 Kullanılan Jenkins Plugin’leri

- AWS Credentials
- Docker Pipeline
- Pipeline Stage View
- Blue Ocean (opsiyonel)
- Rebuilder


Plugin’leri
Manage Jenkins > Manage Plugins > Available sekmesinden yükleyebilirsiniz.



🔑 Jenkins Credentials (Global → Add Credentials)


| 🔑 **Secret Adı** | 🔐 **Tür**        | 🔍 **Açıklama**              |
| ----------------- | ----------------- | ---------------------------- |
| **aws-creds**     | AWS Credentials   | AWS erişim bilgileri         |
| **docker-creds**  | Username/Password | Docker Hub giriş bilgileri   |
| **github-auth**   | Username/Password | GitHub Personal Access Token |

---

Credantials ekleme

Dashboard > Manage Jenkins > Credentials > System > Global credentials bölümünden Add credentials butonuna tıklayarak Jenkinsfile'da tanımlanan credential'ları ekleyebilirsiniz


🔄 CI/CD Süreci
- Jenkins pipeline ile projenin uçtan uca otomasyonu sağlanmıştır:

- GitHub’a yapılan her push işlemiyle Jenkins pipeline tetiklenir.

- Docker image build edilir.

- Image Docker Hub’a push edilir.

- AWS EC2 üzerindeki sunucuda image çekilerek yayın yapılır.



🧾 Sonuç
Bu proje kapsamında, statik bir web uygulamasının otomatik olarak Docker imajına dönüştürülmesi, Docker Hub’a gönderilmesi ve Jenkins aracılığıyla AWS EC2 üzerinde yayınlanması sağlanmıştır. Tüm bu süreç; GitHub'a yapılan bir push işlemi sonucunda Weebhook ile tetiklenen CI/CD pipeline sayesinde tam otomatik şekilde gerçekleştirilmiştir.

Jenkins pipeline şunları başarıyla gerçekleştirmektedir:

🔧 Docker imajını build eder

📦 Docker Hub’a push eder

🧹 Eski EC2 makinelerini otomatik olarak temizler

🚀 Yeni bir EC2 makinesi başlatır ve yayını gerçekleştirir

Bu yapı sayesinde hem dinamik, temiz ve sürdürülebilir bir DevOps süreci elde edilmiş hem de kaynak yönetimi açısından verimli bir dağıtım altyapısı kurulmuştur.



