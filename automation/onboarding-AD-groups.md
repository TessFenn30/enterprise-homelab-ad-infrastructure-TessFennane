## Overview

This onboarding process simulates how a new employee is integrated into the system.

The goal is to:
- Ensure consistent access provisioning
- Reduce manual errors
- Apply role-based access control
- Improve efficiency for the IT department as the onboarding process can take some time
  and, some onboarding requests can sometimes arrive at the last minute.

Instead of manually assigning permissions, a template user is duplicated based on the role.

---

## Onboarding Steps

1. Select the appropriate template account (e.g. TPL_HR_Advisor)
2. Copy the user object

<img width="1200" height="824" alt="testmpierre" src="https://github.com/user-attachments/assets/b274cd73-7978-4b3e-b307-ef843ec14883" />

4. Update user details (name, username)

5. Move the user to the appropriate OU (e.g. Staff/HR)
   
<img width="1281" height="851" alt="copied manon now moving" src="https://github.com/user-attachments/assets/97cd6854-b4c3-4706-a3dc-ad176fcd98ba" />

  <img width="1236" height="830" alt="copyingfromtemplatesuccessful" src="https://github.com/user-attachments/assets/06d5ebb7-18d6-4440-9589-7e0779944021" />

6. Verify access:
   - Drive mapping (H:)
   - Folder permissions (HR\General / HR\Admin)
<img width="1219" height="881" alt="manonpierreuserdriveH" src="https://github.com/user-attachments/assets/d051d0ca-30ba-482a-9c82-4f7e0ec6da35" />

<img width="1195" height="865" alt="shecannotaccessadmin" src="https://github.com/user-attachments/assets/18f99a0a-7287-42c6-89b0-56c5fa3e1d70" />

<img width="1269" height="843" alt="butshecanaccessgeneral" src="https://github.com/user-attachments/assets/11e2d2cb-1db5-4398-afb7-b006df3a697d" />

## Limitations

- Risk of copying unintended permissions if the template account is not properly maintained
- Requires regular review of template accounts

## Future Improvements

The current onboarding process is manual but structured.

Future improvements include automating the process using PowerShell to:

- Create users dynamically
- Assign group memberships based on role
- Standardize onboarding across departments
- Reduce manual intervention and potential errors
- Implement logging for auditing and traceability
