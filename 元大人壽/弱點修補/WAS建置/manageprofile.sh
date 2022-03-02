./manageprofiles.sh -create \
-profileName AppServer \
-profilePath "\usr\IBM\WebSphere\AppServer\profiles\Node1" \
-templatePath "\usr\IBM\WebSphere\AppServer\profileTemplates\managed" 
-cellName alvin1Cell01 \
-hostName alvin \
-nodeName Node1



./manageprofiles.sh -create \
-templatePath /usr/IBM/WebSphere/AppServer/profileTemplates/default \
-profileName AppSrv01 \
-profilePath /usr/IBM/WebSphere/AppServer/profiles/AppSrv01
-enableAdminSecurity true
-isDefault -adminUserName wasadmin -adminPassword wasadmin 

./manageprofiles.sh -create \
-templatePath /usr/IBM/WebSphere/AppServer/profileTemplates/default \
-profileName AppSrv02 \
-profilePath /usr/IBM/WebSphere/AppServer/profiles/AppSrv02





manageprofiles.sh -delete \
-profileName Node1 \
-profilePath "" \
-templatePath "D:\Program Files\IBM\WebSphere\AppServer\profileTemplates\managed" \
-cellName alvin1Cell01 \
-hostName alvin \
-nodeName Node1

./manageprofiles.sh -create -profileName Dmgr 
-profilePath /usr/IBM/WebSphere/AppServer/profiles/Dmgr  
-templatePath /usr/IBM/WebSphere/AppServer/profileTemplates/dmgr 
-enableAdminSecurity true
-isDefault -adminUserName wasadmin -adminPassword wasadmin 
-cellName DmgrCell 
-hostName WAS1 
-nodeName Dmgr