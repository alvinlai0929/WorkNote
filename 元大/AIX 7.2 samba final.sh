7200-00-01-1543
samba 
RPM
3.0.5.53
更新至4.9.1.3

https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/INSTALLP/ppc/rpm.rte.4.9.1.3

yum
yum_bundle_v1.tar
yum-3.4.3-3 


smitty installp 

rpm -qa yum

yum install yum-plugin-downloadonly


yum list samba --showduplicates


yum info samba-4.12.7-1 

yum install --downloadonly --downloaddir=/tmp/samba/4.12.7-1/ samba-4.12.7-1

yum install --downloadonly --downloaddir=/tmp/samba/4.12.10-1/ samba-4.12.10-1

yum install --downloadonly --downloaddir=/tmp/samba/4.14.4-2 / samba 


Error: Package: openldap-2.4.58-1.ppc (AIX_Toolbox)
           Requires: libssl.a(libssl.so.1.0.2)
Error: Package: python-2.7.18-3.ppc (AIX_Toolbox)
           Requires: libssl.a(libssl.so.1.0.2)
Error: Package: python3-3.7.11-1.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
Error: Package: python3-3.7.11-1.ppc (AIX_Toolbox)
           Requires: libssl.a(libssl.so.1.0.2)
Error: Package: python-2.7.18-3.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
Error: Package: openldap-2.4.58-1.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
Error: Package: cyrus-sasl-2.1.26-5.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)

openssl
https://mrs-ux.mrs-prod-7d4bdc08e7ddc90fa89b373d95c240eb-0000.us-south.containers.appdomain.cloud/marketing/iwm/platform/mrs/assets/DownloadList?source=aixbp&lang=en_US
openssh



yum downgrade 


SAMBA
3.6.25.1
/usr/sbin/updtvpkg

rpm --rebuilddb

#on rpm installp (rpm.rte.3.0.5.54 rpm.rte.4.9.1.3)

smitty INSTALLP

#on yum v1 installp  (chfs -a size=+5G /tmp /home)
smitty INSTALLP

#yum install yum-plugin-downloadonly

yum install yum-plugin-downloadonly

yum install --downloadonly --downloaddir=/tmp/samba/4.14.4-2 / samba 


Error: Package: openldap-2.4.58-1.ppc (AIX_Toolbox)
           Requires: libssl.a(libssl.so.1.0.2)
Error: Package: python-2.7.18-3.ppc (AIX_Toolbox)
           Requires: libssl.a(libssl.so.1.0.2)
Error: Package: python3-3.7.11-1.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
Error: Package: python3-3.7.11-1.ppc (AIX_Toolbox)
           Requires: libssl.a(libssl.so.1.0.2)
Error: Package: python-2.7.18-3.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
Error: Package: openldap-2.4.58-1.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
Error: Package: cyrus-sasl-2.1.26-5.ppc (AIX_Toolbox)
           Requires: libcrypto.a(libcrypto.so.1.0.2)
 You could try using --skip-broken to work around the problem
 You could try running: rpm -Va --nofiles --nodigest

https://www.ibm.com/support/pages/apar/IJ12089

update openssl

cd /etc/ssh
cp -p ssh_config ssh_config.orig
cp -p sshd_config sshd_config.orig

stopsrc -s sshd;startsrc -s sshd

yum install yum-plugin-downloadonly

yum list samba --showduplicates


#未完成
yum install  --downloadonly --downloaddir=/tmp/samba/4.3.11-1 / samba-4.3.11-1

rpm -ivh \
samba-4.14.4-2.aix7.2.ppc.rpm \
samba-client-4.14.4-2.aix7.2.ppc.rpm \
samba-common-4.14.4-2.aix7.2.ppc.rpm \
samba-devel-4.14.4-2.aix7.2.ppc.rpm \
samba-libs-4.14.4-2.aix7.2.ppc.rpm \
samba-winbind-4.14.4-2.aix7.2.ppc.rpm \
samba-winbind-clients-4.14.4-2.aix7.2.ppc.rpm \
python3-3.7.11-1.aix6.1.ppc.rpm \
cups-libs-2.2.3-3.aix6.1.ppc.rpm \
gnutls-3.7.1-1.aix6.1.ppc.rpm \
libsmbclient-4.14.4-2.aix7.2.ppc.rpm \
popt-1.18-1.aix6.1.ppc.rpm \
coreutils-8.32-1.aix6.1.ppc.rpm \
gmp-6.1.2-1.aix6.1.ppc.rpm \
nettle-3.7.3-1.aix6.1.ppc.rpm

Preparing...                          ################################# [100%]
Updating / installing...
   1:popt-1.18-1                      ################################# [  7%]
   2:python3-3.7.11-1                 ################################# [ 13%]
   3:gmp-6.1.2-1                      ################################# [ 20%]
   4:coreutils-8.32-1                 ################################# [ 27%]
   5:nettle-3.7.3-1                   ################################# [ 33%]
   6:gnutls-3.7.1-1                   ################################# [ 40%]
   7:cups-libs-2.2.3-3                ################################# [ 47%]
   8:samba-devel-4.14.4-2             ################################# [ 53%]
   9:samba-libs-4.14.4-2              ################################# [ 60%]
3004-686 Group "wbpriv" does not exist.
  10:samba-winbind-4.14.4-2           ################################# [ 67%]
  11:samba-winbind-clients-4.14.4-2   ################################# [ 73%]
  12:libsmbclient-4.14.4-2            ################################# [ 80%]
  13:samba-common-4.14.4-2            ################################# [ 87%]
  14:samba-client-4.14.4-2            ################################# [ 93%]
  15:samba-4.14.4-2                   ################################# [100%]

A guide to installing Samba on AIX can be found in /opt/freeware/doc/samba-4.14.4/README.AIX_Samba_Usage_Guide




#降板
yum list samba --showduplicates

yum downgrade  samba-4.12.7-1 


yum install samba-4.12.7-1




SAMBA
3.6.25.1
/usr/sbin/updtvpkg

rpm --rebuilddb

#on rpm installp (rpm.rte.3.0.5.54 rpm.rte.4.9.1.3)

smitty INSTALLP

#on yum v1 installp  (chfs -a size=+5G /tmp /home)
smitty INSTALLP

#yum install yum-plugin-downloadonly

yum install yum-plugin-downloadonly

yum install --downloadonly --downloaddir=/tmp/samba/4.14.4-2 / samba 

#下載4.12
https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc-7.2/samba/



update openssl
update RPM 

stopsrc -g ssh;startsrc -g ssh



/usr/sbin/updtvpkg

rpm --rebuilddb

chfs -a size=+10G /opt
chfs -a size=+10G /usr
chfs -a size=+10G /tmp
chfs -a size=+10G /home

rpm -Uvh *

From cyrus-sasl 2.1.26-5 onwards, symbolic links in /usr/sbin has been removed.
The binaries are shipped in /opt/freeware/sbin. Please use absolute path or
add /opt/freeware/sbin in PATH environment variable to use the binary.
3004-686 Group "ldap" does not exist.
  36:openldap               ########################################### [ 75%]
  37:libsmbclient           ########################################### [ 77%]
  38:samba-devel            ########################################### [ 79%]
  39:samba-libs             ########################################### [ 81%]
3004-686 Group "wbpriv" does not exist.
  40:samba-winbind          ########################################### [ 83%]
  41:samba-winbind-clients  ########################################### [ 85%]
  42:samba-common           ########################################### [ 88%]
  43:samba-client           ########################################### [ 90%]
  44:samba                  ########################################### [ 92%]

A guide to installing Samba on AIX can be found in /opt/freeware/doc/samba-4.14.4/README.AIX_Samba_Usage_Guide

  45:pysqlite               ########################################### [ 94%]
  46:python-devel           ########################################### [ 96%]
  47:python-tools           ########################################### [ 98%]
  48:yum-metadata-parser    ########################################### [100%]


vi /etc/env*
:/opt/freeware/sbin/

#查看目前安裝
rpm -qa | grep

#移除
rpm -e samba 

browsable = yes

writable = yes

guest ok = yes

read only = no



