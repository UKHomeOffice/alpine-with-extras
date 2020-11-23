FROM alpine:latest

LABEL description="Alpine lightweight image with AWS CLI"
LABEL maintainer="mark.wimpory@digital.homeoffice.gov.uk"

# Latest apk
RUN apk upgrade --no-cache

# Add general tools
RUN apk add --no-cache groff zip python3 py3-pip bash

# Add AWS CLI
RUN pip3 install --upgrade pip && pip3 install awscli && rm -rf /var/cache/apk/*

# Alpine does not have bash but uses ash (sh)
CMD ["/bin/sh"]