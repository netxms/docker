FROM jetty:12.0-jdk21-alpine-amazoncorretto

ARG NETXMS_VERSION

COPY start.sh /app/
COPY keystore.p12 /var/lib/jetty/etc/
COPY nxmc-${NETXMS_VERSION}.war /var/lib/jetty/webapps/ROOT.war
COPY ROOT.xml /var/lib/jetty/webapps/

EXPOSE 8080/tcp
EXPOSE 8443/tcp

RUN java -jar $JETTY_HOME/start.jar --add-modules=https,ssl,http2,ee8-deploy,ee8-webapp,ee8-plus,gzip --approve-all-licenses

CMD ["/app/start.sh"]
