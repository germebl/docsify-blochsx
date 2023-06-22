# Setup the Mattermost Chat Server

To have internal way to communicate with each other staff member of the company, have a way to inform the staff about company announcements, maintenances and have a alternative way as a newsletter (using a channel with news from, for and about the company) we will use mattermost. Mattermost is a collaboration chat software and the staff will be able to use it within the browser, as software on Windows, Linux and MacOS and further as apps on iOS and Android smartphones. In this case we will use the free "team" version.

## Prerequisites

- 1 node with [Debian 11 Base System](base.md)
- Percona xtraDB MySQL 8 Cluster with Loadbalancer

## Add the Mattermost Server PPA repository

Run the following command to add the Mattermost Server repositories:

```bash
curl -o- https://deb.packages.mattermost.com/repo-setup.sh | sudo bash -s mattermost
```

## Install Mattermost
Ahead of installing the Mattermost Server, it’s good practice to update all your repositories and, where required, update existing packages by running the following command:

```bash
sudo apt update
```

After any updates, and any system reboots, are complete, installing the Mattermost Server is now a single command:
```bash
sudo apt install mattermost -y
```

You now have the latest Mattermost Server version installed on your system.

## Create Mattermost Database

Connect to your MySQL 8 server cluster (i recommend to connect over the loadbalancer) and run:

```bash
mysql -u root -p
```

Enter the MySQL `root` user password. Now you should be connected to the MySQL server. After that we will create the `mattermost` database, the database user `mmuser` with a secure password and grant all needed permissions:

```sql
CREATE DATABASE mattermost;
CREATE USER 'mmuser'@'%' IDENTIFIED BY '<mmuser-password>';
GRANT  ALTER,  CREATE,  DELETE,  DROP,  INDEX,  INSERT,  SELECT,  UPDATE,  REFERENCES  ON  mattermost.*  TO  'mmuser'@'%';
```

- Replace `<mmuser-password>` with a strong password.

Your database is now ready to go. Please visit the MySQL 8 server cluster guide to check how to open the MySQL server port for the chat server.

## Configure Mattermost

The installation path is `/opt/mattermost`. The package will have added a user and group named mattermost. The required systemd unit file has also been created but will not be set to active.

Before you start the Mattermost Server, you need to edit the configuration file. A sample configuration file is located at `/opt/mattermost/config/config.defaults.json`.

Rename this configuration file with correct permissions:

```bash
sudo install -C -m 600 -o mattermost -g mattermost /opt/mattermost/config/config.defaults.json /opt/mattermost/config/config.json
```

Configure the following properties in this file:

Set `DriverName` to `mysql`.

Set `DataSource` to `mmuser:<mmuser-password>@<host-name-or-IP>/mattermost?charset=utf8mb4,utf8&collation=utf8mb4_0900_ai_ci` replacing `mmuser`, `<mmuser-password>`, `<host-name-or-IP>` and `mattermost` with your database name.

Set `SiteURL`: The domain name for the Mattermost application (e.g. https://chat.sudoers.biz).

After modifying the `config.json` configuration file, you can now start the Mattermost Server:

```bash
sudo systemctl start mattermost
```

Verify that Mattermost is running: `curl http://localhost:8065`. You should see the HTML that’s returned by the Mattermost Server.

The final step, depending on your requirements, is to run `systemctl enable mattermost.service` so that Mattermost will start on system boot.


## Update Mattermost

To update mattermost we just need to use the apt Package Manager:

```bash
apt-get --only-upgrade install mattermost
```

We really recommend to stop the service before you do the update:

```bash
systemctl stop mattermost.service
```