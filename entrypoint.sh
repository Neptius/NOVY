#!/bin/sh

echo Execute Migration
/app/bin/novy eval "NovyData.Release.migrate"
echo Start Phoenix
/app/bin/novy start