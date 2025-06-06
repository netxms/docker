#!/bin/sh

touch ${JETTY_BASE}/jetty-ssl.properties

if [ ! -n "$KEYSTORE_PASSWORD" ]; then
    KEYSTORE_PASSWORD=changeit
fi

echo "jetty.sslContext.keyStorePassword=${KEYSTORE_PASSWORD}" > ${JETTY_BASE}/jetty-ssl.properties

# SNI should be disabled for bundled self-signed keystore, as it always have wrong hostname/
BUNDLED_FINGERPRINT="26:65:EC:84:13:CA:EC:C0:CF:54:BF:66:6C:97:65:9F:C7:B5:09:14:CF:35:6F:85:F7:40:85:28:E9:6F:5B:5F"
CURRENT_FINGERPRINT=$(keytool -list -v -keystore /var/lib/jetty/etc/keystore.p12 -storetype PKCS12 -storepass ${KEYSTORE_PASSWORD} 2>/dev/null | grep "SHA256:" | cut -d' ' -f3)

if [ "$CURRENT_FINGERPRINT" = "$BUNDLED_FINGERPRINT" ]; then
    echo "jetty.ssl.sniRequired=false" >> ${JETTY_BASE}/jetty-ssl.properties
    echo "jetty.ssl.sniHostCheck=false" >> ${JETTY_BASE}/jetty-ssl.properties
fi

exec java -jar $JETTY_HOME/start.jar ${JETTY_BASE}/jetty-ssl.properties "$@"
