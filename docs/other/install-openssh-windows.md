# Installing OpenSSH on Windows

1. **Download and install OpenSSH for Windows**
   - Visit the official OpenSSH website: https://github.com/PowerShell/Win32-OpenSSH/releases
   - Download the latest release package for Windows.
   - Extract the downloaded package to a directory of your choice.

2. **Set OpenSSH as a Windows service**
   - Open a command prompt with administrator privileges.
   - Navigate to the directory where you extracted OpenSSH.
   - Run the following command to install OpenSSH as a Windows service:
     ```
     powershell.exe -ExecutionPolicy Bypass -File install-sshd.ps1
     ```

3. **Start the OpenSSH service**
   - In the command prompt, run the following command:
     ```
     net start sshd
     ```

4. **Confirm OpenSSH installation**
   - Open a new command prompt and run the following command:
     ```
     ssh -V
     ```
   - If OpenSSH is installed successfully, it will display the version information.

You can now proceed with connecting to your Linux Debian server using the steps provided above.