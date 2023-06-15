# Setup the Base Server

This guide will walk you through the necessary preparations for configuring a basic Linux Debian 12 system. The setup will include some essential security measures and basic configurations and should be the template for all of our servers.

## 1. Order & rDNS

First, order a server on the hetzner cloud. It should have the specifications from the general readme. Choose your specifications in order of the list. While ordering i'll recommend to choose a good location for your project. Next important thing is to choose *Debian 12* as operating system.

?> If its your first server you will order, please activate "private network" on the "Networking" step and create the following network:
  name: (optional)
  network-zone: (fits to your server location)
  ip-area: 192.168.0.0 / 24

If you already have your own ssh-key (i'll recommend to use ed25519) you can add the ssh-key to use with your server. If you did not have any ssh-key, please create one. You can [check here](/other/create-ssh-key.md) how to do it.

After you created the ssh-key please add it within the SSH-Keys section and select it to install the server directly with your ssh-key.

?> You need to enter your public key.

When you come to the selection of the servers name, i absolutely recommend to choose the FQHN (Fully qualified hostname) like we described in the specification section on the general readme. If you do this, your hostname of the server will set correctly without the need to change it later.

?> Anything not explicitly mentioned can be ignored during the ordering process.

You can now order your server.

After your server was delivered, go to the network tab of your server and setup the rDNS for IPv4 and IPv6. It will be the same as the hostname.

For IPv6 please use the `::1` address.

## 3. Connect to the server

On every setup like web, db, mail etc. it will be required to already be connected to your prepared base server. So we will now show once [how to connect to your server](/other/ssh-connect.md). Just follow the link.

?> If you are using windows, you can [check this tutorial](/other/install-openssh-windows.md) to install openSSH on Windows.


## 2. Update and Upgrade

Once the installation is complete, open a terminal and update the package lists and upgrade the system packages to the latest versions using the following commands:

```bash
apt update
 apt upgrade
```

## 3. Install Rsyslog
Rsyslog is an open source implementation of the syslog protocol for Unix and Unix-like systems. It extends the original syslogd model with content-based filtering, extensive deployment options for filters, flexible configuration options, and adds important features such as TCP as a transmission protocol.

We will install it, if its not already installed with:
```bash
apt install rsyslog
```

## 4. Firewall Configuration
To enhance the security of your system, configure the firewall to allow only necessary incoming connections. Use the following commands to install and configure the iptables firewall.

When you get asked if you want to save the actual rules of ipv4 and ipv6 rules, choose yes.

```bash
apt install iptables-persistent

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -j DROP

iptables -A INPUT -p tcp --dport 22 -j ACCEPT
ip6tables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -A INPUT -p icmpv6 -j ACCEPT
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -j DROP

iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6
```

?> Each setup has its own individual firewall settings. These allow all related and established connections, allow icmp incoming traffic, allow incoming traffic to the loopback interface and drop everything else. When we configure services we will add these rules before rule one, because iptables works in the order the rules are created.

!> As [when you are done with setup your VPN server](vpn.md) you really should change the rule for ssh. Actually we allow all ip addresses to connect with ssh. When you are done with setup your VPN server, you can change the access to port 22 from all to the wireguard vpn network (employee ip addresses when they connected to the vpn server) as follows:
1. Open the file /etc/iptables/rules.v4 with `nano /etc/iptables/rules.v4`
2. Replace the rule `-A INPUT -p tcp --dport 22 -j ACCEPT` with `-A INPUT -p tcp --dport 22 -s 10.0.0.0/24 -j ACCEPT`
3. Restore the IPv4 Rules with `iptables-restore /etc/iptables/rules.v4`

?> We do not allow the SSH port for IPv6 because our VPN uses IPv4 only in the company private network and a connection to the SSH should only be available to clients with a ip-address of the wireguard network. We use iptables-persistent to save the rules to files and restore them on every startup, so they don't get lost.

## 5. Securing SSH

Securing SSH (Secure Shell) is of paramount importance for any Linux system, including Linux Debian 12. SSH is a widely used protocol for remote access to servers and allows secure communication between a client and a server over an unsecured network.Here's a short introduction on why it's crucial to secure SSH:

1. **Protection against unauthorized access:** SSH is often targeted by malicious actors attempting to gain unauthorized access to systems. By securing SSH, you significantly reduce the risk of successful attacks such as brute-force password guessing or exploitation of vulnerabilities. This helps safeguard sensitive data, applications, and system resources from unauthorized access.

2. **Enhanced authentication mechanisms:** Implementing SSH security measures allows you to move away from password-based authentication, which is vulnerable to password cracking and brute-force attacks. By using SSH key-based authentication, you leverage asymmetric encryption, making it significantly more difficult for attackers to compromise your system. SSH keys provide a higher level of security, especially when combined with secure passphrase protection.

3. **Protection against network eavesdropping:** SSH encrypts the communication between the client and server, providing confidentiality and integrity for transmitted data. By securing SSH, you ensure that sensitive information, such as login credentials, is protected against network eavesdropping and potential data breaches.

4. **Mitigation of common attack vectors:** Securing SSH involves measures like changing the default SSH port, disabling root login, and configuring strong authentication methods. These actions help reduce exposure to automated bots scanning for default settings and common attack vectors. By customizing SSH configurations, you add an extra layer of protection and minimize the risk of successful attacks.

5. **Compliance with security best practices:** Secure SSH configurations align with security best practices and industry standards. By implementing these measures, you demonstrate a commitment to maintaining a secure system environment. This is particularly crucial if you handle sensitive data, are subject to regulatory requirements, or have a responsibility to protect customer information.

Overall, securing SSH is essential for safeguarding your Linux Debian 12 system from unauthorized access, data breaches, and other security threats. By implementing strong authentication mechanisms, encrypting communication, and following best practices, you significantly enhance the security posture of your system, ensuring the confidentiality, integrity, and availability of your data and resources.

Edit the SSH server configuration file using a text editor. The configuration file is located at `/etc/ssh/sshd_config`. Use the following command to open it:

```bash
less /etc/ssh/sshd_config
```

- Locate the following directives in the file:
  - `Port`: Specifies the SSH server port. Consider changing it to a non-standard port (e.g., 2222) to add an extra layer of security.
  - `PermitRootLogin`: By default, this directive is set to `yes`, allowing root login. Change it to `no` to disable root login via SSH.
  - `PasswordAuthentication`: Ensure this directive is set to `no` to disable password-based authentication and enforce the use of SSH keys (more secure).
  - `PubkeyAuthentication`: This option should be set to `yes` to enable public key authentication. It allows users to authenticate using SSH keys instead of passwords, providing a more secure authentication method.
  - `AuthorizedKeysFile`: Specifies the file that contains the authorized public keys for user authentication. The default value is `%h/.ssh/authorized_keys`, where `%h` represents the user's home directory. Make sure this file is properly configured and restricted to authorized keys only.
  - `ChallengeResponseAuthentication`: Set this directive to `no` to disable challenge-response password authentication. This authentication method is less secure than SSH keys and should be disabled unless specifically required.
  - `X11Forwarding`: Set this option to `no` if X11 forwarding is not necessary. X11 forwarding allows the forwarding of X Window System sessions over SSH, but it can pose security risks if not needed.
  - `LoginGraceTime`: Defines the time (in seconds) during which the user has to authenticate after establishing an SSH connection. Setting a low value (e.g., 30) reduces the window for potential attacks.
  - `PermitEmptyPasswords`: Set this option to `no` to disallow empty passwords for user authentication.
  - `MaxAuthTries`: Specifies the maximum number of authentication attempts permitted per connection. Setting a low value (e.g., 3) can help prevent brute-force attacks.

Write these changed lines to:
```bash
nano /etc/ssh/sshd_config.d/initial.conf
```

It should look like:
```bash
Port 22
PermitRootLogin yes
PasswordAuthentication no
PubkeyAuthentication yes
AuthorizedKeysFile %h/.ssh/authorized_keys
ChallengeResponseAuthentication no
X11Forwarding no
LoginGraceTime 30
PermitEmptyPasswords no
MaxAuthTries 3
```

Save the changes and exit the text editor (Ctrl + O, then Ctrl + X in Nano).
Restart the SSH service for the changes to take effect:

```bash
systemctl restart ssh
```

## 6. Fail2Ban Anti Bruteforce

Fail2Ban is an essential tool for enhancing the security of your server, particularly when it comes to SSH access. By configuring Fail2Ban with an SSH jail, you can effectively block failed login attempts with SSH.

Fail2Ban, with its SSH jail configuration, helps protect your server by detecting and blocking repeated failed login attempts. It monitors SSH logs, identifies IP addresses that exceed the allowed number of failed password authentication attempts, and automatically blocks them. This effectively mitigates the risk of unauthorized access and strengthens the overall security of your server.

First we need to install fail2ban:
```bash
apt install fail2ban
```

Open the Fail2Ban jail configuration file for SSH:
```bash
nano /etc/fail2ban/jail.d/sshd.conf
```

In the file, make sure the following settings are present or uncommented:
```bash
[sshd]
enabled   = true
mode      = aggressive
port      = ssh
logpath   = %(sshd_log)s
backend   = %(sshd_backend)s
bantime   = 43200m
findtime  = 10m
maxretry  = 3
```

So we block after 3 failed attempts within 10 minutes for 43200 minutes (30 days).

Save the changes and exit the text editor (Ctrl + O, then Ctrl + X in Nano).

Restart the Fail2Ban service to apply the changes:
```bash
systemctl restart fail2ban
```

When you call the status with `systemctl status fail2ban.service`you may get a warning that allowipv6 is not set. If this warning comes up, you can solve it with setup `allowipv6` within fail2ban.conf:

```bash
sed -i 's/#allowipv6 =/allowipv6 = auto/' /etc/fail2ban/fail2ban.conf
```

Restart the Fail2Ban service to apply the changes:
```bash
systemctl restart fail2ban
```

Fail2Ban's default SSH jail will handle blocking IP addresses for other types of SSH-related offenses, such as excessive authentication failures.

By following this tutorial, you can enhance the security of your Linux Debian server by effectively using Fail2Ban to block malicious login attempts and protect against unauthorized access through SSH.

## 7. DoS Protection Modules

Configuring Denial-of-Service (DoS) protection modules on Linux Debian servers is of utmost importance to safeguard the availability and stability of your system. DoS attacks aim to overwhelm your server's resources, rendering it inaccessible to legitimate users. By enabling DoS protection modules, you can proactively defend against such attacks and mitigate their impact.

DoS protection modules, such as TCP SYN cookies and connection tracking, provide crucial defense mechanisms. TCP SYN cookies help prevent SYN flood attacks by intelligently handling incoming connection requests, while connection tracking limits the number of simultaneous connections to prevent resource exhaustion.

By configuring these modules, you enhance your server's resilience against DoS attacks, ensuring its continued availability and optimal performance. Mitigating the risk of resource depletion helps maintain the responsiveness of your server, prevents service disruptions, and safeguards the user experience. Protecting your Linux Debian server with DoS protection modules is an essential step in maintaining a secure and reliable system.

Create a bew sysctl configuration file using a text editor:
```bash
nano /etc/sysctl.d/100-net.ipv4.tcp_syncookies.conf
```

In the file, look for the following lines or add them if they are not present:
```bash
net.ipv4.tcp_syncookies = 1
```
- The net.ipv4.tcp_syncookies = 1 line enables TCP SYN cookies. TCP SYN cookies help protect against SYN flood attacks, where an attacker floods the server with SYN packets to exhaust resources.

Apply the new sysctl settings by running the following command:
```bash
sysctl -p
```

This reloads the sysctl settings from the configuration file. The DoS protection modules are now enabled on your Debian server.

Now we can check if its visible by giving out all kernel parameters and grep for our recently set parameter:
```bash
sysctl -a | grep net.ipv4.tcp_syncookies
```

It should now show us `net.ipv4.tcp_syncookies = 1`into the terminal output.

By following these steps, you have enabled important DoS protection modules on your Debian server. TCP SYN cookies help protect against SYN flood attacks. These measures enhance the server's resilience to DoS attacks by mitigating their impact and preserving the availability and stability of your Debian system.

## 8. Prompt Customization
You can customize the prompt appearance to display useful information or personalize it according to your preferences. To modify the prompt, edit the PS1 variable in the ~/.bashrc file using a text editor:

```bash
nano ~/.bashrc
```

Find the line starting with `PS1=` and modify it according to your desired prompt format. Save the changes and exit the text editor. To apply the new prompt configuration, either restart the terminal or run the following command:

```bash
source ~/.bashrc
```

I'll recommend you to use the following PS1:
```bash
PS1='$(es=$?; if [ $es != 0 ]; then echo "\[\033[01;31m\]RC="$es" "; fi)\[\033[1;37m\]\[\033[01;36m\]\t\[\033[1;37m\]\[\033[01;34m\] \h\[\033[1;37m\] \[\033[01;33m\]\w\[\033[1;37m\] \[\033[01;0m\]\$ '
```

It will show you the following informations:
- the return-code of the last command
- the time of the command
- the hostname
- currect directory
- If root a `#`, otherwise a `$`

If you want to have that prompt to your user, the root user and all new created users, you need to edit the `PS1=`line in the following files either:
```bash
/etc/skel/.bashrc
/etc/bash.bashrc
/etc/profile
```

Be aware that there are maybe multiple lines for PS1= for different stylings. I'm using it everywhere.

## 9. Setting up Logration

Log rotation is a critical process for managing log files on a system. It ensures that logs are properly managed, preventing them from consuming excessive disk space and allowing for efficient log analysis. By configuring log rotation with the following settings:

- `rotate 14`: Ensures a reasonable number of log files are retained, in this case, logs will be kept for 14 days.
- `daily`: Rotates logs on a daily basis, ensuring log files are kept manageable and important log data is not lost.
- `compress`: Compresses rotated log files as `.tar.gz`, reducing disk space requirements for long-term log retention.
- `dateext`: Adds the date to the rotated log file names, simplifying log identification based on specific dates.

These configurations provide several benefits, including efficient log management, optimized storage, and convenient log analysis. Logs are retained for a specified period, rotated daily, compressed to save space, and easily identified by date. This ensures that your system's logs are well-maintained and readily available when needed.


1. Navigate to the logrotate configuration directory. The location may vary, but it's commonly found at `/etc/logrotate.d/`. Use the following command to change to that directory:

```bash
cd /etc/logrotate.d/
```

2. List all the logrotate configurations in the directory. You should see files named after the services or applications they correspond to. Use the following command to view the files:

```bash
ls
```

3. Open each logrotate configuration file using a text editor. For example, if you want to edit the configuration for a service named `myapp`, use the following command:

```bash
nano myapp
```

4. Inside the configuration file, locate the section that defines the log file you want to rotate. It typically starts with a line like `"/path/to/log/file"`. Make sure you're modifying the correct section for each log file.

Do not change any other options, cause they mostly needed for that specific type of logfile.
!> Only the "notifempty" and "delaycompress" can removed everywhere to have a daily compress.

5. Add or modify the following options within the log file section:
- `rotate 14`: This sets the number of log files to keep. Change the value to `14`.
- `daily`: This option ensures that logs are rotated daily.
- `compress`: Enables compression of rotated logs.
- `dateext`: This option adds the date to the rotated log file names.

Your log file section should look similar to this:
```bash
"/path/to/log/file" {
rotate 14
daily
compress
dateext
...
}
```

6. Save the changes and exit the text editor. In Nano, you can press `Ctrl + O` to save and `Ctrl + X` to exit.

7. Repeat steps 4-7 for each logrotate configuration file you want to modify.

8. Test the logrotate configurations to ensure they are working as expected. Run the following command:

!> Please check the `/etc/logrotate.conf` - maybe you need to change the defaults too, so logs like `wtmp` get rotated correctly. 

```bash
logrotate -vf /etc/logrotate.conf
```

This command applies the logrotate configurations and displays verbose output so you can check for any errors or warnings.

9. If the test completes successfully without any errors, you're done! The logrotate configurations have been updated. The logs will now be rotated daily, compressed as .tar.gz files, and include the date in their names. Logs will be retained for 14 days.

?> Remember to adjust the paths, log file names, and configuration options based on your specific setup.

At least we now delete the logs which where created by setup the server:
```bash
rm /var/log/cloud*
```