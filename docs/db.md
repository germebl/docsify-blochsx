# Install a Percona xtraDB MySQL 8 Cluster with Loadbalancing

Setting up a 3-node Percona XtraDB Cluster (PXC) allows you to create a highly available and scalable database environment. PXC is a high-performance, open-source MySQL clustering solution that leverages the Galera Replication Plugin for synchronous multi-master replication.

## Prerequisites

- 3 nodes (db-a, db-b, db-c) with [Debian 11 Base System](base.md)
- 1 loadbalancer (least connections algorithm)


## Firewalling

Here i will give you the IPTables Rules for each node. Be aware to replace the ip-addresses with your own.

1. Open the file `/etc/iptables/rules.v4` with `nano /etc/iptables/rules.v4`
2. Add the rules the selected node before the rule `-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT`
3. Save and Exit the file with CTRL+X and press `Y`, then `Enter`
4. Restore the rules with `iptables-restore < /etc/iptables/rules.v4`

### Replace the SSH rule (SSH via VPN only, all nodes!)
#### before /etc/iptables/rules.v4
`-A INPUT -p tcp --dport 22 -j ACCEPT`

#### after /etc/iptables/rules.v4
`-A INPUT -p tcp --dport 22 -s <PUBLIC-IP-VPN-SERVER> -j ACCEPT`

- Replace `<PUBLIC-IP-VPN-SERVER>` with the public ip address of the vpn server

#### Remove SSH rule from /etc/iptables/rules.v6
Because our VPN server will give the clients the IPv4 address only, we do not need to allow SSH via IPv6 anymore. So remove the following rule from the `/etc/iptables/rules.v6`file:

```bash
-A INPUT -p tcp --dport 22 -j ACCEPT
```

### db-a.sudoers.biz (192.168.0.3)
```
-A INPUT -p tcp --dport 3306 -s 192.168.0.15 -j ACCEPT
-A INPUT -p tcp --dport 3306 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 4444 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 4567 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 4568 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 3306 -s 192.168.0.5 -j ACCEPT
-A INPUT -p tcp --dport 4444 -s 192.168.0.5 -j ACCEPT
-A INPUT -p tcp --dport 4567 -s 192.168.0.5 -j ACCEPT
-A INPUT -p tcp --dport 4568 -s 192.168.0.5 -j ACCEPT
```

### db-b.sudoers.biz (192.168.0.4)
```
-A INPUT -p tcp --dport 3306 -s 192.168.0.15 -j ACCEPT
-A INPUT -p tcp --dport 3306 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 4444 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 4567 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 4568 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 3306 -s 192.168.0.5 -j ACCEPT
-A INPUT -p tcp --dport 4444 -s 192.168.0.5 -j ACCEPT
-A INPUT -p tcp --dport 4567 -s 192.168.0.5 -j ACCEPT
-A INPUT -p tcp --dport 4568 -s 192.168.0.5 -j ACCEPT
```

### db-c.sudoers.biz (192.168.0.5)
```
-A INPUT -p tcp --dport 3306 -s 192.168.0.15 -j ACCEPT
-A INPUT -p tcp --dport 3306 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 4444 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 4567 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 4568 -s 192.168.0.3 -j ACCEPT
-A INPUT -p tcp --dport 3306 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 4444 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 4567 -s 192.168.0.4 -j ACCEPT
-A INPUT -p tcp --dport 4568 -s 192.168.0.4 -j ACCEPT
```

### Reload the rules on each node
Now after changing the firewall rules, we will reload the rules on each node:
```bash
iptables-restore < /etc/iptables/rules.v4
ip6tables-restore < /etc/iptables/rules.v6
```

## Install from Repository

1. Update the sytem:

    ```bash
    apt update
    ```

2. Install the necessary packages:

    ```bash
    apt install -y wget gnupg2 lsb-release curl
    ```

3. Download the repository package

    ```bash
    wget https://repo.percona.com/apt/percona-release_latest.generic_all.deb
    ```

4. Install the package with `dpkg`:

    ```bash
    dpkg -i percona-release_latest.generic_all.deb
    ```

5. Refresh the local cache to update the package information:

    ```bash
    apt update
    ```

6. Enable the `release` repository for *Percona XtraDB Cluster*:

    ```bash
    percona-release setup pxc80
    ```

7. Install the cluster:

    ```bash
    apt install -y percona-xtradb-cluster
    ```

During the installation, you are requested to provide a password for the `root` user on the database node.


## Stopping the MySQL Service

After you install Percona XtraDB Cluster stop the `mysql` service on all nodes:

```bash
systemctl stop mysql.service
```

## Changing the DataDir

Because our servers hasnt that much storage, we will need on each node a own SSD Volume from the Hetzner Cloud Console. For the tutorial we go to the Hetzner Cloud Console and create 3 volumes with each 10 GB storage in EXT4 format and automatically mount.

After that, we will move the actual data directory of mysql to a backup directory and recreate it:
```bash
mv /var/lib/mysql /var/lib/mysql.bak
mkdir /var/lib/mysql
```

Then we need to edit the fstab:
```bash
nano /etc/fstab
```

Here you will now find a entry like this:
```bash
/dev/disk/by-id/scsi-0HC_Volume_33591309 /mnt/HC_Volume_33591309 ext4 discard,nofail,defaults 0 0
```

We now change the directory of the destination `/mnt/HC_Volume_33591309`to the location of the mysql data directory. Its should look like this:
```bash
/dev/disk/by-id/scsi-0HC_Volume_33591309 /var/lib/mysql ext4 discard,nofail,defaults 0 0
```

Save and Exit the file and reload the mount:
```bash
mount -a
```

Now we remove the `lost+found` folder from the mounted directory:
```bash
rm -r /var/lib/mysql/*
```

After that steps are done, we can now move back the files from the datadir to the new datadir and delete the old folder:
```bash
mv /var/lib/mysql.bak/* /var/lib/mysql
rm -r /var/lib/mysql.bak
```

Do not forget to change the owner and group of the newly created folder to mysql:
```bash
chown -R mysql:mysql /var/lib/mysql
```


## Editing configuration of db-a

Edit the configuration file of the `db-a` to provide the cluster settings.

```bash
nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

```bash
wsrep_provider=/usr/lib/galera4/libgalera_smm.so
wsrep_cluster_name=pxc-cluster
wsrep_cluster_address=gcomm://192.168.0.3,192.168.0.4,192.168.0.5
```

## Configure db-a

Now we will configure the needed settings for the first node

```bash
nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

```bash
wsrep_node_name=db-a
wsrep_node_address=192.168.0.3
pxc_strict_mode=ENFORCING
```

## Configure the other nodes (db-b & db-c)

4. Set up `db-b` and `db-c` in the same way: Stop the server, mount the volume as datadir and update the configuration file applicable to your system. All settings are the same except for `wsrep_node_name` and `wsrep_node_address`.

    For `db-b`

        wsrep_node_name=db-b
        wsrep_node_address=192.168.0.4

    For `db-c`

        wsrep_node_name=db-c
        wsrep_node_address=192.168.0.5

## Set up the traffic encryption settings on all nodes

Each node of the cluster must use the same SSL certificates.

```bash
nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

```bash
[mysqld]
wsrep_provider_options="socket.ssl=ON;socket.ssl_key=server-key.pem;socket.ssl_cert=server-cert.pem;socket.ssl_ca=ca.pem"

[sst]
encrypt=4
ssl-key=server-key.pem
ssl-ca=ca.pem
ssl-cert=server-cert.pem
```

## Copy .PEM Files

Before we can bootstrap our first node, we need to copy the .PEM files from our first node to the other nodes, so they can use the correct SSL files to connect.

On your first node `db-a` create a new SSH key:
```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "pxc"
```

You do not need to add a passphrase, but i'll recommend to.

Now get the public key:
```bash
cat /root/.ssh/id_ed25519.pub
```

Now add this public key to the following file on `db-b` and `db-c`:
```bash
nano /root/.ssh/authorized_keys
```

!> After we are done i would recommend to remove this public keys from `db-b` and `db-c`, further to remove the `id_ed25519` and `id_ed25519.pub` file from the `db-a`.

Now we will transfer the needed SSL certificate files from `db-a` to `db-b` and `db-c`. So call this command on `db-a`:
```bash
scp /var/lib/mysql/*.pem 192.168.0.4:/var/lib/mysql/
scp /var/lib/mysql/*.pem 192.168.0.5:/var/lib/mysql/
```

- Replace the ip-addresses if you use another one. They should be the ipv4 addresses of `db-b` and `db-c`.


## Bootstrap the first node

After you configured all PXC nodes, initialize the cluster by bootstrapping the first node.  The initial node must contain all the data that you want to be replicated to other nodes.

Bootstrapping implies starting the first node without any known cluster addresses: if the `wsrep_cluster_address` variable is empty, Percona XtraDB Cluster assumes that this is the first node and initializes the cluster.

Instead of changing the configuration, start the first node using the following
command:

```bash
systemctl start mysql@bootstrap.service
```

When you start the node using the previous command, it runs in bootstrap mode with `wsrep_cluster_address=gcomm://`. This tells the node to initialize the cluster with `wsrep_cluster_conf_id` variable set to `1`.

## Adding the second and third node (db-b & db-c)

Start the second node using the following command:

```bash
systemctl start mysql
```

After the server starts, it receives SST automatically.

To check the status of the second node, run the following within mysql:

```sql
show status like 'wsrep%';
```

The output of `SHOW STATUS` shows that the new node has been successfully added to the cluster.  The cluster size is now 2 nodes, it is the primary component, and it is fully connected and ready to receive write-set replication.

If the state of the second node is `Synced` as in the previous example, then the node received full SST is synchronized with the cluster, and you can proceed to add the third node (db-c).

## Restart the first node (db-a)

When everything is done, we can now restart the Node to run normally and not within the bootstraped mode:

```bash
systemctl stop mysql@bootstrap.service
systemctl enable --now mysql.service
```

?> When at any time you stop the full cluster - so all nodes at the same time, you need to bootstrap again!

# Verify replication

Use the following procedure to verify replication by creating a new database on the second node, creating a table for that database on the third node, and adding some records to the table on the first node.

1. Create a new database on the second node (`db-b`):

    ```sql
    CREATE DATABASE percona;
    ```

2. Switch to a newly created database on the third node (`db-c`):

    ```sql
    USE percona;
    ```

3. Create a table on the third node (`db-c`):

    ```sql
    CREATE TABLE example (node_id INT PRIMARY KEY, node_name VARCHAR(30));
    ```

4. Insert records on the first node (`db-a`):

    ```sql
    INSERT INTO percona.example VALUES (1, 'percona1');
    ```

5. Retrieve rows from that table on the second node (`db-a`):

    ```sql
    SELECT * FROM percona.example;
    ```

If the commands from 1.-5. responded with `Query OK` its looking fine. Within step 5 you should then see the rows without errors displayed. If that is true, everything worked like a charme.

## Loadbalancing

So when we have Applications on our servers, we cant add multiple mysql servers and they loadbalancing on their own. For that we need the loadbalancer from the Hetzner Cloud with `least connection`algorithm.

Add this loadbalancer with the name `db.sudoers.biz`. Add the 3 nodes (`db-a`, `db-b`, `db-c`) as server targets to the loadbalancer. After that create a service with port `3306`as source and port `3306` as target. 

!> It's important that you create the Loadbalancer with the private network connected. When setting up the service the loadbalancer should connect to the private network of the database servers and not to the public ip address.

Your Loadbalancer is ready to go. When you setup applications use the ip address or the dns-hostname we will setup now as the host and port `3306` as port. Also when you want to connect with like the `root` user to the cluster to create users, databases or something else, just use the ip address/dns-hostname of the loadbalancer. It will replicate everything you do synchronous the other nodes.