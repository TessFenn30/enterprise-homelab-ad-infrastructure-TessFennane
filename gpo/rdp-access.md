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


