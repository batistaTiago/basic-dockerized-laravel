#/bin/sh
docker-compose build;
docker-compose up -d;
docker-compose exec php npm run compile-sass-once;
docker-compose exec php service cron start;