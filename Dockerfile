FROM node:14.2.0-alpine

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN apk add --no-cache --virtual .gyp \
        python \
        make \
        g++ \
    && npm install --no-package-lock \
    && apk del .gyp

COPY . .

EXPOSE 6767

CMD [ "npm", "start" ]
