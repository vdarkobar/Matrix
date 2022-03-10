#!/bin/bash
clear
echo "Enter required informations:"
echo -ne "${RED}Enter Server Local IP: "; read MSLIP; \
echo -ne "${RED}Enter Matrix Server Domain (example.com): "; read MSDNAME; \
echo -ne "${RED}Enter Element-Web Client Subomain (chat): "; read EWSUBDNAME; \
echo -ne "${RED}Enter Time Zone: "; read TZONE; \
echo -ne "${RED}Enter UID (id $USER): "; read UUID; \
echo -ne "${RED}Enter GID (id $USER): "; read GGID; \
echo -ne "${RED}Enter Synapse Port Number (*:8008): "; read SYNPORT; \
echo -ne "${RED}Enter Synapse Secure Port Number (*:443): "; read SYNSPORT; \
echo -ne "${RED}Enter Element-Web Port Number (*:80): "; read EWPORT; \
echo -ne "${RED}Enter Redis Port Number (*:6379): "; read REDPORT; \
echo -ne "${RED}Enter PostgreSQL Port Number (*:5432): "; read PGPORT; \
sed -i "s|CHTZ|${TZONE}|" .env && \
sed -i "s|CHUID|${UUID}|" .env && \
sed -i "s|CHGID|${GGID}|" .env && \
sed -i "s|CHSYN1|${SYNPORT}|" .env && \
sed -i "s|CHSYN2|${SYNSPORT}|" .env && \
sed -i "s|CHEW|${EWPORT}|" .env && \
sed -i "s|CHRP|${REDPORT}|" .env && \
sed -i "s|CHPSQL|${PGPORT}|" .env && \
sed -i "s|CHDOM|${MSDNAME}|" gen.sh && \
sed -i "s|CHUID|${UUID}|" gen.sh && \
sed -i "s|CHGID|${GGID}|" gen.sh && \
sed -i "s|CHDOM|${MSDNAME}|" element-config.json && \
sed -i "s|CHDOM|${MSDNAME}|" nginx/matrix.conf && \
sed -i "s|CHMSLIP|${MSLIP}|" nginx/matrix.conf && \
sed -i "s|CHSYN1|${SYNPORT}|" nginx/matrix.conf && \
sed -i "s|CHDOM|${MSDNAME}|" nginx/www/.well-known/matrix/client && \
sed -i "s|CHDOM|${MSDNAME}|" nginx/www/.well-known/matrix/server && \
REDIS_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 32); sed -i "s|CHPWR|${REDIS_PASSWORD}|" .env && \
echo | tr -dc A-Za-z0-9 </dev/urandom | head -c 63 > secrets/db_password.secret && \
sudo chown -R root:root secrets/ && \
sudo chmod -R 600 secrets/ && \
rm README.md && \
chmod +x gen.sh && \
./gen.sh && \
wait
while true; do
    read -p "Open homeserver.yaml to finish setup? (y/n)" yn
    case $yn in
        [Yy]* ) sudo nano synapse/homeserver.yaml; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
