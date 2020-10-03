#/bin/sh
docker-compose build;
docker-compose up -d;

# git checkout into correct branch

docker-compose exec php composer install;
docker-compose exec php npm install;
docker-compose exec php service cron start;