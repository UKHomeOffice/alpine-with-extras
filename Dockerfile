FROM alpine:latest

LABEL description="Alpine lightweight image with Done and AWS CLI"
LABEL maintainer="mark.wimpory@digital.homeoffice.gov.uk"

# Latest apk
RUN apk upgrade --no-cache

# Add general tools
RUN apk add --no-cache curl groff zip python3 py3-pip ca-certificates openssl bash
RUN update-ca-certificates

# Add AWS CLI
RUN pip3 install --upgrade pip && pip3 install awscli && rm -rf /var/cache/apk/*

# Add Drone
#RUN curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
#RUN install -t bin drone


# Alpine does not have bash but uses ash (sh)
CMD ["/bin/sh"]