#!/bin/bash

### IMPORTS
. dynnie_errors.sh


function applyKnownServiceConfiguration {
    if [ -z "$SERVICE" ]
    then
        echo "No Service configured, no defaults applied"
        return
    fi

    # dynDNS-Standard is most common - we set this as default:
    URL_VAR_HOSTNAME=$_HOSTNAME
    URL_VAR_IP_V4=$_MYIP
    URL_VAR_IP_V6=$_MYIPV6

    case "$SERVICE" in 
        noip)
            SERVICE_URL="dynupdate.no-ip.com/nic/update"
            ;;
        dyndns)
            SERVICE_URL="members.dyndns.org/v3/update"
            ;;
        duckdns)
            SERVICE_URL="www.duckdns.org/v3/update"
            ;;
        google)
            SERVICE_URL="domains.google.com/nic/update"
            ;;
        freedns)
            SERVICE_URL="freedns.afraid.org/nic/update"
            ;;
        ovh)
            SERVICE_URL="www.ovh.com/nic/update"
            URL_VAR_APPENDIX="system=dyndns"
            ;;
        *)
            # ERROR: unkown service
            echo "The configured service '$SERVICE' is not known or implemented yet! Check the spelling or remove this service - Exiting..."
            exit $DYNNIE_ERR_SERVICE_UNKNOWN
    esac

    echo "Configuration applied for Service '$SERVICE': SERVICE_URL: $SERVICE_URL, URL_VAR_IP_V4: $URL_VAR_IP_V4, URL_VAR_IP_V6: $URL_VAR_IP_V6, URL_VAR_APPENDIX: $URL_VAR_APPENDIX."
}