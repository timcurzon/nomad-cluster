# Setting up an HTTPS service with Vault & Fabio

## Pre-requisites

[[TODO: Start up example unsecured service]]

If you want to interact with Vault via the CLI, the Vault binary is available on each cluster node (`/usr/local/sbin/vault`). Vault environment variables have been defined to make this straightforward.

## Useful Vault CLI commands

Firstly, setup a Vault address environment variable - `export VAULT_ADDR=http://172.16.0.101:8200`. Add this to your preferred shell enviroment configuration at your leisure.

- Authenticate/login to vault (using root token): `vault login` (enter root token at prompt)
- List authentication methods: `vault auth list`
- List a users details: `vault read auth/userpass/users/[username]`

## Logging into Vault

To log into Vault, you can either:
 - Log in via the UI on the master node with the root token (http://172.16.0.{1-3}:8200)
 - Or log in via the command line: `vault login` (enter root token at prompt)

You'll then be able to use the UI / CLI Vault binary.

## Setting up a Vault user

[[TODO: Confirm if strictly required (omit?)]]

Ensure you are logged into Vault (with the root token), then:

1) Enable the username/password authentication method:
  - UI: __Access__ -> __Auth Methods__ -> Enable new method -> Username & Password (accept the defaults)
  - CLI: `vault auth enable userpass`

2) Create a new admin user:
 - CLI: `vault write auth/userpass/users/testuser password=foo policies=admins`

[[TODO: Add role definition / ACL]]

3) Login with this user:
 - UI: __Master Vault Node__ -> __Userpass__
 - CLI: `vault login -method=userpass username=testuser`

## Create a root certificate

In order to create & use per service certificates, we need to generate a root certificate, and before we can do that we need to enable the PKI secrets engine in Vault (see [Vault secret engines](https://www.vaultproject.io/docs/secrets/index.html)).

So, ensure you are logged into Vault (with the root token), then:

1) Enable the PKI secrets engine:
  - UI: __Master Vault Node__ -> __Secrets__ -> Enable new engine -> PKI Certificates -> Next -> Enable engine (set Max Lease TTL to 8760 hours)
  - CLI: `vault secrets enable pki; vault secrets tune -max-lease-ttl=8760h pki`

2) Create the root CA certificate:
  - UI: __Master Vault Node__ -> __Secrets__ -> pki -> Certificates -> Configure -> Configure CA
    - Common name: devcluster
    - Options -> TTL: 8760 hours
    - Save
  - CLI: `vault write pki/root/generate/internal common_name=devcluster ttl=8760h`

3) Create the CRL / issuing certificate locations:
 - UI: __Master Vault Node__ -> __Secrets__ -> pki -> Configuration -> Configure -> URLs
   - Issuing certificates: http://172.168.0.101:8200/v1/pki/ca -> Add
   - CRL Distribution Points: http://172.168.0.101:8200/v1/pki/crl -> Add
   - Save
 - CLI: `vault write pki/config/urls issuing_certificates="http://172.168.0.101:8200/v1/pki/ca" crl_distribution_points="http://172.168.0.101:8200/v1/pki/crl"`

4) Add a role that allows issuing of certificates for <service>.devcluster (or whatever your cluster is named):
 - CLI: `vault write pki/roles/service.devcluster allowed_domains="service.devcluster" allow_any_name="true" max_ttl="8760h"`

The (public) CA certificate can the be downloaded the Vault master node, eg: `curl http://172.16.0.101:8200/v1/pki/ca/pem`

## Create a service certificate

To create a certificate for a service, e.g. *foo.service.devcluster*, signed by the previously created root certificate, ensure you are logged into Vault (with the root token), then:

  - UI: __Master Vault Node__ -> __Secrets__ -> pki -> service.devcluster
    - Common name: foo.service.devcluster
    - TTL: 2232 hours
    - Generate
  - CLI: `vault write pki/issue/service.devcluster common_name=foo.service.devcluster ttl=2232h`
  - Ensure you copy the resulting certificate data for later use.

## Setup service with certificate

[[TODO: Add to Consul]]

[[TODO: explain that Fabio will use cert]]

[[TODO: Verify service]]