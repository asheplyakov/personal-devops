#!/bin/bash
set -x

# APT should use this proxy to access repositories
PROXY_URL="http://10.42.0.1:8080/"
# POST the host name and the public ssh key here:
PHONE_HOME_URL="http://10.42.0.1:8001/"

source install2-init-functions

# Ensure root can login on UART console

if [ -e "$destdir/etc/securetty" ]; then
	if ! grep -q -e 'ttyS0' "$destdir/etc/securetty"; then
		echo 'ttyS0' >> "$destdir/etc/securetty"
	fi
fi

echo  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAEAQC4nppRTJ7Qa47L29r2H0lZHn6PaSTwribIYbC+rhn2Ar6toONVU2C+PBZCUAGzhep46Ojokl5fRGAPpA4Sj0MsOvu1o9qQP+EMuGDAuLQIF+c4YsGTVFUh/QrSXSwjyk2zL2PGiv9tS8MFLDqDNgR1VDv3MbCvlbnXQb8YGZRE7BQK9pkjCVwXCTobhOYPx6M8YO2NQRMKes6yZPrOwNj5cq5xfzA7bwYHjLlEPqXaMl1oFo8TEETmLta6/+j2FJo92xw66aOfRC+TMEyaQjj6M/1V5Q1wRvhGd54+O9dAyxNSpAtBdG48dTLs/gYn7F5XaGM6Yem7/LdMFm/kisayDFW2QGLrVWJ+Wv/RUaKWWteEwh+3ooRX2nC32I/1Cmzo+wPF6ERDw44jqJBlhXFoyb14y9n1YkxORbldbHJ7plQ3K/z1JEeAi6duj3zglMQvc03Dxd47GhMecJqUA1FBAVI2p4uaEx4vGQIor0GaeCEB+vP/w3E3HgOOgOgiCM8fB6XpHWUGMCGuAyamqqlAW4DAqRwzxzk7Q6a5CduYZaZZSpA+Bczog8HGIJ/seJH0HCh15pEB7lU6w/MlD9J4VJZl8v66x/cK+WQIjZS/THYPxuMXoB66I4hxz9usskkfWLq4siOokT86TalVBBi+LmGP5PocyA55nQD+ySF4g2xeRq78xeCd6sYCyQqvyifiirIiVQcCE804cHlyX997653JbYcYrsYShrSWfnbtsVzB+9VCkt6gAcqp604QnwF6N6BNTEg7ZQzALo//AHdDJq9iG40Af/TQWA/OjHcMk4fV5MhEurnkYxiFP4UHm8e/+oN5ILXB2udYokkW/A6dZY6sE/3H41IBbSYSIMLiI3FAEsJP3jii3/IELV7Ng4UgNXuFmpu4cLdFxLn/86VpC3rDmWYNKBVim3GG8IRaqqEHHM5eUh5xKpYr7SW17JbNrYRUL4mUnkO0p8bFgTpOsuVd2hfGgKmzC480E2ljwZqh3gcLCn0gtPbxcQ3h5+5HuRfAcEHV9rMa53q+h5qphqPXbbEeitf6zT2ntnn/RD/c5kM4iKJOYiw9+1CLh2kvtoLQ+I8jWJWxYmzz21LaVxNwkpi8moKPyVz+O5Q4GkDkmmtngJlTCci4P2EFEfPZJmjTAuj4OFyEDDNqHkADG16/6w7F9pooMGjQCpyUAzfG1VXFSOR+db1DwD41yHw4XbOy2c5mIkxZIFOma+OQBSQElAhfdz2DJe1ai7hfE//qRZKn1FiiSddOSwIDk3pmptjjMA/kZCxkl7KgXy9s7v5TUxO74gR9nHReIVTSUlyshgS1owmK00xoUiYH8RmKS4/aVxL8I/ODQhvw769X asheplyakov@asheplyakov-i5" >> $destdir/root/.ssh/authorized_keys


if [ -n "$PROXY_URL" ]; then
cat > "$destdir/etc/apt/apt.conf.d/10proxy.conf" <<-EOF
Acquire::http::Proxy "${PROXY_URL}";
EOF
fi

# generate ssh host keys
chroot $destdir ssh-keygen -A
# XXX: postinstall.d/65-setup-services.sh forcibly disables sshd
# therefore enabling sshd in this script is pointless

# Enabled getty on UART console
chroot $destdir timeout 30 systemctl enable 'serial-getty@ttyS0.service'

if [ -n "$PHONE_HOME_URL" ]; then
ssh_key="`cat $destdir/etc/openssh/ssh_host_rsa_key.pub`"
hostname="`hostname`"
timeout 60 curl -X POST \
	-H "Content-Type: application/json" \
	-d "{ \"hostname\": \"$hostname\", \"ssh_key\": \"$ssh_key\" }" \
	"$PHONE_HOME_URL"
fi

