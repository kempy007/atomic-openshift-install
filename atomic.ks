#version=DEVEL
# System authorization information
auth --enableshadow --passalgo=sha512
# OSTree setup
ostreesetup --osname="centos-atomic-host" --remote="centos-atomic-host" --url="file:///install/ostree" --ref="centos-atomic-host/7/x86_64/standard" --nogpg
# Use graphical install
# graphical # REM
text
# ADD 1 row above
# Run the Setup Agent on first boot
# firstboot --enable # REM
firstboot --disable
eula --agreed
# ADD 2 row above

ignoredisk --only-use=sda
# Keyboard layouts
keyboard --vckeymap=gb --xlayouts='gb'
# System language
lang en_GB.UTF-8

# Network information
network  --bootproto=dhcp --device=enp0s3 --onboot=on --ipv6=auto --no-activate
network  --hostname=oc-aio

# Root password
rootpw --iscrypted REDACTED
# System services
services --disabled="cloud-init,cloud-config,cloud-final,cloud-init-local" --enabled="chronyd"
# System timezone
timezone Europe/London --isUtc
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda
autopart --type=lvm
# Partition clearing information
clearpart --none --initlabel

%post --erroronfail
cp /etc/skel/.bash* /var/roothome
fn=/etc/ostree/remotes.d/centos-atomic-host.conf; if test -f ${fn} && grep -q -e '^url=file:///install/ostree' ${fn}; then rm ${fn}; fi
%end

%packages
chrony
kexec-tools

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
