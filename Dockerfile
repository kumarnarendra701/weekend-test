FROM centos:7

# Install Apache
RUN yum -y update
RUN yum -y install httpd httpd-tools wget

# Install EPEL Repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Install PHP
RUN yum --enablerepo=remi-php73 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring \
    php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip

# Update Apache Configuration
RUN sed -E -i -e 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/mediawiki"|' /etc/httpd/conf/httpd.conf
RUN sed -E -i -e '/<Directory "\/var\/www">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex index.php \1/g' /etc/httpd/conf/httpd.conf
RUN wget https://releases.wikimedia.org/mediawiki/1.35/mediawiki-1.35.1.tar.gz -O /tmp/mediawiki-1.35.1.tar.gz
RUN tar -zxvf /tmp/mediawiki-1.35.1.tar.gz -C /var/www/
RUN mv /var/www/mediawiki-1.35.1 /var/www/mediawiki
COPY LocalSettings.php /var/www/mediawiki/

EXPOSE 80

# Start Apache
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
