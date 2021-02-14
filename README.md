<!-- ABOUT THE PROJECT -->
## About The Project
This project is to install MediaWiki by Helm
### Built With
* [Docker]
* [Kubernetes]
* [Helm]

### Prerequisites

* AWS EKS Cluster
* EBS driver installed
* kubectl and Helm installed
* Valid kubeconfig file

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/kumarnarendra701/weekend-test.git
   ```
3. Docker build and Push
   ```sh
   sudo docker login
   sudo docker build -t hometest-wiki:latest .
   sudo docker tag hometest-wiki:latest yourdockerrepo/hometest-wiki:latest
   sudo docker push yourdockerrepo/hometest-wiki:latest
   ```
4. Change MediaWiki url,dbuser,dbpassword,dbname in LocalSettings.php file
   ```sh
   $wgServer = "http://ymediwiki.yourserver.com";
   $wgSitename = "Take Home Test from ThoughtWorks";
   $wgDBserver = "mysql-service-name";
   $wgDBname = "wikidatabase";
   $wgDBuser = "root";
   $wgDBpassword = "yourpass";
   ```
   Note - Put same DB password and service name into Mysql chart value file, so that DB node will be initialized by same credenatils.
   
5. Execute Helm for app and db
   ```sh
   cd weekend-test/
   helm install app app/
   helm install mysql mysql/
   ```
6. Import initial DB to mysql node
   ```sh
   kubectl  exec -i wikidb-XXXXX-xfnhr -- mysql -u root -pyourpass -e 'create database wikidatabase'
   kubectl  exec -i wikidb-xxxxx-rgpgm -- mysql -u root -pyourpass wikidatabase < my_wiki.sql
   ```
7. Create CNAME records with LB
   ymediwiki.yourserver.com CNAME yourawslb-785522508.us-east-X.elb.amazonaws.com

<!-- USAGE EXAMPLES -->
## Usage

Use this space to show useful examples of how a project can be used. Additional screenshots, code examples and demos work well in this space. You may also link to more resources.
