# Local DNS

## Allowable root domains for local development environments

When working with local development environments on your laptop, you have flexibility in choosing root domains that are primarily used for internal access and testing purposes.

Here are some common practices and considerations:

### 0. Using a proper DNS with redircts

-  http://*.llminabox.geoheil.com will redirect to 127.0.0.1
- 
### 1. Using `.localhost`

The `.localhost` Top-Level Domain (TLD) is specifically reserved for loopback purposes, making it an excellent choice for local development.
It's statically defined in host DNS implementations to point to the loopback IP address (127.0.0.1) and is ideal when you need to access a service running directly on your machine without relying on external DNS resolution.

### 2. Using custom TLDs for local development

Many developers use made-up TLDs, such as `.docker` or other custom extensions, to organize their local development domains. For example, a Docker container named "project" might be accessible through `project.docker`.

It's important to be mindful of potential conflicts, especially when using TLDs that are eventually registered publicly, like the case of the `.dev` TLD which was later acquired by Google and is now a valid registrable domain.

For these cases, you will need to configure your local DNS settings, such as the `/etc/hosts` file, or use a local DNS server like dnsmasq to resolve your chosen custom domains to the appropriate IP addresses (usually 127.0.0.1 or a Docker container's IP).

### 3. Using `.home.arpa` for home networks

The Internet Engineering Task Force (IETF) approved the .home.arpa TLD specifically for home network use.

This TLD is suitable when configuring domains within your local home network, such as when assigning names to devices through your router's DHCP server.

### 4. Using subdomains of a registered domain

A more robust approach, especially for complex local development setups or those with future public-facing applications, involves using subdomains of a domain you already own.

For instance, if you own `example.com`, you could use `corp.example.com` for your internal development environment or `jellyfin.example.com` for a media server.

This strategy helps prevent potential conflicts with publicly registered domains and allows for smoother transitions if your local projects are eventually deployed to production environments.

