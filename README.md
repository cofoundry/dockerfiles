# dockerfiles

A set of docker containers that run the given service like you might expect from a binary.

## nginx-phpfpm

Here's the available run options for this image (described with an implementation of [ansible docker](http://docs.ansible.com/docker_module.html))

```yaml
- name: Run nginx-phpfpm
  sudo: yes
  docker:
    image: cofoundry/nginx-phpfpm
    privileged: yes
    ports: 80:80
    env:
      DOCROOT: /srv/app/web
      NGINX_CONF: /srv/config/nginx.conf
      SITE_CONF: /srv/config/site-default
    volumes:
      - /local/path/to/project:/srv
```

The env vars let us configure elements of the container service, without having to know how/where nginx uses these internally.

The volumes directive lets us expose our application to the container, so source is not baked into docker, and we can update the application without needing to restart the container (excluding config changes, which will require you to kill/start the container again).
