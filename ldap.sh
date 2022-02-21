vim basedn.ldif

dn: olcDatabase={2}mdb,cn=config           #<==就是這個 dn 的設計！
changetype: modify                         #<==動作是修改！
replace: olcSuffix                         #<==取代這個項目
olcSuffix: base                       #<==實際的值！

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: root

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}vcz+SUHQTLPojCen2UJXLPDNMHKVJttt

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to *
   by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read
   by dn.base="cn=alvin,dc=alvin,dc=com" read
   by * none

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=example,dc=com

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=admin,dc=example,dc=com

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}30rluAuA7EtLs5TBEANFRWPWK1fGD+TI

dn: olcDatabase={2}mdb,cn=config
changetype: modify
add: olcAccess
olcAccess: {0}to attrs=userPassword,shadowLastChange
   by dn="cn=alvin,dc=alvin,dc=com" write
   by anonymous auth
   by self write
   by * none
olcAccess: {1}to dn.base="" by * read
olcAccess: {2}to *
   by dn="cn=alvin,dc=alvin,dc=com" write
   by * read





dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=alvin,dc=com

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=admin,dc=alvin,dc=com

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}30rluAuA7EtLs5TBEANFRWPWK1fGD+TI



dn: dc=alvin,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: alvin com
dc: alvin

dn: cn=Manager,dc=alvin,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=alvin,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=alvin,dc=com
objectClass: organizationalUnit
ou: Group


ldapsearch -x -H ldap://127.0.0.1 -b "dc=alvin,dc=com"


ldapsearch -x -H ldap://127.0.0.1 -b "dc=alvin,dc=com" uid=alvin -ZZ



####################################################################
To configure Symas OpenLDAP for Linux on RHEL8:

All commands to be run as the root user

systemctl stop slapd
yum erase openldap-clients openldap-servers
wget -q https://repo.symas.com/configs/SOFL/rhel8/sofl.repo -O /etc/yum.repos.d/sofl.repo
yum update
yum install symas-openldap-clients symas-openldap-servers
systemctl start slapd
systemctl enable slapd
systemctl status slapd

mkdir ldap.

cd ldap

slappasswd

root

{SSHA}rbCFl6QWV9PoAp8Nu315h9CGQUr+LP8V

vim basedn.ldif
dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=alvin,dc=com

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=Manager,dc=alvin,dc=com

dn: olcDatabase={2}mdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: {SSHA}rbCFl6QWV9PoAp8Nu315h9CGQUr+LP8V

ldapmodify -Y EXTERNAL  -H ldapi:/// -f basedn.ldif


vim basedn.ldif

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=extern
 al,cn=auth" read by dn.base="cn=Manager,dc=alvin,dc=com" read by * none

ldapmodify -Y EXTERNAL  -H ldapi:/// -f basedn.ldif


chown ldap:ldap /var/lib/ldap/DB_CONFIG

mkdir -p /var/lib/ldap/

cp /etc/openldap/schema/cosine.ldif   /var/lib/ldap/
cp /etc/openldap/schema/nis.ldif   /var/lib/ldap/
cp /etc/openldap/schema/inetorgperson.ldif   /var/lib/ldap/

chown ldap:ldap /etc/openldap/schema/
chown ldap:ldap /etc/openldap/schema/*

ldapadd -Y EXTERNAL -H ldapi:/// -f /var/lib/ldap/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /var/lib/ldap/nis.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /var/lib/ldap/inetorgperson.ldif


slaptest -u


dn: dc=alvin,dc=com(最頂層設定)
dn: cn=Manager,dc=alvin,dc=com(管理員節點)
dn: ou=People,dc=alvin,dc=com(帳號與密碼)
dn: ou=Group,dc=alvin,dc=com(群組項目)



dc=alvin,dc=com  -----------  cn=Manager,dc=alvin,dc=com
                 |
       -------------------------
       |                       |
   ou=People,dc=alvin,dc=com   ou=Group,dc=alvin,dc=com



vim base.ldif

dn: dc=alvin,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: alvin com
dc: alvin

dn: cn=Manager,dc=alvin,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=alvin,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=alvin,dc=com
objectClass: organizationalUnit
ou: Group


ldapadd -x -W -D "cn=Manager,dc=alvin,dc=com" -f base.ldif

wget http://mirror.centos.org/centos/7/os/x86_64/Packages/migrationtools-47-15.el7.noarch.rpm

yum install ./migrationtools-47-15.el7.noarch.rpm

mkdir /home/rhome

useradd -d /home/rhome/ldapuser1 -u 6001 ldapuser1

echo "mypassword123" | passwd --stdin ldapuser1

id ldapuser1

ll /home/rhome

vim /usr/share/migrationtools/migrate_common.ph

grep ldapuser /etc/passwd > user.txt

grep ldapuser /etc/group > group.txt

/usr/share/migrationtools/migrate_passwd.pl user.txt > user.ldif

/usr/share/migrationtools/migrate_group.pl group.txt > group.ldif

cat user.ldif











vim basedn.ldif 
dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=extern
 al,cn=auth" read by dn.base="cn=admin,dc=alvin,dc=com" read by * none


 ldapmodify -Y EXTERNAL -H ldapi:/// -f basedn.ldif

#########################################################################

 cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG

 chown ldap:ldap /var/lib/ldap/DB_CONFIG



vim base.ldif


dn: dc=alvin,dc=com
objectClass: top
objectClass: dcObject
objectclass: organization
o: alvin com
dc: alvin

dn: cn=Manager,dc=alvin,dc=com
objectClass: organizationalRole
cn: Manager
description: Directory Manager

dn: ou=People,dc=alvin,dc=com
objectClass: organizationalUnit
ou: People

dn: ou=Group,dc=alvin,dc=com
objectClass: organizationalUnit
ou: Group


ldapadd -x -W -D "cn=Manager,dc=alvin,dc=com" -f base.ldif