# Setting up a Vault user

[[TODO: Flesh out this section - create user with time limited permissions, remove original root token]]

Ensure you are logged into Vault (with the root token), then:

1. Enable the username/password authentication method:
    - UI: __Access__ -> __Auth Methods__ -> Enable new method -> Username & Password (accept the defaults)
    - CLI: `vault auth enable userpass`

2. Create a new admin user:
   - CLI: `vault write auth/userpass/users/testuser password=foo policies=admins`

[[TODO: Add role definition / ACL]]

3. Login with this user:
   - UI: __Master Vault Node__ -> __Userpass__
   - CLI: `vault login -method=userpass username=testuser`
