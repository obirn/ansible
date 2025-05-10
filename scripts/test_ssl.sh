#!/bin/sh

HOST_IP="172.20.10.2"
HOST_DOMAIN="blog.epitaf.local"
USER_CERTIFICATE="scripts/ssl/AD_User.pem"

test_ssl () {
    echo "==========================" 
    echo "# Testing SSL for $1" :
    echo "==========================" 

    HOST=$1
    URL="https://$HOST"

    # Test that the host is reachable
    ping -c 1 "$HOST" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Host $HOST is not reachable"
        exit 1
    fi
    echo "Ping $HOST ✅"

    # Test that the SSL certificate is valid
    SSL_OUTPUT=$(curl -L -k --cert $USER_CERTIFICATE $URL 2>&1)
    if [ $? -ne 0 ]; then
        echo "SSL certificate is not valid"
        exit 1
    fi
    echo "Request with user certificate works ✅"

    # Test that without mTLS authentification the connection is refused
    HTTP_RESPONSE_CODE=$(curl -L -k -o /dev/null -s -w "%{http_code}" $URL 2>&1)
    if [ $? -ne 0 ] || [ "$HTTP_RESPONSE_CODE" -ne 400 ]; then
        echo "mTLS authentication should have failed"
        exit 1
    fi
    echo "Request without user certificate are blocked ✅"

    # Test that only GET, POST, PUT request works, otherwise returns 405
    UNAUTHORIZED_HTTP_METHODS="DELETE OPTIONS PATCH TRACE"
    for METHOD in $UNAUTHORIZED_HTTP_METHODS; do
        HTTP_RESPONSE_CODE=$(curl --cert $USER_CERTIFICATE -L -X $METHOD -k -o /dev/null -s -w "%{http_code}" $URL)
        if [ $? -ne 0 ]; then
            echo "$METHOD request failed"
            exit 1
        fi
        if [ "$HTTP_RESPONSE_CODE" -ne 405 ]; then
            echo "$METHOD request should have returned 405, but got $HTTP_RESPONSE_CODE"
            exit 1
        fi
    done
    echo "Unauthorized HTTP methods are blocked ✅"

    echo ""
}

test_ssl $HOST_IP
test_ssl $HOST_DOMAIN