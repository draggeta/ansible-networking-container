# pull base image
FROM python:2.7-alpine as BASE

MAINTAINER Tony Fortes Ramos <amfortesramos@hotmail.com>

RUN echo "===> Add certificate tools"  && \
    apk --no-cache add openssl ca-certificates

RUN echo "===> Add build dependencies"  && \
    apk --no-cache add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi  && \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible  && \
    \
    echo "===> Installing required networking tools..."  && \
    pip install netaddr pytest # PyYAML jinja2  && \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies

RUN echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts


# final production image
FROM BASE as PROD
# default command: display Ansible version
CMD [ "ansible", "--version" ]
