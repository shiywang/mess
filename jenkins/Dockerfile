FROM docker-registry.engineering.redhat.com/aosqe/cucushift-base-20171009:latest

USER root
RUN curl http://download-node-02.eng.bos.redhat.com/rcm-guest/puddles/RHAOS/AtomicOpenShift/3.7/latest/puddle.repo -o /etc/yum.repos.d/puddle.repo && \
    yum remove 'origin*.x86_64' -y && \
    yum -y install atomic-openshift atomic-openshift-clients && \
USER 1001
