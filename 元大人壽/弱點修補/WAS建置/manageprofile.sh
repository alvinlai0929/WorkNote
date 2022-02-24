manageprofiles.sh -create \
-profileName AppServer \
-profilePath "\usr\IBM\WebSphere\AppServer\profiles\Node1" \
-templatePath "\usr\IBM\WebSphere\AppServer\profileTemplates\managed" 
-cellName alvin1Cell01 \
-hostName alvin \
-nodeName Node1



./manageprofiles.sh -create \
-templatePath /usr/IBM/WebSphere/AppServer/profileTemplates/default \
-profileName AppSrv01 \
-profilePath /usr/IBM/WebSphere/AppServer/profiles/



manageprofiles.sh -delete \
-profileName Node1 \
-profilePath "" \
-templatePath "D:\Program Files\IBM\WebSphere\AppServer\profileTemplates\managed" \
-cellName alvin1Cell01 \
-hostName alvin \
-nodeName Node1