FROM alpine
RUN apk update && apk add bash wget curl

COPY dynnie.sh /dynnie.sh
COPY dynnie_errors.sh /dynnie_errors.sh

CMD /bin/bash /dynnie.sh