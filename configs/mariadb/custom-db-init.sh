#!/bin/bash

echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_IOB_DATABASE\` ;" | "${mysql[@]}"

if [ "$MYSQL_IOB_USER" -a "$MYSQL_IOB_PASSWORD" ]; then
	echo "CREATE USER '$MYSQL_IOB_USER'@'%' IDENTIFIED BY '$MYSQL_IOB_PASSWORD' ;" | "${mysql[@]}"
	if [ "$MYSQL_IOB_DATABASE" ]; then
		echo "GRANT ALL ON \`$MYSQL_IOB_DATABASE\`.* TO '$MYSQL_IOB_USER'@'%' ;" | "${mysql[@]}"
	fi
fi
