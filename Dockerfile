FROM centos:latest

MAINTAINER kubehe <jakub.k.b@hotmail.com>

USER root

RUN yum update -y && yum -y install xmlstarlet saxon augeas bsdtar unzip java-10-openjdk-devel && yum clean all

RUN groupadd -r jboss -g 1000 && useradd -u 1000 -r -g jboss -m -d /opt/jboss -s /sbin/nologin -c "JBoss user" jboss && \
    chmod 755 /opt/jboss

WORKDIR /opt/jboss

USER jboss

ENV JAVA_HOME /usr/lib/jvm/java