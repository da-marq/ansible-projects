#!/bin/sh

service=$1

#Artifactory/Xray token
token="<token-goes-here>"


convert_epoch () {
    now=$(date +%s)
    epochdays=$(($1 - $now))
    days=$(($epochdays / 86400))
    echo $days
}

convert_date () {
    now=$(date +%s)
    date=$(sed -e 's/^"//' -e 's/"$//' <<<"$1")
    target=$(date +%s -d "$date")
    epochdays=$(($target - $now))
    days=$(($epochdays / 86400))
    echo $days
}


case $service in
    confluence)
        cl=$(curl -sk -H "Authorization: Basic <key-goes-here>" <confluence url>/rest/license/1.0/license/details | jq ".maintenanceExpiryDate")
        cl=$(($cl/1000))
        convert_epoch $cl
        ;;
    jira)
        jl=$(curl -sk -H "Authorization: Basic <key-goes-here>" <jira url>/rest/plugins/applications/1.0/installed/jira-software/license | jq ".expiryDate")
        jl=$(($jl/1000))
        convert_epoch $jl
        ;;
    bitbucket)
        bbl=$(curl -sk -H "Authorization: Basic <key-goes-here>" <bitbucket url>/rest/api/1.0/admin/license | jq ".expiryDate")
        bbl=$(($bbl/1000))git 
        convert_epoch $bbl
        ;;
    artifactory)
        artl=$(curl -u admin:$token -sk <artifactory url>/api/system/license | jq '.validThrough')
        convert_date "$artl"
        ;;
    jsm)
        jsml=$(curl -ks -H "Authorization: Basic <key-goes-here>" <jsm url>/rest/plugins/applications/1.0/installed/jira-servicedesk/license | jq ".expiryDate")
        jsml=$(($jsml/1000))
        convert_epoch $jsml
        ;;
    tasktop)
        ttl=$(curl -sk -u 'zabbix.svc:<password-goes-here>' <tasktop url>/api/details | jq '.license.expiryDate')
        convert_date $ttl
        ;;
    codedx)
        cxl=$(cat /usr/lib/zabbix/externalscripts/codedxlicense)
        convert_date $cxl
        ;;
esac