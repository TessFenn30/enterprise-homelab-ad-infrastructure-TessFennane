# Enterprise Homelab – Active Directory Infrastructure

Simulated enterprise IT environment built from scratch using Active Directory, Group Policy, File Server and PowerShell automation.

This project is designed to replicate real-world IT infrastructure scenarios, focusing on access control, user lifecycle management, and enterprise-grade configuration.

---

## Project Overview

This homelab simulates a small company environment where users, departments, and resources are centrally managed.

It was built to move beyond theoretical knowledge and gain hands-on experience with real system administration tasks such as:

- Active Directory design
- Group Policy implementation
- File server deployment with secure permissions
- User onboarding (manual and automated)
- Troubleshooting real-world issues

---

## Environment Architecture

- Domain: `corp.local`
- Domain Controller: `DC01`
- File Server: `FS01`
- Clients: Windows 11 machines
- Network: `192.168.10.0/24`

### Components

- Active Directory Domain Services
- Organisational Units (OU) structured by departments
- Role-Based Access Control (RBAC)
- SMB File Server
- Group Policy Objects (GPO)
- PowerShell automation

See full topology: architecture/network-diagram.md

---

## Key Features

### Active Directory Design

- OU structure by department (HR, IT, Finance, Marketing, Sales)
- Separation between:
  - Users
  - Groups
  - Templates
- Scalable design aligned with enterprise environments

---

### Role-Based Access Control (RBAC)

Access is managed using a layered model:

User → Role Group → Permission Group → Resource


- No direct permissions assigned to users
- Full scalability and easier management


---

### File Server Deployment (FS01)

- Centralised storage using SMB (`\\FS01\HR`)
- NTFS permissions configured with least privilege principle
- Structured folder hierarchy:
  - HR\Admin (restricted)
  - HR\General (shared)

See setup in file-server/setup.md
See permissions in file-server/permissions.md

---

### Advanced Permission Model

- Separation between:
  - Business roles (`HR_Users`, `HR_Admin`)
  - Technical permissions (`HR_RO`, `HR_RW`)
- Nested group design for flexibility
- Fully aligned with enterprise best practices

---

### Group Policy (GPO)

Implemented multiple GPOs to automate and control the environment:

#### Drive Mapping

- Automatic mapping of `H:` drive
- Based on:
  - OU targeting
  - Security filtering
  - Item-level targeting

#### Access Control Example

- RDP access restricted via GPO to `IT_Admins`

See troubleshooting case in gpo/rdp-access.md

---

### User Onboarding Process

#### Manual Process

- Template-based user creation
- Consistent group membership and access

See process in automation/onboarding_manual.md

---

#### Automated Onboarding (PowerShell)

Custom PowerShell script that:

- Creates users dynamically
- Assigns group memberships
- Generates usernames and passwords
- Applies RBAC model automatically
- Logs every action for traceability

Features:

- Role-based template mapping
- Secure password generation
- Full logging (`C:\Logs`)
- Standardised user creation

See automation in automation/onboarding_automation_Powershell.md

---

## Troubleshooting Scenario

### RDP Access Issue (Domain Controller)

Problem:
- Admin user unable to log in via RDP

Root cause:
- Missing "Allow log on through Remote Desktop Services" permission

Solution:
- Fixed using Group Policy (User Rights Assignment)

Outcome:
- Successful secure access configuration

See full case in gpo/rdp-access.md

---

## Design Principles

- Least Privilege (PoLP)
- Role-Based Access Control (RBAC)
- Separation of responsibilities
- Scalability and maintainability
- Automation over manual processes
- Auditability and traceability

---

## Current Status

### Completed

- Active Directory domain
- OU and group structure
- RBAC model
- File server deployment
- NTFS permissions
- GPO (drive mapping + access control)
- Manual onboarding process
- Automated onboarding script

---

### In Progress

- Azure / hybrid integration
- Additional GPO security baseline
- Multi-department file server expansion
- Bulk onboarding (CSV)
- Monitoring and logging improvements

---

## Technologies Used

- Windows Server 2022
- Windows 11
- Active Directory
- Group Policy
- SMB / NTFS permissions
- PowerShell

---



---

## Screenshots

See individual documentation files for detailed screenshots and step-by-step configurations.

---

## Author

Tess Fennane  
IT Support & Infrastructure Engineer
