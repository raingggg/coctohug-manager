docker network create coctohug-network

cd compose
for f in $(find . -type d); do echo "networks:\n  default:\n    external:\n      name: coctohug-network" >> $f/docker-compose.yml; done
rm docker-compose.yml
cd ..
