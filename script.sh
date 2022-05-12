#!/bin/bash

setting_key(){
	key1=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
	IFS=''
	read -ra keyArr1 <<< "$key1"
	length=${#keyArr1[@]}
	key2=${keyArr1[length-1]}
	IFS='/'
	read -ra keyArr2 <<< "$key2"
	keyGen=${keyArr2[1]}
	gpg --armor --export $keyGen
	echo "Paste this GPG KEY below in GitHub->Settings->SSH and GPG KEYS->New GPG key"
	git config --global user.signingkey $keyGen
	[ -f ~/.bashrc ] && echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
    echo "Your GPG key setup is complete :) "
}

echo "Press [1] if you want to use an already existing GPG key or [2] if you want to generate new key"
read choice

if [ $choice -eq 1 ];
then
	gpg --list-secret-keys --keyid-format=long
	echo "Choose the keyID of the GPG Key you want to use from your existing GPG Keys"
	read keyID
	git config --global user.signingkey $keyID
	[ -f ~/.bashrc ] && echo 'export GPG_TTY=$(tty)' >> ~/.bashrc
	echo "Your GPG key setup is complete :) "

elif [ $choice -eq 2 ];
then
	git --version
	echo "Is your git version greater than 2.1.17?[Press 1 for yes, 2 for no]?"
	read val

	if [ $val -eq 1 ];
	then
		gpg --full-generate-key
		
	elif [ $val -eq 2 ];
	then
		gpg --default-new-key-algo rsa4096 --gen-key
		
	fi
	setting_key
fi