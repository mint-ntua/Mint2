FROM andreptb/tomcat:6-jdk6
# Install ANT
ENV ANT_VERSION=1.9.10
ENV ANT_HOME=/opt/ant
WORKDIR /tmp
RUN mkdir /opt
RUN wget http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz.md5

# add executables to path
ENV PATH ${PATH}:/opt/ant/bin
COPY . MINT2
RUN cd MINT2 && \
	ant -Dappname=MINT2 -Denv.TOMCAT_HOME=${CATALINA_HOME} && \
	mv work/dist/MINT2 /usr/local/tomcat/webapps
RUN chgrp -R 0 "$CATALINA_HOME" && chgrp -R 0 ${ANT_HOME}
RUN chmod -R g=u "$CATALINA_HOME" && chmod -R g=u ${ANT_HOME}
WORKDIR $CATALINA_HOME
USER 1001
CMD ["catalina.sh", "run"]	
