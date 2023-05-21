# Connect to a Linux Debian Server via SSH (Windows/Linux)

1. **Obtain the server's IP address**
   - You will need the IP address of the server you want to connect to. You can get it from the project overview in your [hetzner cloud console](https://console.hetzner.cloud) account.

1. **Obtain the server's IP address**
   - You will need the IP address of the Linux Debian server you want to connect to. This can typically be obtained from your server administrator or through a hosting provider.

2. **Open a terminal or command prompt**
   - On Windows, press Win+R, type "cmd," and hit Enter to open a command prompt.
   - On Linux, press Ctrl+Alt+T or search for "Terminal" in your distribution's application launcher.

3. **Connect to the server via SSH**
   - In the terminal or command prompt, run the following command:
     ```
     ssh -i /path/to/private_key username@server_ip_address
     ```
   - Replace `username` with your actual username on the server and `server_ip_address` with the IP address of the Linux Debian server. Replace `/path/to/private_key` with the path to your ssh private key.
   - If it's your first time connecting to the server, you will be prompted to confirm the server's fingerprint. Type "yes" and press Enter to proceed.
   - Then, you will be prompted to enter your passphrase. Type your passphrase and press Enter. Note that the passphrase characters won't be visible as you type for security reasons.

5. **Successfully connected**
   - If your username and SSH key are correct, you will be logged into the Linux Debian server via SSH.
   - You should see the server's command prompt or a welcome message indicating a successful connection.

6. **Disconnect from the server**
   - To disconnect from the server, simply type `exit` and press Enter. You will be logged out from the server and returned to your local machine's terminal or command prompt.

Connecting to a Linux Debian server via SSH allows you to remotely manage and administer the server. It provides a secure way to execute commands, transfer files, and perform various administrative tasks.

Make sure you have the necessary credentials (username and SSH key) to authenticate yourself and the server's IP address to establish the SSH connection.

