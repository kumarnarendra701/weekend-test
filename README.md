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
   $wgServer = "http://mediwiki.yourserver.com";
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
   
   mediwiki.yourserver.com CNAME yourawslb-785522508.us-east-X.elb.amazonaws.com
   
   Your mediwiki sites is avilable on http://mediwiki.yourserver.com

<!-- USAGE EXAMPLES -->
## Output of Helm and Service

   ```sh
   $ helm install mysql mysql/
   NAME: mysql
   LAST DEPLOYED: Sun Feb 14 23:14:56 2021
   NAMESPACE: default
   STATUS: deployed
   REVISION: 1
   TEST SUITE: None
   ```
   
   ```sh
   $ helm install app app/	
   NAME: app
   LAST DEPLOYED: Sun Feb 14 23:14:33 2021
   NAMESPACE: default
   STATUS: deployed
   REVISION: 1
   TEST SUITE: None
   ```
   
   ```sh
   $ helm list
   NAME 	NAMESPACE	REVISION	UPDATED                                	STATUS  	CHART      	APP VERSION
   app  	default  	1       	2021-02-14 23:14:33.196064411 +0530 IST	deployed	app-1.0.0  	1.16.0     
   mysql	default  	1       	2021-02-14 23:14:56.87092987 +0530 IST 	deployed	mysql-1.0.0	          
   ```
   
   ```sh
   $ kubectl get svc
   NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)        AGE
   kubernetes           ClusterIP      10.100.0.1      <none>                                                                   443/TCP        19h
   wikiapp-svc          LoadBalancer   10.100.190.48   XXXXXXXXX-965296802.us-east-X.elb.amazonaws.com   80:32298/TCP   4m52s
   wikidb-svc           ClusterIP      10.100.26.164   <none>                                                                   3306/TCP       4m21s
   ```
