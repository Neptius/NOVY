#!/bin/sh
echo Start Nginx
nginx -g "daemon on;"
echo Execute Migration
/app/bin/novy eval "NovyData.Release.migrate"
echo Start Phoenix
/app/bin/novy start