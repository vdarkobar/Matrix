<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud#self-hosted-cloud">Home</a>
  <br><br>
</p> 
  
# Matrix
An open network for secure, decentralized communication
  
---
  
Login to <a href="https://dash.cloudflare.com/">CloudFlare</a>, add *Subdomain* for your *Matrix* Server. 
```
    CNAME | matrix | @ (or example.com)
```
  
Add *Subdomain* for *Element-Web* client:
```
    CNAME | chat | @ (or example.com)
```
  
---
  
#### *Decide what you will use for*:
```
Time Zone, UID/GID ...
```
  
*Change Container names/Port numbers, before executing docker-compose up -d, if multiple instances are planed.*  
  
### *Run this command*:
```
RED='\033[0;31m'; echo -ne "${RED}Enter directory name: "; read NAME; mkdir -p "$NAME"; \
cd "$NAME" && git clone https://github.com/vdarkobar/Matrix.git . && \
chmod +x setup.sh && \
./setup.sh
```
  
Edit: *`synapse/homeserver.yaml`*:
  
Comment out sqlite database (*to be replaced with PostgreSQL*):
```
#database:
#  name: sqlite3
#  args:
#    database: /data/homeserver.db
```
  
Uncomment and edit values: 
```
database:
  name: psycopg2
  txn_limit: 10000
  args:
    user: db_user
    password: <db_password from secrets>
    database: synapse
    host: <postgres container name>
    port: 5432
    cp_min: 5
    cp_max: 10
```
  
Other important settings, uncomment/edit:
```
server_name: "matrix.example.com"
web_client_location: https://<subdomain-for-element-web>.example.com
public_baseurl: https://matrix.example.com/
serve_server_wellknown: true

redis:
  enabled: true
  host: redis
  port: 6379
  password: <redis-password-from-.env>
```
  
Deploy:
```
sudo docker-compose up -d
```
  
### Log:
```
sudo docker-compose logs synapse
sudo docker logs -tf --tail="50" synapse
``` 
  
To register new user(s):
  
access Docker shell:
```
sudo docker exec -it synapse bash
```
  
run the command and follow the on screen prompts:
```
register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
```
  
Type: `exit`, to leave the container's shell.
  
To allow anyone to register an account set 'enable_registration' to true in the homeserver.yaml.
This is NOT recomended. (?)
  
Individual <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/Matrix.md">files</a> already contained in the resitory.
