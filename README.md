autodock-paas
=============

This is the [autodock](https://github.com/prologic/autodock) based minimal [Docker](https://github.com/docker/docker) based [PaaS](https://en.wikipedia.org/wiki/Platform_as_a_service).

autodock-paas is MIT licensed.

Quick Start
-----------

Simply run on a [Docker](https://github.com/docker/docker) Host with [Docker Compose](https://github.com/docker/compose) installed:

    $ curl -sSL https://raw.githubusercontent.com/prologic/autodock-paas/master/setup.sh | bash -s

Now whenever you start a new container autodock will listen for Docker events and discover containers that have been started. The `autodock-hipache` plugin will specifically listen for starting containers that have a `VIRTUALHOST` environment variable and reconfigure the running `hipache` container.

Start a "Hello World" Web Application:

    $ docker run -d -e VIRTUALHOST=hello.local prologic/hello

Now assuming you had `hello.local` configured in your `/etc/hosts` pointing to your `hipache` container you can now visit <http://hello.local/>

    echo "127.0.0.1 hello.local" >> /etc/hosts
    curl -q -o - http://hello.local/
    Hello World!

> **note**
>
> This method of hosting and managing webapps and websites is in production deployments and talked about in more detail in the post [A Docker-based mini-PaaS](http://shortcircuit.net.au/~prologic/blog/article/2015/03/24/a-docker-based-mini-paas/).

Creating SSL Certificates
-------------------------

Use either the `mksslcert` from the OpenSSL package. Example:

``` sourceCode
mkdir -p etc/hipache/ssl
mksslcert ssl/hipache/ssl/ssl.key ssl/hipache/ssl/ssl.crt '*.mydomain.com'
```

Or this nice Docker Image: [cpuguy83/sslgen](https://hub.docker.com/r/cpuguy83/sslgen/)
