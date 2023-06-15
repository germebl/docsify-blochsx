# Setup the App Server (NGINX Reverse Proxy, Apache Webserver, PHP 8.2-FPM)

## LEGO: Wildcard SSL Certificates with our PowerDNS Nameservers
To obtain wildcard ssl certificates for our domains we will use the acme client "LEGO". It has a Provider for our PowerDNS nameservers, so we are able to get wildcard ssl certificates for our domains with the PowerDNS Provider in combination with our PowerDNS nameservers.

### Install LEGO
Lego is avaialble as source code from a GitHub Repository. We will need to compile it on our own to make it available - but thats not that hard. We will use GO to download and build it.

First install GO as required package:
```
apt install go
```

Then we just can use the following command to download and build the latest version of LEGO:
```
go install github.com/go-acme/lego/v4/cmd/lego@latest
```

### PowerDNS API Token
Now we need to obtain a PowerDNS API Token from our nameservers. Just visit the PowerDNS interface and follow the steps to get a API Token:
1. 
2. 
3. 
4. 
5. 
6. 

### Issue & Install Wildcard SSL Certificate

## Users & Directories
### Create Directories
### Create App-user
### Configure App-user

## ProFTPD SFTP Server
### Install ProFTPD
### Configure ProFTPD

## Apache Webserver
### Install Apache
### Configure Apache Ports
### Configure Default vHost

## NGINX Reverse Proxy
### Install NGINX
### Compile Brotli Compression
### Configure Rate Limits
### NGINX Server Banner
### Configure Default Server Block

## PHP 8.2-FPM
### Install PHP 8.2-FPM
### Configure Default Pool

## NodeJS & NPM
### Install NodeJS & NPM

## Firewall & Anti Brute-Force
## Hetzner Firewall
## IPTables Rules
## Fail2Ban

## Create an App
### 1. Create a App-User & Directorys
### 2. Get the Wildcard SSL Certificate
### 3. Create the PHP 8.2-FPM Pool
### 4. Create a Local Apache vHost
### 5. Create the NGINX Reverse Proxy
