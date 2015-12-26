autodock-paas
=============

This is the [autodock](https://github.com/prologic/autodock) based minimal [Docker](https://github.com/docker/docker) based [PaaS](https://en.wikipedia.org/wiki/Platform_as_a_service).

[autodock-paas](https://github.com/prologic/autodock-paas) is MIT licensed.

This stack is also registered over at [Stackfiles](https://stackfiles.io/registry/55e76bc25d8ffc010083bc92).

Quick Start
-----------

Simply run on a [Docker](https://github.com/docker/docker) Host with [Docker Compose](https://github.com/docker/compose) installed:

    $ curl -sSL https://raw.githubusercontent.com/prologic/autodock-paas/master/setup.sh | bash -s

Now whenever you start a new container autodock will listen for Docker events and discover containers that have been started. The `autodock-hipache` plugin will specifically listen for starting containers that have a `VIRTUALHOST` environment variable and reconfigure the running `hipache` container.

Start a "Hello World" Web Application:

    $ docker run -d -e VIRTUALHOST=hello.mydomain.com prologic/hello
    curl -q -o - -H 'Host: hello.mydomain.com' http://localhost/
    Hello World!

> **note**
>
> This method of hosting and managing webapps and websites is in  
> production deployments and talked about in more detail in the post [A Docker-based mini-PaaS](<http://shortcircuit.net.au/~prologic/blog/article/2015/03/24/a-docker-based-mini-paas/).
>
**Updated (20150914)**: We now provide an [autodock-paas image](https://hub.docker.com/r/prologic/autodock-paas/) that you can  
run to setup [autodock](https://github.com/prologic/autodock):

``` sourceCode
$ docker run -d -e DOMAIN=mydomain.com -v /var/run/docker.sock:/var/run/docker.sock prologic/autodock-paas
```

Or as a [Docker Compose](https://github.com/docker/compose) service:

``` sourceCode
autodockpaas:
  image: prologic/autodock-paas
  environment:
    - DOMAIN=mydomain.com
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock
  restart: always
```

Creating SSL Certificates
-------------------------

Use either the `mksslcert` from the OpenSSL package. Example:

``` sourceCode
mkdir -p etc/hipache/ssl
mksslcert ssl/hipache/ssl/ssl.key ssl/hipache/ssl/ssl.crt '*.mydomain.com'
```

The [prologic/mksslcrt](https://hub.docker.com/r/prologic/mksslcrt/) image uses this tool to automatically created self-signed SSL certificates when run. Examples:

Host mounted volume:

    $ docker run --rm -v $(pwd):ssl:/ssl mksslcrt '*.mydomain.com'

Data volume container:

    $ docker run --name sslcerts prologic/mksslcrt '*.mydomain.com'
    $ docker run --volumes-from sslcerts prologic/hipache

Or this nice Docker Image: [cpuguy83/sslgen](https://hub.docker.com/r/cpuguy83/sslgen/).

For signed certificates have a look at [starefossen/sslmate](https://hub.docker.com/r/starefossen/sslmate/).
