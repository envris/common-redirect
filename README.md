httpd-redirect
=============

Summary
-------------

A simple Docker image to listen for connections on port 80 using httpd and immediately redirect any clients to a HTTPS URL specified by an environment variable.

It was created to redirect any visitor accessing the root URL to a sub path and force them onto HTTPS.

Usage
-------------

You can run the server with the following command:

    docker run --env TARGET_PATH=something/or/other httpd-redirect:$VERSION

Where `$VERSION` is the version the image was tagged with and `$TARGET_PATH` is the path you want to redirect any visitors to. Make sure that the `TARGET_PATH` environment variable does not start with a leading slash.

The host is automatically picked up from the URL and is not configurable.

Building
-------------

Simply run the following from the root of the repo:

    docker build -t httpd-redirect:$VERSION .

Where `$VERSION` is the version you want to give it.

Configuration
-------------

There are two config files. One is `my-httpd.conf`, this one is added to the docker image and is usually the one you'll be dealing with. The config files under `httpd-cfg` get pulled in for [httpd s2i](https://github.com/openshift/source-to-image) builds in Openshift. If you are just building the Docker image you can ignore that folder.
