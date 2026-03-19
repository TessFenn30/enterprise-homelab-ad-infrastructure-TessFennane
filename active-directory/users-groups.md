
#  Users and Groups

##  Users

I created a few test users to simulate employees:

- tfennane
- zrobaii

These users are used to test access to shared resources on the file server.

##  Groups

To manage permissions more efficiently, I created the following groups:

- **HR_Group**
- **IT_Group**

##  Permissions Logic

Instead of assigning permissions directly to users, I used groups.

Example:

- Users are added to a group (e.g. HR_Group)
- Permissions are assigned to the group on the file server

This follows best practices and makes management easier as the number of users increases.

##  What I learned

Using groups instead of individual users makes permission management much more scalable and avoids mistakes as I am going to be expending the company.
