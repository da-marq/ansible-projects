#!/bin/sh

service=$1

#Artifactory/Xray token
token="<token-goes-here>"


case $service in
    confluence)
        cv=$(curl -sk <confluence url>/rest/applinks/1.0/manifest| xmllint --xpath "//manifest/version/text()" -)
        creg='([0-9]+\.[0-9]+\.[0-9]+)'
        if [[ $cv =~ $creg ]]; then
            echo "${BASH_REMATCH[1]}"
        else
            echo "Confluence version not found"
        fi
        echo $cv
        ;;
    jira)
        jv=$(curl -sk <jira url>/rest/applinks/1.0/manifest| xmllint --xpath "//manifest/version/text()" -)
        echo $jv
        ;;
    bitbucket)
        bbv=$(curl -sk <bitbucket url>/rest/applinks/1.0/manifest| xmllint --xpath "//manifest/version/text()" -)
        echo $bbv
        ;;
    crowd)
        crdv=$(curl -sk <crowd url>/rest/applinks/1.0/manifest| xmllint --xpath "//manifest/version/text()" -)
        echo $crdv
        ;;
    jsm)
        jsmv=$(curl -sk <jsm url>/rest/applinks/1.0/manifest| xmllint --xpath "//manifest/version/text()" -)
        echo $jsmv
        ;;
    artifactory)
        artv=$(curl -u admin:$token  -sk <artifactory url>/api/system/version | jq '.version')
        echo $(sed -e 's/^"//' -e 's/"$//' <<<"$artv")
        ;;
    xray)
        xrv=$(curl -sk <xray url>/api/v1/system/version | jq '.xray_version')
        echo $(sed -e 's/^"//' -e 's/"$//' <<<"$xrv")
        ;;
    codedx)
        cdxv=$(curl -sk <codedx url>/api/system-info | jq ".version")
        echo $(sed -e 's/^"//' -e 's/"$//' <<<"$cdxv")
        ;;
    jenkins)
        jnkt=$(curl -sk <jenkins url>/api/)
        jreg='Jenkins ([0-9]+\.[0-9]+)'
        if [[ $jnkt =~ $jreg ]]; then
            echo "${BASH_REMATCH[1]}"
        else
            echo "Jenkins version not found"
        fi
        ;;
    jama)
        jamt=$(curl -sk <jama url>/login.req)
        jamreg='Jama Connect ([0-9]+\.[0-9]+\.[0-9]+)'
        if [[ $jamt =~ $jamreg ]]; then
            echo "${BASH_REMATCH[1]}"
        else
            echo "Jama version not found"
        fi
        ;;
    swagger)
        version=$(curl -sk <swagger url>/home -H application/json)
        regex='"version":"([^"]+)"'
        if [[ $version =~ $regex ]]; then
            versionNumber=${BASH_REMATCH[1]}
            echo $versionNumber
        else
            echo 'Swagger version not found.'
        fi
        ;;
    tasktop)
        vcurl=$(curl -sk -u 'zabbix.service:<password-goes-here>' <tasktop url>/api/details | jq '.version.version')
        regex='([0-9]{2}\.[0-9]\.[0-9]{2})'

        if [[ $vcurl =~ $regex ]]; then
        version=${BASH_REMATCH[1]}
        echo $version
        else
        echo "Tasktop version not found"
        fi
        ;;
esac