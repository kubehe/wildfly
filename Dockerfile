FROM centos:latest

MAINTAINER kubehe <jakub.k.b@hotmail.com>

USER root

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip  && yum clean all

RUN curl --insecure --junk-session-cookies --location --remote-name --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.rpm && \
    yum install -y -q jdk-10.0.2_linux-x64_bin.rpm && \
    yum install -y unzip && \
    rm jdk-10.0.2_linux-x64_bin.rpm && \
    yum clean all

ENV JAVA_HOME /usr/java/jdk10.0.2

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss

WORKDIR /opt/jboss

USER jboss

ENV WILDFLY_VERSION 14.0.0.Final
ENV WILDFLY_SHA1 9a6c81463857bc2c7afc843b359be9a5b1806624
ENV JBOSS_HOME /opt/jboss/wildfly

USER root

RUN cd $HOME \
    && curl -O https://download.jboss.org/wildfly/$WILDFLY_VERSION/wildfly-$WILDFLY_VERSION.tar.gz \
    && sha1sum wildfly-$WILDFLY_VERSION.tar.gz | grep $WILDFLY_SHA1 \
    && tar xf wildfly-$WILDFLY_VERSION.tar.gz \
    && mv $HOME/wildfly-$WILDFLY_VERSION $JBOSS_HOME \
    && rm wildfly-$WILDFLY_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

EXPOSE 8080 9990

# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0"]