#!/bin/sh

exec /bin/bash -c "nginx -c /etc/nginx/nginx.conf -g 'daemon off;'"
