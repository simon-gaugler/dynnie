FROM alpine
RUN apk --no-cache add bash curl bind-tools

COPY dynnie.sh /dynnie.sh
COPY dynnie_errors.sh /dynnie_errors.sh
COPY dynnie_services.sh /dynnie_services.sh

RUN chmod +x /dynnie.sh

CMD /bin/bash /dynnie.sh