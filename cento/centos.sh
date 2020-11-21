#!/usr/bin/bash
echo hello
sudo yum config-manager --set-enabled PowerTools
sudo yum -y install epel-release
sudo yum update -y
sudo yum repolist
cd /opt
sudo curl https://ftp.otrs.org/pub/otrs/otrs-latest.tar.gz -o otrs.tar.gz
sudo tar -xvf otrs.tar.gz
sudo ln -s /opt/otrs-6.0.30 /opt/otrs
sudo yum  -y install  procmail httpd mod_perl perl perl-core 
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload
sudo yum install -y postgresql-server
sudo postgresql-setup --initdb --unit postgresql
sudo yum install -y "perl(Date::Format)" "perl(DateTime)" "perl(DBI)" "perl(Moo)" "perl(Net::DNS)" "perl(Template)" "perl(Template::Stash::XS)"
sudo yum install -y"perl(XML::LibXML)" "perl(YAML::XS)" "perl(DBD::Pg)" "perl(DBD::mysql)"
#enc_pass=$(perl -e 'print crypt("otrs", "salt"),"\n"')
#sudo useradd -p $enc_pass otrs
sudo useradd otrs
sudo chown -R otrs:otrs /opt/otrs-6.0.30
sudo usermod -G apache otrs
sudo cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm
sudo ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/httpd/conf.d/otrs.conf
apachectl -M | grep -E 'version|deflate|filter|headers'
sudo /opt/otrs/bin/otrs.SetPermissions.pl 
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl start httpd
sudo systemctl enable httpd
 sudo /opt/otrs/bin/otrs.SetPermissions.pl --otrs-user=otrs --web-user=apache --otrs-group=apache --web-group=apache /opt/otrs
