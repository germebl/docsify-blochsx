# Creating an Ed25519 SSH Key on Windows

1. Download and install OpenSSH for Windows:
   - Visit the official OpenSSH website: https://github.com/PowerShell/Win32-OpenSSH/releases
   - Download the latest release package for Windows.
   - Extract the downloaded package to a directory of your choice.

2. Open a command prompt:
   - Press Win+R, type "cmd," and hit Enter to open a command prompt.

3. Navigate to the directory where you extracted OpenSSH:
   - Use the "cd" command to navigate to the directory where you extracted OpenSSH in step 1. For example:
     ```
     cd C:\path\to\OpenSSH
     ```

4. Generate the Ed25519 SSH key pair:
   - In the command prompt, run the following command:
     ```
     ssh-keygen.exe -t ed25519
     ```
   - It will prompt you to enter a file name to save the key. You can press Enter to accept the default location or specify a custom path.

5. Enter a passphrase (optional):
   - It's recommended to enter a passphrase to secure your private key. This passphrase will be required every time you use the key.
   - Type a passphrase or press Enter to skip it. Be aware that skipping the passphrase eliminates an extra layer of security.

6. Key generation process:
   - OpenSSH will generate the public and private keys and display the key fingerprint.

7. Locate your SSH keys:
   - By default, the public key will be saved as "id_ed25519.pub" and the private key as "id_ed25519" in the `%USERPROFILE%/.ssh` directory.

# Creating an Ed25519 SSH Key on Linux

1. Open a terminal:
   - Press Ctrl+Alt+T or search for "Terminal" in your distribution's application launcher.

2. Generate the Ed25519 SSH key pair:
   - In the terminal, run the following command:
     ```
     ssh-keygen -t ed25519
     ```
   - It will prompt you to enter a file name to save the key. You can press Enter to accept the default location or specify a custom path.

3. Enter a passphrase (optional):
   - It's recommended to enter a passphrase to secure your private key. This passphrase will be required every time you use the key.
   - Type a passphrase or press Enter to skip it. Be aware that skipping the passphrase eliminates an extra layer of security.

4. Key generation process:
   - OpenSSH will generate the public and private keys and display the key fingerprint.

5. Locate your SSH keys:
   - By default, the public key will be saved as "id_ed25519.pub" and the private key as "id_ed25519" in the `~/.ssh` directory.

Once you have generated your Ed25519 SSH key pair, you can use the public key for SSH authentication on remote servers by adding it to the appropriate `authorized_keys` file. Remember to keep your private key secure and never share it with anyone.