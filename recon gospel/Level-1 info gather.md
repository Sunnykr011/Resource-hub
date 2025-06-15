

🔍 Web Application Information Gathering Checklists (OWASP WSTG)


---

🔍 Search Engine Discovery & Reconnaissance Checklist (WSTG-INFO-01)

Identify domains and subdomains to search for (e.g. example.com, dev.example.com)

Use Google advanced operators (Google Dorking) to search for leaked information:

site:example.com – List all indexed pages for the target domain

site:example.com inurl:admin – Look for administrative panels

site:example.com filetype:sql | filetype:log | filetype:conf – Search for potentially sensitive file types

intitle:"index of" – Search for open directories

intext:"password" site:example.com – Search for leaked credentials

site:example.com ext:doc | ext:pdf | ext:xls – Look for internal documents


Repeat similar queries across other search engines (Bing, DuckDuckGo, Yandex)

Use Google Alerts to monitor newly indexed leaks

Examine cached versions of pages for previously exposed data

Use Archive.org (Wayback Machine) to view historical exposures

Search for code/configuration leaks on GitHub or GitLab:

site:github.com "example.com" – Search for code or mentions of the domain


Document all findings and verify if the information is still accessible

Report any sensitive exposure via responsible disclosure



---

🖥️ Fingerprint Web Server Checklist (WSTG-INFO-02)

Identify target web server(s) and accessible interfaces (HTTP, HTTPS, alternative ports)

Perform banner grabbing:

Use tools like curl -I, telnet, netcat, or nmap to inspect HTTP response headers

Look for Server, X-Powered-By, and other identifying headers


Send requests using various HTTP methods (GET, POST, HEAD, OPTIONS) and analyze responses

Check for method support via the Allow header

Observe status codes and server behavior for each method


Use automated fingerprinting tools:

WhatWeb

Wappalyzer

httprint

BuiltWith

nmap -sV (service/version detection)


Inspect TLS/SSL configuration:

Tools: sslscan, testssl.sh, nmap --script ssl*

Examine certificate details (issuer, subject, validity)


Review error pages and server responses for version information

Inspect static content (JavaScript, CSS, image paths) for technology clues

Cross-reference findings with:

Shodan

Censys

Netcraft Site Report


Document and correlate findings from multiple sources

Note discrepancies indicating load balancers, WAFs, or reverse proxies



---

📂 Review Webserver Metafiles for Information Leakage Checklist (WSTG-INFO-03)

Identify and access common webserver metafiles:

/robots.txt

/sitemap.xml

/crossdomain.xml

/clientaccesspolicy.xml

.htaccess, .htpasswd (where applicable)


Review robots.txt:

Disallowed paths pointing to sensitive or hidden resources

Internal comments or notes


Review sitemap.xml:

URLs not linked from site navigation

Internal or administrative paths


Review crossdomain.xml and clientaccesspolicy.xml:

Overly permissive domain access rules (* wildcard)

Exposure of internal services


Attempt to access backup/config/temp metafiles (e.g., backup.tar.gz, config.bak)

Use automated tools to enumerate common metafiles

Review directory listings (if enabled) for metafile references

Correlate discovered paths with manual/automated exploration

Document all findings and assess the sensitivity



---

🗂️ Enumerate Applications on Webserver Checklist (WSTG-INFO-04)

Identify IP address and FQDNs of the target web server

Perform DNS enumeration for subdomains and virtual hosts

Use web crawling tools to map paths and applications

Check virtual hosts:

nmap --script http-vhosts

ffuf, dirsearch, Gobuster with common subdomain/host lists


Review SSL/TLS certificates for Subject Alternative Names (SANs)

Analyze HTTP headers and cookies for backend application clues

Use OSINT tools and search engines to find linked applications

Investigate common app locations: /admin, /webmail, /blog, /crm

Identify technologies using WhatWeb, Wappalyzer

Correlate apps with known vulnerabilities or default setups

Document discovered apps, technologies, and paths for further testing



---

📝 Review Webpage Content for Information Leakage Checklist (WSTG-INFO-05)

Review visible text for sensitive/internal information

Inspect HTML source code for:

Developer notes

Internal IPs or file paths

Credentials or usernames


Check embedded metadata in HTML, images, documents, scripts

Review JavaScript files for:

API keys, tokens

Debug info, commented code

Internal endpoints or configuration variables


Examine hidden form fields for sensitive data

Review URLs for sensitive query string parameters (tokens, session IDs)

Identify directory structures or file paths in errors or content

Look for version info of libraries/frameworks

Use browser dev tools to inspect:

Network traffic for unencrypted data

JavaScript variables, local/session storage


Download and inspect accessible documents for metadata

Document all sensitive information and assess potential impact



---
