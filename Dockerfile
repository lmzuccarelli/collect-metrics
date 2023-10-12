FROM registry.access.redhat.com/ubi9/ubi-init:latest

RUN mkdir /run/collect-metrics && mkdir /run/collect-metrics/scripts && mkdir /run/collect-metrics/archives && \
    chgrp -R 0 /run/collect-metrics && \
    chmod -R g=u /run/collect-metrics


# taken from KCS article https://access.redhat.com/solutions/5343671
# RUN dnf install -y tc perf psmisc hostname sysstat iotop conntrack-tools ethtool numactl net-tools
RUN dnf install -y perf psmisc hostname sysstat iotop conntrack-tools ethtool numactl net-tools

COPY scripts/* /run/collect-metrics/scripts
COPY ./uid_entrypoint.sh ./uid_entrypoint.sh


USER 65532:65532

# this allows us to set the command and args in the deploy config
ENTRYPOINT ["./uid_entrypoint.sh"]
