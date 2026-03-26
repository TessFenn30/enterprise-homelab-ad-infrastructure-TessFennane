# Automated User Onboarding (on AD)

## Overview

The aim of creating the role templates in AD was to facilitate the user automation in AD (especially with the group memberships).
This Powershell script uses the work described in onboarding_manual.md, automating the creation of Active Directory users.

It standardises the onboarding process by:

- Creating users dynamically
- Assigning permissions based on predefined templates
- Ensuring consistency across the environment
- Providing detailed logging for traceability

---

## How does it work?

The script requires three inputs : .\onboarding.ps1 -FirstName "Donna" -LastName "Despres" -JobTitle "HR Advisor"

--- 

## Script Process

- Detects the current Active Directory domain
- Maps the job title to a template account
- Retrieves the template user from AD
- Extracts the department from the OU structure
- Generates a unique username (first letter of the first name + last name , e.g ddespres)
- Generates a secure temporary password
- Creates the user account
- Copies group memberships from the template
- Moves the user to the correct department OU
- Logs every step to a file

---

## Security considerations

- The passwords are generated dynamically and can be transmitted directly to the new starter via the manager/the IT department.
- The user has to change their password at first logon.
- We use group-based access control (no direct user permissions).
- We keep the detailed logs of each AD User onboarding with timestamp locally on the DC (consideration of backup of these files for future improvements)

---

## Logging

A detailed log file is generated for each execution: C:\Logs\onboarding_<timestamp> <user>.txt

Each step is logged with:
- timestamp
- status (INFO / SUCCESS / WARNING / ERROR)
- detailed message

This ensures:
- traceability
- easier troubleshooting
- audit visibility
---

## Advantages

All users are created following the same logic:
- consistent naming convention
- consistent access model
- standardised structure
- Reduced human error

Manual mistakes are minimised:
- no forgotten group memberships
- no incorrect permissions
- no inconsistent configurations
- Scalability

The system scales easily:
- adding a new role only requires a new template
- no need to modify the core script
- Alignment with enterprise practices
- Role-Based Access Control (RBAC)
- Group-based permission management
- Separation between templates and production users
- Full traceability

Every onboarding action is logged, making it easier to:
- troubleshoot issues
- review actions
- simulate audit scenarios

---

## Limitations 

### Static role mapping

For now, the script relies on a hardcoded mapping:

$TemplateMap = @{
    "HR Advisor" = "tpl.hr.advisor"
}

It requires manual updates when new roles are added.
Possible improvement: dynamically discover templates from AD.

### Dependency on AD structure

The script assumes a strict OU structure which may break if it changes.

OU=Templates
    └── OU=Department
OU=Staff
    └── OU=Department

--- 

### No approval workflow

The script executes immediately without any validation step and no integration with HR systems.

---

### Password exposure

The password is displayed in clear text on the powershell terminal. 
It is acceptable in a lab context but not for prod environments.
We might want to consider a more secure delivery (self-service password setup).

---
### No rollback mechanism 

If a step fails during execution : the user might be partially configured and there is no automatic cleanup or rollback.

---

## Future Improvements

- Dynamic template discovery
- Bulk onboarding via CSV
- Integration with Azure AD (hybrid environment)
- Secure password delivery
- Centralised logging + backup (event logs or SIEM)
- Improved error handling with rollback mechanisms



