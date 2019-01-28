# Setting up an HTTPS service with Vault & Fabio

## Pre-requisites

### Service

We need a service to secure. There is a basic Nginx job file on the cluster nodes in `/services`. SSH into node-1 and start it up with:

```bash
nomad run /services/nginxtest.nomad
```

### Local DNS

You'll need some form of local DNS setup to access the test service we'll create. Either follow the DNSMasq setup guide in the main readme or create a hosts-file entry as follows:

```bash
172.16.0.1  nginxtest.service.devcluster
```

### Consul certificate store

We need somewhere to store the generated service certificates. Head over the to Consul UI at `http:\\172.16.0.101:8500` to setup the certificate key/value store path:

- __Key/Value__ -> Create
  - Key or folder: *fabio/cert/*
  - Save

### Vault CLI

Note that if you want to interact with Vault via the CLI, the Vault binary is available on each cluster node (`/usr/local/sbin/vault`). Vault environment variables have been defined to make this straightforward.

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

## Create a root certificate

In order to create & use per service certificates, we need to generate a root certificate, and before we can do that we need to enable the PKI secrets engine in Vault (see [Vault secret engines](https://www.vaultproject.io/docs/secrets/index.html)).

So, ensure you are logged into Vault (with the root token), then:

1. Enable the PKI secrets engine:
    - UI: __Master Vault Node__ -> __Secrets__ -> Enable new engine -> PKI Certificates -> Next -> Enable engine
      - Max Lease TTL: *8760 hours*
    - CLI: `vault secrets enable pki; vault secrets tune -max-lease-ttl=8760h pki`

2. Create the root CA certificate:
    - UI: __Master Vault Node__ -> __Secrets__ -> pki -> Certificates -> Configure -> Configure CA
      - Common name: *devcluster*
      - Options -> TTL: *8760 hours*
      - Save
    - CLI: `vault write pki/root/generate/internal common_name=devcluster ttl=8760h`

3. Create the CRL / issuing certificate locations:
   - UI: __Master Vault Node__ -> __Secrets__ -> pki -> Configuration -> Configure -> URLs
     - Issuing certificates: *http://172.168.0.101:8200/v1/pki/ca* -> Add
     - CRL Distribution Points: *http://172.168.0.101:8200/v1/pki/crl* -> Add
     - Save
   - CLI: `vault write pki/config/urls issuing_certificates="http://172.168.0.101:8200/v1/pki/ca" crl_distribution_points="http://172.168.0.101:8200/v1/pki/crl"`

4. Add a role that allows issuing of certificates for <service>.devcluster (or whatever your cluster is named):
   - CLI: `vault write pki/roles/service.devcluster allowed_domains="service.devcluster" allow_any_name="true" max_ttl="8760h"`

The (public) CA certificate can the be downloaded the Vault master node, eg: `curl http://172.16.0.101:8200/v1/pki/ca/pem`

## Create a service certificate

We'll now create a certificate for the Nginx service we started earlier (*nginxtest.service.devcluster*), signed by the previously created root certificate. Ensure you are logged into Vault (with the root token), then:

- UI: __Master Vault Node__ -> __Secrets__ -> pki -> service.devcluster
  - Common name: *nginxtest.service.devcluster*
  - TTL: *2232 hours*
  - Generate
- CLI: `vault write pki/issue/service.devcluster common_name=nginxtest.service.devcluster ttl=2232h`
- Ensure you copy the resulting certificate data.

## Setup service with certificate

Fabio (the edge router) is already configured to use Consul as a certificate store (under the /fabio/cert KV path), so all we need to do is add our new cert (in PEM format) via the Consul UI at `http:\\172.16.0.101:8500`:

1. In order to convert the generated service certificate output into a PEM format, concatenate the private key, certificate and issuing CA values (each on a new line):
    ```xml
    <private_key>
    <certificate>
    <issuing_ca>
    ```
2. __Key/Value__ -> fabio -> cert -> Create
    - Key or folder: *nginxtest.service.devcluster*
    - Value: <*certificate in PEM format*>
    - Save

3. Verify the service is now accessible over HTTPS - head to `https://nginxtest.service.devcluster`. Your browser will show an "insecure connection" warning as the cert generated is not yet trusted by your OS/browser (see below). For now, use the browser to inspect the offered cert - you can verify its serial number matches the one you just created.

## Get the OS to trust your cluster root certificate

The guides linked will guide you through adding your root cert to the OS & browser certificate stores on all major OS's.

- Linux: https://thomas-leister.de/en/how-to-import-ca-root-certificate/
- OS X: https://bounca.org/tutorials/install_root_certificate.html
- Windows: https://thomas-leister.de/en/how-to-import-ca-root-certificate/
