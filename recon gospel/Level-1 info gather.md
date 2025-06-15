🔍 Search Engine Discovery & Reconnaissance Checklist (WSTG-INFO-01)
 Identify domains and subdomains to search for (e.g. example.com, dev.example.com)

 Use Google advanced operators (Google Dorking) to search for leaked information:

 site:example.com - List all indexed pages for the target domain
 site:example.com inurl:admin - Look for administrative panels
 site:example.com filetype:sql | filetype:log | filetype:conf - Search for potentially sensitive file types
 intitle:"index of" - Search for open directories
 intext:"password" site:example.com - Search for leaked credentials
 site:example.com ext:doc | ext:pdf | ext:xls - Look for internal documents
 Repeat similar queries across other search engines (e.g., Bing, DuckDuckGo, Yandex)

 Use services like Google Alerts to monitor for newly indexed leaks

 Examine cached versions of pages for previously exposed data

 Use Archive.org (Wayback Machine) to view historical exposures

 Search for code or configuration leaks on platforms like GitHub or GitLab:

 site:github.com "example.com" - Search for code or mentions of the domain
 Document all findings and verify if the information is still accessible

 Report any sensitive exposure according to your responsible disclosure process

Certainly! Below is a markdown-formatted checklist with a title using British English and formatted as per your request, based on the OWASP WSTG section: “Fingerprint Web Server”.

🖥️ Fingerprint Web Server Checklist (WSTG-INFO-02)
 Identify the target web server(s) and accessible interfaces (HTTP, HTTPS, alternative ports)
 Perform banner grabbing:
 Use tools like curl -I, telnet, netcat, or nmap to inspect HTTP response headers
 Look for Server, X-Powered-By, and other identifying headers
 Send requests using various HTTP methods (e.g., GET, POST, HEAD, OPTIONS) and analyse responses
 Check for method support via the Allow header
 Observe status codes and server behaviour for each method
 Use automated fingerprinting tools to identify server technologies:
 WhatWeb
 Wappalyzer
 httprint
 BuiltWith
 nmap -sV (service/version detection)
 Inspect TLS/SSL configuration for additional fingerprinting information:
 Use tools like sslscan, testssl.sh, or nmap --script ssl*
 Examine certificate details (issuer, subject, validity)
 Review error pages and server responses for version information or default messages
 Examine static content (e.g., JavaScript, CSS, image paths) for technology clues
 Cross-reference findings with open intelligence sources:
 Shodan
 Censys
 Netcraft Site Report
 Document and correlate findings from multiple sources to improve accuracy
 Note any discrepancies that could indicate load balancers, WAFs, or reverse proxies
📂 Review Webserver Metafiles for Information Leakage Checklist (WSTG-INFO-03)
 Identify and attempt to access common webserver metafiles:
 /robots.txt
 /sitemap.xml
 /crossdomain.xml
 /clientaccesspolicy.xml
 .htaccess, .htpasswd (where applicable)
 Review robots.txt for:
 Disallowed paths that may point to sensitive or hidden resources
 Comments or notes containing internal information
 Review sitemap.xml for:
 URLs not linked from the main site navigation
 Internal or administrative paths
 Review crossdomain.xml and clientaccesspolicy.xml for:
 Overly permissive domain access rules (e.g., * wildcard)
 Exposure of internal services to external domains
 Attempt to access backup, config, or temporary metafiles (e.g., backup.tar.gz, config.bak)
 Use automated tools or scripts to enumerate common metafiles
 Review web server directory listings (if enabled) for metafile references
 Correlate discovered paths with further manual or automated exploration
 Document all findings and assess risk based on the sensitivity of disclosed information
🗂️ Enumerate Applications on Webserver Checklist (WSTG-INFO-04)
 Identify the IP address and fully qualified domain names (FQDNs) associated with the target web server
 Perform DNS enumeration to discover subdomains and virtual hosts
 Use web crawling tools to enumerate accessible paths and applications
 Check for virtual hosts using:
 nmap --script http-vhosts
 Tools like ffuf, dirsearch, or Gobuster with a list of common subdomains or virtual hosts
 Review SSL/TLS certificates for Subject Alternative Names (SANs) that may reveal additional applications or hosts
 Analyse HTTP headers and cookies for clues about backend applications or frameworks
 Use public search engines and OSINT tools to identify linked applications on the same server
 Investigate common application locations (e.g., /admin, /webmail, /blog, /crm)
 Identify technologies used per application using tools like WhatWeb or Wappalyzer
 Correlate identified applications with known vulnerabilities or default configurations
 Document all discovered applications, their technologies, and accessible paths for further testing
📝 Review Webpage Content for Information Leakage Checklist (WSTG-INFO-05)
 Review visible text on webpages for sensitive or internal information
 Inspect HTML source code for comments disclosing:
 Developer notes
 Internal IP addresses or file paths
 Credentials or usernames
 Check for embedded metadata in HTML, images, documents, or script files
 Review JavaScript files (both inline and external) for:
 API keys or tokens
 Debug information or commented-out code
 Internal endpoints or configuration variables
 Examine hidden form fields and their values for sensitive data
 Review URLs for sensitive query string parameters (e.g., tokens, session IDs)
 Identify exposed directory structures or file paths in error messages or page content
 Look for version information of libraries, frameworks, or applications
 Use browser developer tools to inspect:
 Network traffic for unencrypted sensitive data
 JavaScript variables and local/session storage
 Download and inspect accessible documents (PDF, DOCX, XLSX) for metadata or embedded content
 Document all discovered sensitive information and assess potential impact
🚪 Identify Application Entry Points Checklist (WSTG-INFO-06)
 Crawl the web application to map all accessible URLs and endpoints
 Identify and document all HTTP methods supported by each endpoint
 Detect parameters passed via:
 URL query strings
 POST data
 Cookies
 HTTP headers
 Review JavaScript files for dynamically generated or obfuscated entry points
 Use browser developer tools to inspect:
 AJAX calls
 Form submissions
 API interactions
 Identify hidden or undocumented endpoints through tools such as:
 ffuf, dirsearch, Burp Suite or OWASP ZAP
 Analyse URL patterns for predictable or incremental structures
 Note endpoints used for authentication, registration, and password management
 Discover potential WebSocket, GraphQL, or RESTful API entry points
 Document all discovered entry points for use in further testing stages
🗺️ Map Execution Paths Through Application Checklist (WSTG-INFO-07)
 Identify all user roles and corresponding access levels within the application
 Manually browse the application to observe typical user workflows
 Use a proxy tool (e.g. Burp Suite, OWASP ZAP) to record all HTTP requests and responses during navigation
 Map out key functional areas, including:
 Login and authentication flows
 Registration and account management
 Search and navigation features
 Shopping cart, checkout, or transaction processes
 Administrative and privileged functionality
 Note any conditional or dynamic content based on user actions or roles
 Identify any multi-step processes or wizards within the application
 Observe the use of client-side technologies (e.g. JavaScript, AJAX) that alter execution flow
 Track transitions between pages, including parameters passed in URLs, forms, or headers
 Create a flow diagram or site map to visualise the application’s logical structure
 Document all identified execution paths to support further testing and analysis
🧬 Fingerprint Web Application Framework Checklist (WSTG-INFO-08)
 Identify HTTP response headers that may reveal the framework (e.g. X-Powered-By, Server)
 Review page source and comments for references to framework-specific files or structures
 Analyse URL patterns and routing structures typical of known frameworks
 Examine cookies for naming conventions or values indicative of specific frameworks
 Inspect JavaScript and CSS file paths for framework identifiers
 Use automated tools (e.g. WhatWeb, Wappalyzer, BuiltWith) to detect frameworks
 Check for default files or endpoints (e.g. /wp-login.php, /rails/info/routes)
 Look for error messages or debug output disclosing framework details
 Identify usage of third-party libraries or plugins associated with certain frameworks
 Cross-reference identified clues to confirm the underlying framework
 Document all findings for use in attack surface evaluation and vulnerability correlation
🏗️ Map Application Architecture Checklist (WSTG-INFO-10)
 Identify all client-side technologies used (e.g. JavaScript frameworks, HTML5, CSS libraries)
 Enumerate server-side technologies (e.g. programming languages, web frameworks, CMS platforms)
 Determine the use of third-party services and APIs
 Identify backend systems such as:
 Databases
 Authentication servers
 File storage systems
 Examine network communications to identify internal and external service interactions
 Map the flow of data between client, web server, and backend components
 Identify points of integration with external systems (e.g. payment gateways, email services)
 Investigate deployment infrastructure (e.g. cloud platforms, containers, load balancers)
 Determine the use of content delivery networks (CDNs)
 Identify security mechanisms in place (e.g. WAFs, reverse proxies, authentication flows)
 Create a visual diagram of the application’s architecture to support further testing
 Document all findings to understand trust boundaries and potential attack surfaces
