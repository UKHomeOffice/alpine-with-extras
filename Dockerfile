FROM alpine:latest

LABEL description="Alpine lightweight image with AWS CLI and additional tools"
LABEL maintainer="mark.wimpory@digital.homeoffice.gov.uk"

# Latest apk
RUN apk upgrade --no-cache

# Add general tools
RUN apk add --no-cache groff zip python3 py3-pip bash jq

# Comment this in if you reqiure drone cli - note will not work in pipeline without credentials
#RUN apk add drone-cli --repository http://dl-3.alpinelinux.org/alpine/edge/testing

# Add AWS CLI
RUN pip3 install --upgrade pip && pip3 install awscli && rm -rf /var/cache/apk/*

# Copy our scripts into the image
COPY scripts ./scripts

# Alpine does not have bash but uses ash (sh)
CMD ["/bin/sh"]