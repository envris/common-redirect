httpd-redirect
=============

Summary
-------------

A simple Docker image to listen for connections on port 80 using httpd and immediately redirect any clients to a HTTPS URL specified by an environment variable.

It was created to redirect any visitor accessing the root URL to a sub path and force them onto HTTPS.

Usage
-------------

Make sure to specify the `TARGET_PATH` environment variable to where you want to redirect any visitors to. The host is automatically picked up from the URL and is not configurable.

    docker run --env TARGET_PATH=something/or/other httpd-redirect:1.0.0

Building
-------------

Simply run the following from the root of the repo:

    docker build -t httpd-redirect:$VERSION .

Where `$VERSION` is the version you want to give it.
