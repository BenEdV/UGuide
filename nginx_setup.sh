#!/bin/bash
set -e

conf=/etc/nginx/conf.d/default.conf.template

if [ "$BLOCK_LL_API" = true ] ; then
	# Remove lines containing the redirect to the Learning Locker API
	lineNum="$(grep -n "ll/api" $conf | head -n 1 | cut -d: -f1)"
	sed "$lineNum,$((lineNum+2))d" $conf > /conf_no_ll.conf
	conf=/conf_no_ll.conf
fi

if [ "$FLASK_ENV" == "development" ] ; then
	# Remove lines containing the UWSGI pass for the production server
	lineNumStart="$(grep -n "# UWSGI pass" $conf | head -n 1 | cut -d: -f1)"
	lineNumEnd="$(grep -n "uwsgi_pass backend:80;" $conf | head -n 1 | cut -d: -f1)"
	sed "$lineNumStart,$((lineNumEnd))d" $conf > /conf_dev.conf
	conf=/conf_dev.conf
else
	# Remove lines containing the proxy pass for the development server
	lineNumStart="$(grep -n "# Development server pass" $conf | head -n 1 | cut -d: -f1)"
	lineNumEnd="$(grep -n "proxy_pass http://backend:80;" $conf | head -n 1 | cut -d: -f1)"
	sed "$lineNumStart,$((lineNumEnd))d" $conf > /conf_prod.conf
	conf=/conf_prod.conf
fi	

# substitute env variables in configuration
export DOLLAR='$'
envsubst < $conf > /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
