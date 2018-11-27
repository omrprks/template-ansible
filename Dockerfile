ARG  ALPINE_VERSION="3.8"
FROM library/alpine:${ALPINE_VERSION}

ARG ANSIBLE_VERSION="2.5.5-r0"
ARG ANSIBLE_ROOT="/etc/ansible"
ENV ANSIBLE_ROOT="${ANSIBLE_ROOT}"

ARG UID="1100"
ARG GID="1100"

RUN apk --update add --no-cache \
		ansible=${ANSIBLE_VERSION} \
		openssh \
		python3 && \
	rm -rf /var/cache/apk/* /tmp/*

RUN addgroup -g ${GID} ansible && \
	adduser -H -D -G ansible -u ${UID} ansible && \
	mkdir -p ${ANSIBLE_ROOT} && \
	chown -R ansible:ansible ${ANSIBLE_ROOT}

COPY --chown=ansible:ansible . ${ANSIBLE_ROOT}

RUN [ -d ${ANSIBLE_ROOT}/keys ] && \
	find ${ANSIBLE_ROOT}/keys -type f -exec chmod -R 600 {} \;

USER ansible
WORKDIR ${ANSIBLE_ROOT}

ENTRYPOINT [ "ansible" ]
CMD [ "--help" ]
