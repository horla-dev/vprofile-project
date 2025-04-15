FROM mysql:8.0.33
LABEL "project"="vprofile"
LABEL "Author"="Olaniyi"

ENV MYSQL_ROOT_PASSWORD="vprodbpass"
ENV MYSQL_DATABASE="accounts"

COPY db_backup.sql entrypoint-initdb.d/db_backup.sql
