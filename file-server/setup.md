#  File Server Setup

## Overview

This file server was configured to simulate a real enterprise environment with controlled access based on user roles and departments.

The objective is to:
- Centralize data storage
- Apply secure access control (with the principle of least privilege PoLP)
- Reflect real-world Active Directory practices

---

##  Server Configuration

- Server Name: FS01  
- Role: File Server  
- Domain: corp.local  

The server is joined to the domain and managed through Active Directory.

---

## Roles and Features Installation

The File Server role was installed using Sever Manager.

### Steps

- Open Server Manager
- Click Add Roles and Features
- Select Role-Based or feature-based installation
  <img width="1145" height="806" alt="rolebaseselect" src="https://github.com/user-attachments/assets/1e5161ce-cba1-42c4-bfcf-8a72136861d9" />

- Choose server FS01
  <img width="1146" height="706" alt="select sever" src="https://github.com/user-attachments/assets/04e64c11-e095-4c19-bff9-b3d2fa7b5589" />

- Select role : File and Storage Services -> File Server
<img width="1174" height="794" alt="fileandstorageblabla" src="https://github.com/user-attachments/assets/aee71672-619f-4651-b62c-9906a28125eb" />

- Complete the installation

This enables SMB file sharing capabilities on the server.

---

## SMB Configuration

SMB (Server Message Block) is used to provide network access to shared folders.

- Protocol: SMB  
- Share Path: `\\FS01\HR`

  <img width="1235" height="831" alt="smbconfig" src="https://github.com/user-attachments/assets/ec9b5a15-eb36-41a2-a736-1959bc5ca79f" />


This allows domain users to access the file server over the local network.


---

## Share Folder Structure

We are focusing on the HR department permissions on this documentation, but the rest of the folders shared have the exact same structure and follow
the same principles.


<img width="1616" height="526" alt="mermaid-diagram" src="https://github.com/user-attachments/assets/5cef3dd4-9530-4d7b-9a4c-9eb19d67b332" />

