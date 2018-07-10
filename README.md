# Ansible docker dev container

### Local host stuff

- Git clone the ansible code: `git clone git@YOURBUCKET:YOURREPO/ansible.git ./`
- Change the *id_rsa.pub* ssh key by your own

### Docker stuff
To build the container : `docker build -t IMAGENAME -f dockerfile ./`

To run the container on OSX:

- Modfify for *user.email* and *user.name* git option
- Run `docker run --hostname=ansible --dns=192.168.0.2 -v /Users/LOGIN/Documents/git/ansible:/etc/ansible -p 8000:22 -d -P --name CONTAINERNAME IMAGENAME`

To login into container by ssh :

- `ssh -p 8000 root@localhost`
