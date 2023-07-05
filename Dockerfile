FROM gradle:jdk17-alpine AS builder

WORKDIR /src

COPY . .

RUN gradle build && \
    cd build/libs && \
    ls && \
    rm $(ls *plain.jar) && \
    mv $(ls *.jar) app.jar

FROM openjdk:17-alpine

WORKDIR /app

COPY --from=builder /src/build/libs /app
COPY --from=builder /src /src

RUN ls -al

EXPOSE 8080

ENTRYPOINT ["java","-jar","./app.jar"]