FROM alpine:latest

LABEL description="Alpine lightweight image with Done and AWS CLI"
LABEL maintainer="mark.wimpory@digital.homeoffice.gov.uk"

# Add general tools
RUN apk add curl && apk add groff && apk add zip

# Add a new user
RUN adduser --system sas --uid 999

# Add AWS CLI
RUN apk add --no-cache python3 py3-pip && pip3 install --upgrade pip && pip3 install awscli && rm -rf /var/cache/apk/*

# Add Drone
RUN curl -L https://github.com/drone/drone-cli/releases/latest/download/drone_linux_amd64.tar.gz | tar zx
RUN install -t bin drone

# Change to the new user
USER 999

# Alpine does not have bash but uses ash (sh)
CMD ["/bin/sh"]