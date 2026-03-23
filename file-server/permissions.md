#  File Server Permissions

## Overview

This section describes how access control is implemented on the file server using NTFS permissions and Active Directory security groups.

The objective is to:
- Control access based on user roles
- Protect sensitive data
- Follow enterprise best practices

---

##  Access Control Model

Access is not assigned directly to users.

Instead, a layered model is used:

Users → Groups → Permissions

It allows easier management and scalability.

---

##  Security Groups

### Business Role Groups

| Group     | Purpose              |
|----------|--------------------|
| HR_Users | Standard HR users   |
| HR_Admin | HR administrators  |

### Permission Groups

| Group   | Purpose                  |
|--------|--------------------------|
| HR_RW  | Read/Write access        |
| HR_RO  | Read-only access (future)|

---

## Group Relationship

HR_Admin → member of HR_RW
HR_Users → (not in HR_RW by default)

This allows flexibility in granting permissions.


---

##  NTFS Permissions Structure

### Root Folder: C:\Shares\HR

| Group      | Permission     |
|-----------|---------------|
| HR_RW     | Modify        |
| HR_Admin  | Full Control  |
| IT_Admins | Full Control  |
| SYSTEM    | Full Control  |

---

### Subfolder: HR\Admin

| Group     | Permission    |
|----------|--------------|
| HR_Admin | Full Control |
| HR_Users | No Access    |

This folder contains sensitive HR data and is restricted.

---

### Subfolder: HR\General

| Group     | Permission        |
|----------|------------------|
| HR_Users | Read / Write     |
| HR_Admin | Full Control     |

This folder is accessible to all HR users.

---

##  Design Principles

### Least Privilege

Users only receive the minimum access required to perform their tasks.

---

### Role Separation

Business roles (HR_Admin, HR_Users) are separated from technical permissions (HR_RW).

---

### Scalability

Access can be modified by updating group membership instead of changing permissions directly.

Example:

Add user -> HR_RW -> gains write access instantly


---

##  Important Notes

- Permissions are never assigned directly to users (not scalable for a large amount of users)
- NTFS permissions are used instead of share permissions for control
- Security groups are used to simplify management

---

##  Validation

### HR User

- Access HR\General → OK

  <img width="1251" height="877" alt="buthecanaccessgeneral" src="https://github.com/user-attachments/assets/463fea4b-3554-4c07-a5d8-957d2414dc9b" />

- Access HR\Admin → Denied  
<img width="1172" height="850" alt="normaluserdeniedaccess" src="https://github.com/user-attachments/assets/b0f3f953-9be6-4849-9a4e-6627f39b61d0" />

---

### HR Admin

- Full access to all folders → OK  

---

##  Future Improvements

- Implement HR_RO for read-only scenarios  
- Add auditing (file access tracking)  
- Apply similar structure to other departments  



