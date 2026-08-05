# FROM node:20
# WORKDIR /opt/server
# COPY package.json .
# COPY *.js .
# RUN npm install
# ENV ENV MONGO="true" \
#     MONGO_URL="mongodb://mongodb:27017/catalogue"
# CMD ["node","server.js"]

FROM node:20.19.5-alpine AS build
WORKDIR /opt/server
COPY package.json .
COPY *.js .
RUN npm install

FROM node:20.19.5-alpine
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
EXPOSE 8080
WORKDIR /opt/server
LABEL com.project="roboshop" \
      component="catalogue" \
      created_by="poojithkumar"
ENV MONGO="true" \
    MONGO_URL="mongodb://mongodb:27017/catalogue"

COPY --from=build --chown=roboshop:roboshop /opt/server /opt/server

USER roboshop
CMD ["server.js"]
ENTRYPOINT ["node"]
