# Matrix
An open network for secure, decentralized communication
  
---
  
Edit: `synapse/homeserver.yaml`:
  
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
    user: <db_user from secrets>
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

View logs for errors.

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
  
Use for the Reverse Proxy to handle incomming HTTPS connections and forward them to the correct Docker containers,
also to automatically fetch and renew Let's Encrypt certificates.

To allow anyone to register an account set 'enable_registration' to true in the homeserver.yaml.
This is NOT recomended. (?)
