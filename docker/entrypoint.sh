#!/bin/sh
set -e

echo "Waiting for database at ${DB_HOST}:${DB_PORT}..."
until nc -z "${DB_HOST}" "${DB_PORT}"; do
  sleep 1
done
echo "Database is up."

python manage.py migrate --noinput
python manage.py collectstatic --noinput --clear

exec gunicorn foodOnline_main.wsgi:application \
    --bind 0.0.0.0:8000 \
    --workers 3 \
    --timeout 120
