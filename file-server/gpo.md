#  Group Policy (GPO) Configuration

## Overview

This section describes how Group Policy Objects (GPOs) are used to automate configuration and enforce consistency across the environment

The main goal is to:
- Automatically map network drives
- Apply configurations based on user roles
---

##  GPO Strategy

GPOs are applied based on Organizational Units (OUs) and security groups.

This allows:
- Centralized management
- Role-based configuration
- Scalability across departments (for now, HR department)

---

## GPO: Drive Mapping HR

### General Information

- GPO Name: `Drive Mapping HR`
- Linked to: `HR OU`
- Scope: User Configuration
- Purpose: Automatically map the HR shared drive
- 
<img width="1246" height="873" alt="ouestlagpo" src="https://github.com/user-attachments/assets/ddaae498-55ab-4637-960d-faee8d2d18b6" />

---

##  GPO Link

The GPO is linked to:

- `corp.local/Staff/HR`

This ensures that only users within the HR department receive the policy.

---

##  Security Filtering

The GPO is filtered using security groups:

- `HR_Users`
- `HR_Admin`

Only members of these groups will receive the GPO.


<img width="1213" height="851" alt="lagpodisplay" src="https://github.com/user-attachments/assets/95637989-1702-40eb-ac6a-878b7c6d5c10" />

---

##  Item-Level Targeting

Item-level targeting is configured on the drive mapping to ensure that the H: drive is only applied to users who actually have access to the HR share.

### Configuration

The drive is mapped only if the user is a member of one of the following groups:

- `HR_RO` (read-only access)
- `HR_RW` (read/write access)

Logical condition:

HR_RO OR HR_RW

##  Why this is used in this setup

In this lab, access to the HR shared folder is not granted directly to users, but through permission groups:

- `HR_RO` → read access to HR data
- `HR_RW` → modify access to HR data

These groups are populated through role-based groups:

- `HR_Users` → member of `HR_RO`
- `HR_Admin` → member of `HR_RW`

This creates the following chain:

User -> Role Group -> Permission Group -> Folder Access

<img width="1316" height="873" alt="yartgeting" src="https://github.com/user-attachments/assets/a979a4e1-9949-4769-8a46-7a249a133783" />

---

## Purpose

This targeting ensures that:

- Only users who actually have NTFS permissions receive the mapped drive
- Users outside of HR never see the H: drive
- The drive mapping is aligned with real access control

Without targeting, the drive could be assigned to users who do not have access, resulting in confusion or access errors.

---

## Design Benefit

This approach reflects a real enterprise design where:

- GPO controls *distribution* of the drive
- Item-level targeting controls *who receives it*
- NTFS permissions control *what users can do*

This separation improves:

- Clarity of access control
- Troubleshooting (GPO vs permissions)
- Scalability when adding new roles or departments

---

## Example

- A standard HR user:
  - Member of `HR_Users` → `HR_RO`
  - Receives the H: drive
  - Has read-only or limited access

- An HR administrator:
  - Member of `HR_Admin` → `HR_RW`
  - Receives the H: drive
  - Has write access

- A non-HR user:
  - Not in `HR_RO` or `HR_RW`
  - Does not receive the drive

##  Drive Mapping Configuration

To configure the GPO :
Path:
User Configuration -> Preferences-> Windows Settings -> Drive Maps

The following settings are configured:

- Action: Create
- Location: `\\FS01\HR`
- Drive Letter: `H:`
- Reconnect: Enabled
- Label: `HR Share`


---

## GPO Processing

The GPO is applied during user logon.

Manual update can be triggered with:

gpupdate /force

Verification can be done using:
gpresult /r


<img width="884" height="514" alt="appliedgrouppolicyadmin" src="https://github.com/user-attachments/assets/bc1b83a2-fb4f-49f5-95c3-afdf30e7e665" />


---

##  Testing & Validation

### HR User

- Drive H: mapped automatically → OK  
- Access HR\General → OK  
- Access HR\Admin → Denied  

---

### HR Admin

- Drive H: mapped automatically → OK  
- Full access → OK  
<img width="852" height="637" alt="driveHadmin" src="https://github.com/user-attachments/assets/f677bf12-f094-42c6-a4c0-c6b6465b1ff3" />
<img width="1216" height="832" alt="fullaccess" src="https://github.com/user-attachments/assets/dc8bf19b-4e0c-4838-9c39-c2f5c0664c64" />

---

## Design Principles

### Automation

Users do not need to manually map drives.

---

### Role-Based Access

Drive access is controlled through security groups.

---

### Scalability

New users automatically receive the correct configuration when added to the appropriate groups.

---

##  Important Note

- GPO is applied to users (not computers)

---

##  Design Approach (Why did I design it this way ?)

At first glance, OU linking, security filtering, and item-level targeting may seem redundant.

However, each layer serves a different purpose:

- OU linking defines the logical scope (department level) (This answers to the question : Who is this GPO about?)
- Security filtering controls which users receive the GPO (This answers to the question: Among HR Users, who receive this GPO?)
- Item-level targeting refines who actually gets the configuration (This answers to the question: Even if you receive this GPO, do YOU have to get this drive?)
- NTFS permissions enforce the final access control 

This layered approach reflects real enterprise environments where configuration, targeting, and security are separated for clarity and scalability.

While a simpler setup could achieve similar results, this design improves:
- User experience (avoiding unnecessary access errors)
- Troubleshooting (clear separation of responsibilities)
- Flexibility for future expansion
  
--- 

## Troubleshooting

Common issues and checks:

- Drive not mapping:
  - Check group membership (whoami /groups)
  - Check GPO applied (gpresult /r)
  - Check network path accessibility (\\FS01\HR)

- Access denied:
  - Verify NTFS permissions
  - Verify user is in HR_RO or HR_RW

- GPO not applied:
  - Check OU placement
  - Check security filtering

---

##  Future Improvements

- Add drive mapping for other departments  
- Implement additional GPOs (security baseline)  
- Apply login scripts for advanced automation  

