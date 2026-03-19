# RDP Access Issue – User Unable to Log In

## Problem

The sysadmin account was unable to connect to the Domain Controller (DC01) using Remote Desktop.

Error message indicated that the user did not have the required permissions to log in via Remote Desktop Services.

---

## Root Cause

By default, only members of the local "Administrators" group are allowed to log in via RDP on a Domain Controller.

The user was part of a custom security group (IT_Admins) but this group was not granted the "Allow log on through Remote Desktop Services" right.

---

## Solution

Configured a Group Policy Object (GPO) to allow the IT_Admins group to log in via RDP.

### Steps:

1. Open Group Policy Management
2. Edit **Default Domain Controllers Policy**
3. Navigate to:
   Computer Configuration → Policies → Windows Settings → Security Settings → Local Policies → User Rights Assignment
4. Edit:
   **Allow log on through Remote Desktop Services**
5. Add group:
   `CORP\IT_Admins`
6. Apply changes and run:

```bash
gpupdate /force

```
## Result

My admin user account was able to successfully log in to the DC via RDP.

## To keep in mind

- DCs have stricter default security policies
- RDP access is controlled via User Rights Assignments in GPO
- Security groups must be explicitely granted logon rights
- Changes require policy refresh with gpupdate /force
- GPO must be applied to groups and not users alone


## Screenshots

### 1. RDP access denied error
<img src="https://github.com/user-attachments/assets/a7b137b7-ea03-46f4-afeb-1167cc81518a" width="700"/>

My admin user account is denied access because they do not have the "Allow log on through Remote Desktop Services" right.

---

### 2. GPO configuration interface
<img src="https://github.com/user-attachments/assets/874d4dee-1d99-4549-a1d2-da4927600598" width="700"/>

Editing the Default Domain Controllers Policy to configure user rights.

---

### 3. Adding IT_Admins group to RDP policy
<img src="https://github.com/user-attachments/assets/e0d4391d-384f-4ced-894b-1ecdcd7656ba" width="700"/>

The security group CORP\IT_Admins is added to the policy.

---

### 4. Group Policy update
<img src="https://github.com/user-attachments/assets/ce7159cc-6e8f-439c-86b6-95748be2946f" width="700"/>

Forcing policy update using gpupdate /force.

---

### 5. Successful RDP connection
<img src="https://github.com/user-attachments/assets/d8a7ce7c-6f9e-4ebf-b1c8-7bcd8cbb2fc0" width="700"/>

User successfully logs into the Domain Controller after policy application.

