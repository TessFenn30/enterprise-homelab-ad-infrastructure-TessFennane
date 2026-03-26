# Users and Groups

## Overview

This section describes how users and security groups are structured within the Active Directory environment.

The goal is to simulate a real enterprise setup where access is managed through Role-Based Access Control (RBAC), ensuring scalability, consistency, and security.

---

## Users

Test users were created to represent employees across departments.
Including but not exclusively :
- `tfennane`
- `zrobaii`
- `soussman`

These accounts are used to:

- Validate access to shared resources
- Test Group Policy application
- Simulate real-world user behaviour in a domain environment

---

## Group Design

Instead of assigning permissions directly to users, a structured group-based model is used.

### Role Groups (Business Logic)

| Group       | Purpose              |
|------------|----------------------|
| HR_Users   | Standard HR employees |
| HR_Admin   | HR administrators    |
| IT_Admins  | IT administrators    |

---

### Permission Groups (Technical Access)

| Group   | Purpose                  |
|--------|--------------------------|
| HR_RO  | Read-only access         |
| HR_RW  | Read / Write access      |

---

## Access Model (RBAC)

The environment follows a layered access control model:

User → Role Group → Permission Group → Resource


### Example

- A user is added to `HR_Users`
- `HR_Users` is a member of `HR_RO`
- `HR_RO` has NTFS permissions on the file server

Result:
- The user automatically gets the correct level of access

---

## Why This Design?

This approach reflects real enterprise environments:

### Scalability

- Adding a new user only requires assigning them to a role group
- No need to modify permissions manually

---

### Security (Least Privilege)

- Users receive only the access required for their role
- Sensitive data is protected (e.g. HR\Admin restricted to HR_Admin)

---

### Maintainability

- Changes are made at group level, not user level
- Reduces configuration errors

---

### Separation of Responsibilities

- Role groups = business logic
- Permission groups = technical access

---
 Screenshots to be added
