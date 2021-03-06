#!/bin/sh
# This scripts downloads the rpm.rte & yum_bundle.tar
# rpm.rte which is a prequisite for yum.
# yum_bundle.tar contains yum and its dependent packages.
# It checks if any of the package from yum_bundle is already installed and then
# installs the packages accordingly.

# flag is used to identify if same, lower or higher version of package is already
# installed from yum_bundle.
# flag=1 Exact version installed
# flag=2 Higher version already installed
# flag=3 Lower version already installed
# flag=0 No package from yum_bundle is installed.

#Check if we running this as the root user.
if [[ "$(id -u)" != "0" ]]
then
   echo "This script must be run as root."
   exit 1
fi

# For AIX 6.1 make sure we are installing rpm.rte.4.13.0.11
oslvl=`/usr/bin/oslevel`
os_f1=$(echo $oslvl | /usr/bin/cut -d"." -f1)
os_f2=$(echo $oslvl | /usr/bin/cut -d"." -f2)
os_f3=$(echo $oslvl | /usr/bin/cut -d"." -f3)
os_f4=$(echo $oslvl | /usr/bin/cut -d"." -f4)
if [[ ( $os_f1 -ge 7 ) && ( $os_f2 -ge 3 ) && ( $os_f3 -ge 0 ) && ( $os_f4 -ge 0 ) ]]
then
    echo "YUM isn't supported on AIX 7.3, please use dnf as a package manager for AIX 7.3."
    echo "Please use dnf_aixtoolbox.sh script to setup and install dnf."
    echo "You can download the script from https://public.dhe.ibm.com/aix/freeSoftware/aixtoolbox/ezinstall/ppc/dnf_aixtoolbox.sh"
    exit 1
fi

#Check if /tmp has enough space to download rpm.rte & yum_bundle and size for
#Extracting rpm packages.
# 45 MB for rpm.rte and 54 MB for yum_bundle.tar, 50 MB for rpm packages extracted.

typeset -i total_req=`echo "(45+54+50)" | bc`
tmp_free=`df -m /tmp | sed -e /Filesystem/d | awk '{print $3}'`
if [[ $tmp_free -le $total_req ]]
then
   echo "Please make sure /tmp has 149MB of free space to download rpm.rte & yum_bundle.tar files,"
   echo "and space required for extracting the rpm packages."
   exit 1
fi

#Check if /opt is having enough space to install the packages from yum_bundle.
#Currently we need around 213MB of free space in /opt filesystem.
typeset -i total_opt=`echo "(213)" | bc`
opt_free=`df -m /opt | sed -e /Filesystem/d | awk '{print $3}'`
if [[ $opt_free -le $total_opt ]]
then
   echo "Total free space required for /opt filesystem to install rpms from yum_bundle is around 213MB."
   echo "Please increase the size of /opt and retry."
   exit 1
fi

#Create a temporary directroy where all downloads should go.
curr_time=`date +%Y%m%d%H%M%S`
mkdir -p /tmp/yum-$curr_time
tmppath=`echo /tmp/yum-$curr_time`
cd $tmppath


#Download will be done through expect script.
username="anonymous"
userpassword="anonymous"

echo "Attempting download of rpm.rte & yum_bundle.tar ..."
expect <<YUMEOF
    log_user 0
    set timeout -1
    spawn ftp public.dhe.ibm.com
    expect "Name (public.dhe.ibm.com:*): "
    send "$username\r"
    expect "Password:"
    send "$userpassword\r"
    expect "ftp>"
    send "lcd $tmppath\r"
    expect "ftp>"
    send "bin\r"
    expect "ftp>"
    send "passive\r"
    expect "ftp>"
    send "cd aix/freeSoftware/aixtoolbox/INSTALLP/ppc\r"
    expect "ftp>"
    if {"$oslvl" == "6.1.0.0"} {
        send "get rpm.rte.4.13.0.11\r"
    } else {
        send "get rpm.rte\r"
    }
    expect "ftp>"
    send "cd ../../ezinstall/ppc\r"
    expect "ftp>"
    send "get yum_bundle.tar\r"
    send "bye\r"
    expect eof
YUMEOF

if [[ "$oslvl" = "6.1.0.0" ]]
then
    /usr/bin/mv rpm.rte.4.13.0.11 rpm.rte
fi

if [[ ! -e rpm.rte ]]
then
   echo "Failed to download rpm.rte"
   cd - >/dev/null 2>&1
   rm -rf $tmppath
   exit 1
fi

if [[ ! -e yum_bundle.tar ]]
then
   echo "Failed to download yum_bundle.tar"
   cd - >/dev/null 2>&1
   rm -rf $tmppath
   exit 1
fi
      
#Update rpm.rte to version.
# From AIX 7.1 TL5 & 7.2 TL2 rpm.rte shipped is 4.13.0.1.
# Installation will be skipped if either 4.9.1.3 or 4.13.0.1 is installed. 
echo "Installing rpm.rte at the latest version ..."
echo "This may take several minutes depending on the number of rpms installed..."
installp -qacXYd rpm.rte all
#lslpp -L | grep rpm.rte | grep 4.9.1.3
lslpp -Lc rpm.rte >/dev/null 2>&1
if [[ $? -eq 0 ]]
then
   rpm_ver=`lslpp -Lc rpm.rte | awk 'FNR==2' | awk -F':' '{print $3}' | cut -d'.' -f1`
   #One more check to see if rpm.rte is version4 or higher.
   #We mayn't come to this part at all.
   if [[ $rpm_ver -lt 4 ]]
   then
      rpm_inst=`lslpp -Lc rpm.rte | awk 'FNR==2' | awk -F':' '{print $2, $3}'`
      echo "rpm.rte version required is 4.9.1.3 or higher, but the installed version is ${rpm_inst}"
      cd -
      rm -rf $tmppath
      exit 1
   fi
else
   echo "rpm.rte update to latest version failed."
   echo "Please check the /smit.log file and retry the install."
   cd -
   rm -rf $tmppath
   exit 1
fi

echo "\nExtracting yum_bundle.tar ..."
tar -xvf yum_bundle.tar

#Compares the two packages version number
function cmp_version {
   large=$(echo  ${pkcurr[1]} ${pkversion[$index]}  | \
   awk '{ split($1, a, ".");
     	 split($2, b, ".");
         x = 0;
      	 for (i = 1; i <= 4; i++)
       	    if (a[i] < b[i]) {
       	        x = 3;
       	        break;
       	    } else if (a[i] > b[i]) {
       	        x = 2;
       	        break;
       	    }
            print x;
    	 }')
   return $large
}

#Compares the two packages release number
function cmp_release {
   if [[ $1 < $2 ]]
   then
      return 3
   elif [[ $1 > $2 ]]
   then
      return 2
   elif [[ $1 == $2 ]]
   then
      return 1
   fi
}

#Check if some packages are already installed from the yum_bundle.
echo "\n"
echo "Checking whether any of the rpms from yum_bundle are already installed ...\n"
set -A pkgname
set -A pkversion
set -A pkgrelease
set -A inst_list

ls *.rpm | while read rpm_file
do
   pkname[${#pkname[*]}]=`rpm -qp --qf "%{NAME}" $rpm_file`
   pkversion[${#pkversion[*]}]=`rpm -qp --qf "%{VERSION}" $rpm_file`
   pkgrelease[${#pkgrelease[*]}]=`rpm -qp --qf "%{RELEASE}" $rpm_file`
done

let "index=0"
for pk in ${pkname[@]}
do
   # We need to match exact package name, as we might have packages like python python-devel etc..
   # Packages name will be followed by the version number with "-" as a seperator.

   set -A pkcurr ""
   let "flag=0"
   rpm_file=`ls *.rpm | grep  "^$pk-[0-9]"`
   line=`rpm -qa | grep "^$pk-[0-9]"`

   if [[ ! -z $line ]]
   then 
      # Special care must be taken for packages name having more than one fields.
      # For example python-devel
      oldIFS=$IFS
      IFS='-'
      set -A name_ver $line
      IFS=$oldIFS
      count=`echo ${#name_ver[@]}` #Count number of fields in a package. 
      # Exclude release, version field plus array index starts with 0.
      let "i=$count-3"
    
      if [[ $i -eq 0 ]]
      then
         name=`echo "${name_ver[0]}"`
      elif [[ $i -eq 1 ]]
      then
         name=`echo "${name_ver[0]}-${name_ver[1]}"`
      elif [[ $i -eq 2 ]]
      then
         name=`echo "${name_ver[0]}-${name_ver[1]}-${name_ver[2]}"`
      elif [[ $i -eq 3 ]]
      then
         name=`echo "${name_ver[0]}-${name_ver[1]}-${name_ver[2]}-${name_ver[3]}"`
      else
         echo "Package name more than 4 fields"
      fi

      #To get version exclude release field plus 0 index array.
      let "j=$count-2"
      ver=`echo ${name_ver[$j]}`
     
      # Now set the name version field.
      set -A pktest "$name" "$ver"
   elif [[ -z $line ]]
   then
      set -A pktest $line
   fi

   #get the release field from the installed package.
   release=`rpm -qa | grep "^$pk-[0-9]" | awk -F '-' {'print $NF'} | awk -F '.' {'print $1'}`
   # If package from yum_bundle is installed.
   if [[ ${pktest[0]} == $pk ]]
   then
      set -A pkcurr "$name" "$ver"
      #compare versions of installed package & from the yum bundle.
      cmp_version ${pktest[1]} ${pkversion[$index]}
      rc=$?
      if [[ $rc -eq 3 ]]
      then
         let "flag=3" #Lower version already installed
      elif [[ $rc -eq 2 ]]
      then
         let "flag=2" # Higher version already installed
      elif [[ $rc -eq 0 ]]
      then
         # If version numbers are same then compare the release of packages.
         if [[ ${pktest[1]} == ${pkversion[$index]} ]]
         then
            cmp_release $release ${pkgrelease[$index]}
            rc=$?
            if [[ $rc -eq 3 ]]
            then
               let "flag=3"
            elif [[ $rc -eq 2 ]]
            then
               let "flag=2" 
            elif [[ $rc -eq 1 ]]
            then
               let "flag=1"   # Exact version installed
            fi
         fi
      fi
   fi
  
   if [[ "$flag" -eq 1 ]]
   then
      echo "Package ${pkcurr[0]}-${pkcurr[1]}-$release is already installed"
      let "index=index+1"
      continue;
   elif [[ "$flag" -eq 2 ]]
   then
      echo "Skipping ${pkname[$index]}-${pkversion[$index]}-${pkgrelease[$index]} as higher version is already installed."
      echo "Please make sure these packages are from the Toolbox as there is no guarantee that"
      echo "third party packages are compatible with Toolbox packages.\n"
      let "index=index+1"
      continue;
   elif [ "$flag" -eq 3 ]
   then
      echo "${pktest[0]}-${pktest[1]}-$release is installed.  Updating to ${pkname[$index]}-${pkversion[$index]}-${pkgrelease[$index]} ..."
      inst_list[${#inst_list[*]}+1]=$rpm_file
      let "index=index+1"
      continue;	
   elif [ "$flag" -eq 0 ]
   then
      echo "${pkname[$index]}-${pkversion[$index]}-${pkgrelease[$index]} will be installed ..."
      inst_list[${#inst_list[*]}+1]=$rpm_file
      let "index=index+1"
      continue;
   fi
done

if [[ ${#inst_list[@]} -eq 0 ]]
then
   echo "\nYum and all its dependencies are already installed."
   cd - >/dev/null 2>&1
   rm -rf $tmppath
   exit 1
fi

echo "\nInstalling the packages...\n"
rpm -Uvh ${inst_list[@]}

if [[ $? -eq 0 ]]
then
   cd - >/dev/null 2>&1
   rm -rf $tmppath
   echo
   echo "\033[1;32mYum installed successfully. \033[m"
   echo "\033[1;33mPlease run 'yum update' to update packages to the latest level. \033[m"
   echo
   #yum -y update
elif [[ $? -ne 0 ]]
then
   echo
   echo "\033[1;31mYum installation failed. \033[m" 
   echo "If the failure was due to a space issue, increase the size of /opt and re-run yum.sh"
   echo "or install the downloaded packages from $tmppath manually."
   echo "Another reason for failure could be mixing of Toolbox packages and packages from other sources."
   echo
fi
