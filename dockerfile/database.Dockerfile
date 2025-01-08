FROM mysql
COPY ./database/init.sql /docker-entrypoint-initdb.d/