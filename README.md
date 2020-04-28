
# Status
![Devops Toolbox CI/CD](https://github.com/karlesnine/docker-devops-toolbox/workflows/Devops%20Toolbox%20CI/CD/badge.svg)

# Getting started

Just copy `run.sh` and run it.
Finished, you now log in your container by SSH using your key:
- `ssh -A -p 8000 root@localhost`

Everything is normally configured

# Installed software
- helm 2.14.3
- ansible (v2.8.7)
- terraform (v0.12.24)
- kubctl (lastest)
- tfswitch (latest)
- python (2.7.13)
- python3 (3.5.3)
- pip (9.0.1)
- PyMySQL (latest)
- ansible-modules-hashivault (latest)
- requests (latest)
- awscli (latest)

# After first ssh loggin run
- `aws configure`
- `for CLUSTER in $(aws eks list-clusters | cut -f2 -d$'\t'); do aws eks --region eu-west-1 update-kubeconfig --name $CLUSTER; done`

