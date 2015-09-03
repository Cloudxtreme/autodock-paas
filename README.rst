.. _Docker: https://github.com/docker/docker
.. _Docker Compose: https://github.com/docker/compose
.. _autodock: https://github.com/prologic/autodock
.. _autodock-paas: https://github.com/prologic/autodock-paas
.. _PaaS: https://en.wikipedia.org/wiki/Platform_as_a_service
.. _Stackfiles: https://stackfiles.io/registry/55e76bc25d8ffc010083bc92
.. _prologic/mksslcrt: https://hub.docker.com/r/prologic/mksslcrt/
.. _cpuguy83/sslgen: https://hub.docker.com/r/cpuguy83/sslgen/
.. _starefossen/sslmate: https://hub.docker.com/r/starefossen/sslmate/

autodock-paas
=============

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
    
    $ docker run -d -e VIRTUALHOST=hello.local prologic/hello

Now assuming you had ``hello.local`` configured in your ``/etc/hosts``
pointing to your ``hipache`` container you can now visit http://hello.local/

::
    
    echo "127.0.0.1 hello.local" >> /etc/hosts
    curl -q -o - http://hello.local/
    Hello World!

.. note:: This method of hosting and managing webapps and websites is in production deployments and talked about in more detail in the post `A Docker-based mini-PaaS <http://shortcircuit.net.au/~prologic/blog/article/2015/03/24/a-docker-based-mini-paas/>`_.

Creating SSL Certificates
-------------------------

Use either the ``mksslcert`` from the OpenSSL package. Example:

.. code-block:: bash
    
    mkdir -p etc/hipache/ssl
    mksslcert ssl/hipache/ssl/ssl.key ssl/hipache/ssl/ssl.crt '*.mydomain.com'

The `prologic/mksslcrt`_ image uses this tool to automatically created self-signed SSL
certificates when run. Examples:

Host mounted vlume::
    
    $ docker run --rm -v $(pwd):ssl:/ssl mksslcrt '*.mydomain.com'

Data volume container::
    
    $ docker run --name sslcerts prologic/mksslcrt '*.mydomain.com'
    $ docker run --volumes-from sslcerts prologic/hipache

Or this nice Docker Image: `cpuguy83/sslgen`_.

For signed certificates have a look at `starefossen/sslmate`_.
