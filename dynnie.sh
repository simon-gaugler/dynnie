#!/bin/bash

### IMPORTS
. dynnie_errors.sh
. dynnie_services.sh

### CONSTANTS
_MYIP="myip"
_MYIPV6="myipv6"
_HOSTNAME="hostname"

### Functions ###

function updateLoop {
    oldIP=""
    oldIPV6=""

    while :
    do
        updateIpAdresses
        if [ "$IP" != "$oldIP" ] || [ "$IPV6" != "$oldIPV6" ]
        then
            echo "IP Adress changed, old: $oldIP, new: $IP (old IPv6: $oldIPV6, new IPv6: $IPV6)"
            oldIP=$IP
            oldIPV6=$IPV6
            sendDynDnsUpdate
        else
            echo "IP unchanged, skipping update"
        fi
        sleepIntervalTime
    done
}

function sendDynDnsUpdate {
    URL="https://$SERVICE_URL?$URL_VAR_HOSTNAME=$HOSTNAME&$URL_VAR_IP_V4=$IP"

    if [ -n "$UPDATE_IP_V6" ] && [ "$UPDATE_IP_V6" = "true" ]
    then
        URL="$URL&$URL_VAR_IP_V6=$IPV6"
    fi

    if [ -n "$URL_VAR_APPENDIX" ]
    then
        URL="$URL&$URL_VAR_APPENDIX"
    fi

    echo "Updating DynDns now - calling URL: $URL"
    RESULT=$(curl -s -u $USERNAME:$PASSWORD "$URL")
    echo "DynDNS called, result: $RESULT"
}

function sleepIntervalTime {
    if [ $INTERVAL_SEC -eq 0 ]
    then
        break
    else
        sleep "${INTERVAL_SEC}s"
    fi
}

function setupDefaultVariables {
    if [ -z "$URL_VAR_IP_V4" ]
    then
        URL_VAR_IP_V4=$_MYIP
    fi

    if [ -z "$URL_VAR_IP_V6" ]
    then
        URL_VAR_IP_V6=$_MYIPV6
    fi

    if [ -z "$URL_VAR_HOSTNAME" ]
    then
        URL_VAR_HOSTNAME=$_HOSTNAME
    fi

    if [ -z "$INTERVAL_SEC" ]
    then
        INTERVAL_SEC=60
    fi

    if [ -z "$DETECT_IP_V4" ]
    then
        DETECT_IP_V4="true"
    fi

    if [ -z "$DETECT_IP_V6" ]
    then
        DETECT_IP_V6="false"
    fi

    if [ -z "$UPDATE_IP_V6" ]
    then
        UPDATE_IP_V6="false"
    fi

    
}

function checkAllRequiredVariablesSet {
    if [ -z "$USERNAME" ]
    then
        echo "Username is required!"
        exit $DYNNIE_ERR_USERNAME_REQUIRED
    fi

    if [ -z "$PASSWORD" ]
    then
        echo "Password is required!"
        exit $DYNNIE_ERR_PASSWORD_REQUIRED
    fi

    if [ -z "$SERVICE_URL" ]
    then
        echo "ServiceUrl or Service is required!"
        exit $DYNNIE_ERR_SERVICE_URL_REQUIRED
    fi

    if [ -z "$HOSTNAME" ]
    then
        echo "Hostname is required!"
        exit $DYNNIE_ERR_HOSTNAME_REQUIRED
    fi

    if [ -z "$INTERVAL_SEC" ]
    then
        echo "Interval_sec is required, default could not be applied!"
        exit $DYNNIE_ERR_INTERVAL_SEC_REQUIRED
    fi

    if [ -z "$DETECT_IP_V4" ] && [ -z "$SET_IP_V4" ]
    then
        echo "Either automatic detection of ipv4 or manual ipv4 must be configured"
        exit $DYNNIE_ERR_DETECT_IP_CONFIG_REQUIRED
    fi

    if [ -z "$DETECT_IP_V6" ] && [ -z "$SET_IP_V6" ]
    then
        echo "Either automatic detection of ipv6 or manual ipv6 must be configured"
        exit $DYNNIE_ERR_DETECT_IPV6_CONFIG_REQUIRED
    fi

}

function detectIpv4 {
    echo "Calling Ipify-API for external IPv4"
    #IP=$(curl -s -4 --connect-timeout 5 "https://api.ipify.org?format=text")
    
}

function detectIpv6 {
    echo "Calling Ipify-API for external IPv6"
    #IPV6=$(curl -s -6 "https://api6.ipify.org?format=text")
}

function updateIpAdresses {
    if [ "$DETECT_IP_V4" = "true" ] || [ "$DETECT_IP_V4" = "1" ]
    then
        # Detect IPv4 is activated by default
        IP=$(dig +short -4 myip.opendns.com @resolver1.opendns.com)
        echo "Fetched IPv4 Adress: $IP"
    else
        if [ -z "$SET_IP_V4" ]
        then
            echo "Automatic detection of ipv4 is deactivated and no manual ipv4 is specified"
            exit $DYNNIE_ERR_DETECT_IP_CONFIG_REQUIRED
        fi
        IP=$SET_IP_V4
    fi

    if [ -n "$UPDATE_IP_V6" ] && [ "$UPDATE_IP_V6" = "true" ]
    then
        if [ "$DETECT_IP_V6" = "true" ] || [ "$DETECT_IP_V6" = "1" ]
        then
            # Detect IPv6 is deactivated by default    
            IPV6=$(dig +short -t aaaa myip.opendns.com @resolver1.opendns.com)
            #IPV6=$(curl -s -6 https://api64.ipify.org?format=text)
            echo "Fetched IPv6 Adress: $IPV6"
        else
            if [ -z "$SET_IP_V6" ]
            then
                echo "Automatic detection of ipv6 is deactivated and no manual ipv6 is specified"
                exit $DYNNIE_ERR_DETECT_IPV6_CONFIG_REQUIRED
            fi
            IPV6=$SET_IP_V6
        fi
    fi
}

### PROGRAM
# Check if default variables are set - if not fill with defaults
setupDefaultVariables
# Check if Preconfigured Service is chosen and apply values
applyKnownServiceConfiguration
checkAllRequiredVariablesSet

# starts the endless update Loop (checking for new IP, updating on change, sleeping intervall)

updateLoop
exit 0