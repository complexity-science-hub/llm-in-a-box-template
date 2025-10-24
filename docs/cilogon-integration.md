# OIDC Integration Using CILogon

## Introduction

[CILogon](https://www.cilogon.org) provides a standards-compliant OpenID
Connect (OAuth 2.0) interface to federated authentication for
cyberinfrastructure (CI). CILogon's federated identity management enables
researchers to use their home organization credentials to access
applications, rather than requiring yet another username and password to
log on. 

CILogon is operated by the
[National Center for Supercomputing Applications (NCSA)](https://www.ncsa.illinois.edu/)
at the [University of Illinois at Urbana-Champaign](https://illinois.edu/).

## Prequisites

You should have already successfully deployed and configured the
chat service (Open WebUI) using the standard login form authentication.
This guide only details additional configuration needed for OIDC integration
using CILogon and does not address overall configuration issues.

The [OIDC protocol](https://openid.net/specs/openid-connect-core-1_0.html)
requires web applications to be served using HTTPS. Your service should
already be
[configured to use HTTPS](link-to-traefix-documentation).
The only exception to this requirement is during exploration or development
when `http://localhost` or `http://127.0.0.1` may be used.

## Request Your CILogon Client ID and Secret

CILogon subscribers may log into their CILogon Registry service and use
the self-service interface to request a client ID and secret.

Basic Authentication service tier (free) users should request a client
following the instructions below and wait for a notice of approval.

1. Browse to the
[CILogon OpenID Connect (OIDC) Client Registration](https://cilogon.org/oauth2/register)
form.

1. Complete the form fields for Client Name, Contact Email, and Home URL.

1. For the Callback URLs field enter `https://<YOUR SERVER>/oauth/oidc/callback`
   and repalce `<YOUR SERVER>` with the hostname or service name for your
   deployment.

1. For Scopes tick the boxes for email, openid, and profile.

1. Click `Register Client`.

1. Record the client ID and secret. You must safely escrow the client secret
   since CILogon does not store it and only stores a computed hash of the
   secret.

1. Wait for an email indicating your client has been approved. You cannot
   successfully test your configuration until the client has been approved.

## Configuration

The OAuth or OIDC integration for Open WebUI may be completely configured
using environment variables. For additional details beyond those below
see the following Open WebUI documentation:

- [Environment Variable Configuration](https://docs.openwebui.com/getting-started/env-configuration)
- [SSO(OAuth, OIDC, Trusted Header)](https://docs.openwebui.com/features/auth/sso/)
- [Troubleshooting OAUTH/SSO Issues](https://docs.openwebui.com/troubleshooting/sso/)


Edit the `llm_chat_ui.environment` section of the `docker-compose.yml` file 
as follows:

1.
   ```
   ENABLE_OAUTH_PERSISTENT_CONFIG: "False"
   ```
   
   This forces the OAuth configuration to always be read from environment
   variables on every restart.

1. 
   ```
   ENABLE_SIGNUP: "True"
   ```

   Enable user account creation generally. See also `ENABLE_OAUTH_SIGNUP`.

1.
   ```
   ENABLE_OAUTH_SIGNUP: "True"
   ```
   
   Enable user account creation when authenticating using OAuth.

1.
   ```
   WEBUI_URL: "https://<YOUR SERVER>"
   ```

   Replace `<YOUR SERVER>` with the hostname from which your service will
   be served. Open WebUI uses this configuration to construct the appropriate
   return URI used during the OAuth or OIDC authentication flow.

1.
   ```
   OAUTH_CLIENT_ID: "<YOUR CLIENT ID FROM CILOGON>"
   ```

   Replace `<YOUR CLIENT ID FROM CILOGON>` with the client ID obtained when
   you requested your client from CILogon. The client ID will usually follow
   the format

   ```
   cilogon:/client_id/...
   ```

1.
   ```
   OAUTH_CLIENT_SECRET: "<YOUR CLIENT SECRET FROM CILOGON>"
   ```

   Replace `<YOUR CLIENT SECRET FROM CILOGON>` with the client secret
   obtained when you requested your client from CILogon.

1.
   ```
   OPENID_PROVIDER_URL: "https://cilogon.org/.well-known/openid-configuration"
   ```

1.
   ```
   OAUTH_PROVIDER_NAME: "CILogon"
   ```

1.
   ```
   OAUTH_SCOPES: "openid email profile"
   ```

1.
   ```
   OPENID_REDIRECT_URI: "https://<YOUR SERVER>/oauth/oidc/callback"
   ```

1.
   ```
   OAUTH_ALLOWED_DOMAINS: "<YOUR CAMPUS DOMAIN>"
   ```

   Since CILogon supports authentication from over 6,000 campus login servers
   around the world you may wish to restrict login from only your campus
   users. To do so enter the domain of your campus, for example

   ```
   illinois.edu
   ```

   You may use a comma-separted list of domains, for example

   ```
   illinois.edu,berkeley.edu,tuwien.ac.at
   ```

   CILogon subscribers may instead request that the OAuth2 server restrict
   logins from only a subset of login servers (server-side authorization is
   not available without a subscription).

## Restart and Test

After you have received email notification that your CILogon client has been
approved and you have edited the `docker-compose.yml` file as detailed above,
you may restart your service and test the CILogon OIDC integration.
