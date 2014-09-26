#!/bin/sh
tarFileName="pass.tar"
encTarFileName="pass.tar.asc"

echo "Usage: 

pman-init <master password> : 
		initialize the password manager by creating an empty archive file.
		This file is encrypted with the <master password> and will hold all the service files.

pman-create-servie <master password> <service name> <service password> <service master password> : 
		adds a new service. Each <service password> is saved in a <service name>.txt file that 
		is encrypted the <service master password> and saved inside the archive file created at init

pman-remove-service <service name> <master password> : 
		removes a password by deleting the respective file inside the archive

pman-show-all <master password> :
		show all service names - all file names inside the archive file

pman-show-service <master password> <service name> <service master password> :
		show the password for the <service name> 
"

function pman-init {
	echo "Init pman ..."
	echo "Master Password:"
	read -s masterPass
	echo "Re-enter Master Password:"
	read -s masterPass2

	if [ "$masterPass" != "$masterPass2" ]; then
		echo "Passwords do not match!"
		exit
	fi

    mkdir init
    cd init
	#create an empty archive
    tar -cf "$tarFileName" . && cd .. && mv "init/$tarFileName" .
    rm -rf init 

    cat "$tarFileName" | gpg --batch -a -c --no-use-agent --passphrase "$masterPass" --cipher-algo AES256 > "$encTarFileName"
    shred "$tarFileName"
    rm "$tarFileName"

	unset masterPass
}

function pman-create-service {
	echo "Master Password:"
	read -s masterPass
	echo "Service Name:"
	read -s serviceName
	echo "Service Password:"
	read -s servicePass
	echo "Service Master Password:"
	read -s serviceMasterPass
	echo "Re-enter Service Master Password:"
	read -s serviceMasterPass2

	if [ "$serviceMasterPass" != "$serviceMasterPass2" ]; then
		echo "Passwords do not match!"
		exit
	fi

    #create and encrypt the service file
	echo "$servicePass" | gpg --batch -a -c --no-use-agent --passphrase "$serviceMasterPass" --cipher-algo AES256 > "$serviceName.txt"

    #decrypt to temp tar archive
	gpg --no-use-agent --passphrase "$masterPass" --output "$tarFileName" --decrypt "$encTarFileName"

    #oppen service file in temp tar archive
    #alternative: tar -rf pass.tar ./$1
    tar -rf "$tarFileName" "$serviceName.txt"

	#mv $encTarFileName "$encTarFileName.old"

    #encrypt the temp. tar file and shred it
	gpg --batch -a -c --yes --no-use-agent --passphrase "$masterPass" --cipher-algo AES256 --output "$encTarFileName" "$tarFileName"

    shred "$tarFileName"
    rm "$tarFileName"

    shred "$serviceName.txt"
    rm "$serviceName.txt"

    unset servicePass
	unset serviceName
	unset masterPass
	unset serviceMasterPass
}

function pman-remove-service {
    echo "Service Name:"
	read -s serviceName
	echo "Master Password:"
	read -s masterPass

    #decrypt to temp tar archive
	gpg --no-use-agent --passphrase "$masterPass" --output "$tarFileName" --decrypt "$encTarFileName"

    #remove service file from the archive
    tar --delete -f "$tarFileName" "$serviceName"

    #encrypt the temp. tar file and shred it
	gpg --batch -a -c --yes --no-use-agent --passphrase "$masterPass" --cipher-algo AES256 --output "$encTarFileName" "$tarFileName"
    
	shred "$tarFileName"
    rm "$tarFileName"

	unset serviceName
	unset masterPass
}

function pman-show-all {
	echo "Master Password:"
	read -s masterPass
    cat "$encTarFileName" | gpg --no-use-agent --passphrase "$masterPass" | tar -tf -

	unset masterPass
}

function pman-show-service {
	echo "Master Password:"
	read -s masterPass
	echo "Service Name:"
	read -s serviceName
	echo "Service Master Password:"
	read -s serviceMasterPass

    cat "$encTarFileName" | gpg --no-use-agent --passphrase "$masterPass" | tar -xf - "$serviceName" -O | gpg --no-use-agent --passphrase "$serviceMasterPass"

	unset masterPass
	unset serviceName
	unset serviceMasterPass
}


