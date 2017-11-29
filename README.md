httpd-redirect
=============

Summary
-------------

A simple Docker image to listen for connections on port 80 using httpd and immediately redirect any clients to a HTTPS URL specified by an environment variable.

It was created to redirect any visitor accessing the root URL to a sub path and force them onto HTTPS.

Usage
-------------

You can run the server with the following command:

    docker run --env REDIRECT_DEFS=.*:something/or/other httpd-redirect:$VERSION

Where `$VERSION` is the version the image was tagged with and `$REDIRECT_DEFS` is a comma separated list of redirect definitions. See the [Config Generation](#config-generation) section for more detailed information.

The host is automatically picked up from the URL and is not configurable.

Config Generation
-----------------

The REDIRECT_DEFS environment variable should conform to the following syntax
 - A comma seperated list of redirect definitions
   - WHERE a redirect definition is a colon separated pair
      - WHERE the left side is a regex to match for the definition (.* will match all paths)
      - WHERE the right side is a path to redirect the requestor to

For example, if REDIRECT_DEFS was set to

    "/apps/.*:apps/login,/admin/.*:admin/login"

 the following config would be generated

```
<VirtualHost *:8080>
    RewriteEngine On
    RewriteRule "(/apps/.*)" "https://%{HTTP_HOST}/apps/login" [R]
    RewriteRule "(/admin/.*)" "https://%{HTTP_HOST}/admin/login" [R]
</VirtualHost>
```

Make sure that the right side of the pair (target path) does not start with a leading slash.

Building
-------------

Simply run the following from the root of the repo:

    docker build -t httpd-redirect:$VERSION .

Where `$VERSION` is the version you want to give it.
