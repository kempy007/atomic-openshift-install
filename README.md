# atomic-openshift-install
This repo is mainly storing the inventory files I used to install openshift and notes if any prep work needed on atomic hosts.

The objective is to use a container from within the target cluster to bootstrap the installation of an openshift cluster by leveraging docker.io/openshift/openshift-ansible 
particular attention needs to be paid to the versions as they need to match the tags being pulled.

# Host setup
download https://cloud.centos.org/centos/7/atomic/images/CentOS-Atomic-Host-7.1808-Installer.iso and install.
can use packer to automate this section but the kickstart file needs to be different than the regular OS kickstart (do manual install and pull off kickstart file). you could then parametize the kickstart and feed back into an ansible gui job that fires off packer tasks.

## edit network config
edit /etc/sysconfig/network-scripts/ifcfg-enp0s3 enable onboot

## expand root volume so can download container
```lvdisplay``` check the lv path ignore beginning /dev/ as middle section is hostname or cah
```lvextend -r -L 20GB cah/root``` this command expands root volume to 20GB

## setup ssh keys between all hosts, including self from primary node(one you decided to use, I use a master).
```ssh-keygen```
```ssh-copyid root@ip.ip.ip.ip```

## run ansible container to install cluster
So we need to match the version in the inventory file otherwise cluster install will fail.
```atomic install --system --storage=ostree --set INVENTORY_FILE=/root/inventory --set PLAYBOOK_FILE=/usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml --set OPTS="-v" docker.io/openshift/origin-ansible:vINT.INT.INT```

```atomic install --system --storage=ostree --set INVENTORY_FILE=/root/inventory --set PLAYBOOK_FILE=/usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml --set OPTS="-v" docker.io/openshift/origin-ansible:vINT.INT.INT```

### to start fresh and remove whole cluster
```atomic install --system --storage=ostree --set INVENTORY_FILE=/root/inventory --set PLAYBOOK_FILE=/usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml --set OPTS="-v" docker.io/openshift/origin-ansible:vINT.INT.INT```

# References
Finally redhat are talking about all-in-one installs at https://blog.openshift.com/openshift-all-in-one-aio-for-labs-and-fun/ but most importantly it has another inventory template referenced at https://blog.openshift.com/openshift-all-in-one-aio-for-labs-and-fun/ 
