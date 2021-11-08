#!/usr/bin/ksh
#SET AIX SYSTER
#20190131 By Yilong

echo "########change aix operation Parameters##################"
echo "change aix operation Parameters"
#
chdev -l sys0 -a iostat=true
chdev -l sys0 -a maxuproc='65536' 
chdev -l sys0 -a ncargs='256'
chdev -l sys0 -a max_logname='20'
chdev -l sys0 -a maxbuf='256'

#echo "#########change aio Parameters############################"
#echo "change aio configurate"
#
#x() {
#    chdev -l aio0 -P $*
#    if [ $? = 0 ]
#    then
#    dspmsg smit.cat -s 25 763 'Changes will become effective at next system restart'
#    fi
#    }
#    x -a minservers='40' -a maxservers='80' -a maxreqs='16384' -a autoconfig='available' -a fastpath='enable'

#chdev -l aio0 -P -a minservers='40' -a maxservers='80' -a maxreqs='16384' -a autoconfig='available' -a fastpath='enable'

####change profile########################################
echo "change profile"
echo "set -o vi" >> /etc/profile
echo "export PS1='"'$USER'"'.\`hostname\`."\''$PWD>'"'" >> /etc/profile
echo "export EXTENDED_HISTORY=ON" >> /etc/profile
echo "export HISTSIZE=50000" >> /etc/profile

#chang Time Zone
echo "change Time Zone to Taipei"
chtz 'Asia/Taipei'
export TZ='Asia/Taipei'

######change Memory & File Syste & LVM Parameters#########
#echo "change Memory & File Syste & LVM Parameters"
#vmo -p -o lru_file_repage=0
vmo -p -o maxclient%=20
vmo -p -o maxperm%=20
vmo -p -o minperm%=5
vmo -p -o v_pinshm=1

#######change network parameters  備註 AIX6.1之後無須調整 ###########################
#echo "change network parameters"
#no -p -o sb_max=1310720
#no -p -o rfc1323=1
#no -p -o tcp_recvspace=262144
#no -p -o tcp_sendspace=65536
#nfso -p -o nfs_rfc1323=1

###########for oracle database############################
#echo "AIXTHREAD_SCOPE=S" >> /etc/environment


##########change filesystem size###############
echo "change filesystem "

chfs -a size=4G /
chfs -a size=8G /usr
chfs -a size=4G /var
chfs -a size=4G /tmp
chfs -a size=4G /home
chfs -a size=4G /opt


#########change user profile##################
echo "change user profile"

chuser fsize='-1' core='-1' cpu='-1' data='-1' rss='-1' stack='-1' nofiles='-1' stack_hard='-1' rss_hard='-1' root

########Create CDROM Filesystems##########
echo "create CDROM Filesystems"
/usr/sbin/crfs -v cdrfs -p ro -d'cd0' -m'/cdrom' -A'no'

#########Create sourcelv################
echo "Create SOURCE 10G"
mklv -y source_lv -t jfs2 rootvg 10
crfs -v jfs2 -d source_lv -m /source -A yes -p rw
mkdir /source
mount /source
chfs -a size=10G /source

