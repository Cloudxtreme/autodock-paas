.. _Docker: https://github.com/docker/docker
.. _Docker Compose: https://github.com/docker/compose
.. _autodock: https://github.com/prologic/autodock
.. _autodock-paas: https://github.com/prologic/autodock-paas
.. _autodock-paas image: https://hub.docker.com/r/prologic/autodock-paas/
.. _PaaS: https://en.wikipedia.org/wiki/Platform_as_a_service
.. _Stackfiles: https://stackfiles.io/registry/55e76bc25d8ffc010083bc92
.. _prologic/mksslcrt: https://hub.docker.com/r/prologic/mksslcrt/
.. _cpuguy83/sslgen: https://hub.docker.com/r/cpuguy83/sslgen/
.. _starefossen/sslmate: https://hub.docker.com/r/starefossen/sslmate/
.. _a Docker-based mini-PaaS:  <http://shortcircuit.net.au/~prologic/blog/article/2015/03/24/a-docker-based-mini-paas/

autodock-paas
=============

.. image:: https://badge.imagelayers.io/prologic/autodock-paas:latest.svg
   :target: https://imagelayers.io/?images=prologic/autodock-paas:latest
   :alt: Image Layers

This is the `autodock`_ based minimal `Docker`_ based `PaaS`_.

`autodock-paas`_ is MIT licensed.

This stack is also registered over at `Stackfiles`_.

Quick Start
-----------

Simply run on a `Docker`_ Host with `Docker Compose`_ installed::
    
    $ curl -sSL https://raw.githubusercontent.com/prologic/autodock-paas/master/setup.sh | bash -s

Now whenever you start a new container autodock will listen for Docker events
and discover containers that have been started. The ``autodock-hipache`` plugin
will specifically listen for starting containers that have a ``VIRTUALHOST``
environment variable and reconfigure the running ``hipache`` container.

Start a "Hello World" Web Application::
    
    $ docker run -d -e VIRTUALHOST=hello.mydomain.com prologic/hello
    curl -q -o - -H 'Host: hello.mydomain.com' http://localhost/
    Hello World!

.. note:: This method of hosting and managing webapps and websites is in
          production deployments and talked about in more detail in the post
          `A Docker-based mini-PaaS`_.

**Updated (20150914)**: We now provide an `autodock-paas image`_ that you can
                        run to setup `autodock`_:

.. code-block:: bash
    
    $ docker run -d -e DOMAIN=mydomain.com -v /var/run/docker.sock:/var/run/docker.sock prologic/autodock-paas

Or as a `Docker Compose`_ service:

.. code-block:: yaml
    
    autodockpaas:
      image: prologic/autodock-paas
      environment:
        - DOMAIN=mydomain.com
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
      restart: always

Creating SSL Certificates
-------------------------

Use either the ``mksslcert`` from the OpenSSL package. Example:

.. code-block:: bash
    
    mkdir -p etc/hipache/ssl
    mksslcert ssl/hipache/ssl/ssl.key ssl/hipache/ssl/ssl.crt '*.mydomain.com'

The `prologic/mksslcrt`_ image uses this tool to automatically created
self-signed SSL certificates when run. Examples:

Host mounted volume::
    
    $ docker run --rm -v $(pwd):ssl:/ssl mksslcrt '*.mydomain.com'

Data volume container::
    
    $ docker run --name sslcerts prologic/mksslcrt '*.mydomain.com'
    $ docker run --volumes-from sslcerts prologic/hipache

Or this nice Docker Image: `cpuguy83/sslgen`_.

For signed certificates have a look at `starefossen/sslmate`_.
