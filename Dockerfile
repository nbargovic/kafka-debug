FROM confluentinc/cp-base-new:latest

USER root

RUN dnf update -y

RUN dnf install -y nmap-ncat \
 && dnf install -y bind-utils \
 && dnf install -y jq \
 && dnf install -y vim \
 && dnf install -y openssl-libs \
 && dnf install -y net-tools

RUN mkdir -p /home/appuser/.local/bin
RUN chown -R appuser:appuser /home/appuser/.local
RUN mkdir -p /home/appuser/.kube
RUN chown -R appuser:appuser /home/appuser/.kube
COPY --chown=appuser --chmod=755 ./kubectl/kubectl.amd64 /home/appuser/.local/bin/kubectl
COPY --chown=appuser --chmod=755 ./kubectl/config /home/appuser/.kube/.
COPY --chown=appuser --chmod=755 ./kcat-1.7.1/kcat.amd64 /usr/bin/kcat

WORKDIR /home/appuser

COPY --chown=appuser --chmod=755 ./kafka_2.13-3.6.2 /home/appuser/kafka_2.13-3.6.2/.
COPY --chown=appuser --chmod=755 ./properties /home/appuser/properties/.
COPY --chown=appuser --chmod=755 ./keystores /home/appuser/keystores/.

ENV PATH="${PATH}:/home/appuser/kafka_2.13-3.6.2/bin"

USER appuser

#used to keep pod alive in k8s deployment
CMD ["sh", "-c", "tail -f /dev/null"]
