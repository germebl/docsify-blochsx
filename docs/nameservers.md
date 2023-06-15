# Setup Primary and Secondary PowerDNS Authoritative Nameservers
To have full control to our DNS zone and use the PowerDNS in combination with LEGO as SSL ACME Client for Wildcard SSL certificates we will install two authorative Nameservers with PowerDNS. These DNS server will sync their zones to each other so if one of them fails or get maintenance, our domain is still resolved from the other dns server.

## Prepare PowerDNS repository
To get the latest stable version of PowerDNS we will need to add the repository. But first we need to add the key of the repository:
```
curl https://repo.powerdns.com/FD380FBB-pub.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/powerdns.asc
```

Now we can add the repository:
```
echo "deb [arch=amd64] http://repo.powerdns.com/debian bullseye-auth-48 main" | tee /etc/apt/sources.list.d/pdns.list
```

So be sure that our debian systems uses this repository to get PowerDNS and not the default debian repository, we need to create a bin:
```
cat <<EOF> /etc/apt/preferences.d/pdns
Package: pdns-*
Pin: origin repo.powerdns.com
Pin-Priority: 600
EOF
```

Now we will update our package repository list:
```
apt get update
```

## Install PowerDNS and Requirements

After adding the repository we will start to install PowerDNS and all needed requirements:
```
apt install pdns-server pdns-backend-mysql pdns-tools
```

## Configure PowerDNS

Open the PowerDNS configuration file on both servers using a text editor:
```
nano /etc/powerdns/pdns.conf
```

Configure the following settings in the file:

Set the launch option to gmysql to enable the MySQL backend:
```
launch=gmysql
```

Set the MySQL database connection details:
```
gmysql-host=localhost
gmysql-user=root
gmysql-password=<YOUR_PASSWORD>
```
- Replace <YOUR_PASSWORD> with your desired password.

Enable DNSSEC by adding the following line:
```
gmysql-dnssec=on
```

Save and close the file.

## Set up MySQL
Install MySQL 8 on both servers and follow the prompts to set a root password:
```
apt install mysql-server
```

Create a new database for PowerDNS:
```
CREATE DATABASE powerdns;
```

Create a MySQL user for PowerDNS and grant it access to the database:
```
GRANT ALL PRIVILEGES ON powerdns.* TO 'powerdns'@'localhost' IDENTIFIED BY '<YOUR_PASSWORD>';
```
- Replace <YOUR_PASSWORD> with your desired password.


## Configure Zone Replication

Open the PowerDNS configuration file on both servers:
```
nano /etc/powerdns/pdns.conf
```
Uncomment or add the following line to allow zone transfers between the servers:
```
allow-axfr-ips=<IP_ADDRESS_OF_NS1>, <IP_ADDRESS_OF_NS2>
```
- Replace <IP_ADDRESS_OF_NS1> and <IP_ADDRESS_OF_NS2> with the respective IP addresses of the servers.

Save and close the file.

## Set up PowerDNS Web Interface (PowerDNS-Admin)

Follow the instructions to set up the PowerDNS Web Interface (PowerDNS-Admin) on one of the servers. Make sure to configure it to use the MySQL backend and provide the appropriate database connection details.

## DNS Zone Management

- Access the PowerDNS web interface by visiting http://<IP_ADDRESS_OF_SERVER>/admin in a web browser, replacing <IP_ADDRESS_OF_SERVER> with the actual IP address of the server where the web interface is set up.
- Log in to the web interface using your credentials.
- Configure the sudoers.biz domain and its zones using the web interface. You can add, modify, or delete DNS records as needed.