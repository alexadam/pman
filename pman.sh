#!/bin/sh
tarFileName="pass.tar"
encTarFileName="pass.tar.asc"

function pman-init {
	echo "Init pman ..."
	echo "Master Password:"
	read -s masterPass

    mkdir init
    cd init 
    tar -cf $tarFileName . && cd .. && mv init/$tarFileName .
    rm -rf init 

    cat $tarFileName | gpg --batch -a -c --no-use-agent --passphrase $masterPass --cipher-algo AES256 > $encTarFileName
    shred $tarFileName
    rm $tarFileName

	masterPass=
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

    #create and encrypt the service file
	echo $servicePass | gpg --batch -a -c --no-use-agent --passphrase $serviceMasterPass --cipher-algo AES256 > "$serviceName.txt"

    #decrypt to temp tar archive
	gpg --no-use-agent --passphrase $masterPass --output $tarFileName --decrypt $encTarFileName

    #oppen service file in temp tar archive
    #alternative: tar -rf pass.tar ./$1
    tar -rf $tarFileName "$serviceName.txt"

	#mv $encTarFileName "$encTarFileName.old"

    #encrypt the temp. tar file and shred it
	gpg --batch -a -c --yes --no-use-agent --passphrase $masterPass --cipher-algo AES256 --output $encTarFileName $tarFileName

    shred $tarFileName
    rm $tarFileName

    shred "$serviceName.txt"
    rm "$serviceName.txt"

    servicePass=
	serviceName=
	masterPass=
	serviceMasterPass=
}

function pman-remove-service {
    echo "Service Name:"
	read -s serviceName
	echo "Master Password:"
	read -s masterPass    

    #decrypt to temp tar archive
	gpg --no-use-agent --passphrase $masterPass --output $tarFileName --decrypt $encTarFileName

    #remove service file from the archive
    tar --delete -f $tarFileName "$serviceName"

    #encrypt the temp. tar file and shred it
	gpg --batch -a -c --yes --no-use-agent --passphrase $masterPass --cipher-algo AES256 --output $encTarFileName $tarFileName
    
	shred $tarFileName
    rm $tarFileName  

	serviceName=
	masterPass=
}

function pman-show-all {
	echo "Master Password:"
	read -s masterPass
    cat $encTarFileName | gpg --no-use-agent --passphrase $masterPass | tar -tf -

	masterPass=
}

function pman-show-service {
	echo "Master Password:"
	read -s masterPass
	echo "Service Name:"
	read -s serviceName
	echo "Service Master Password:"
	read -s serviceMasterPass

    cat $encTarFileName | gpg --no-use-agent --passphrase $masterPass | tar -xf - $serviceName -O | gpg --no-use-agent --passphrase $serviceMasterPass

	masterPass=
	serviceName=
	serviceMasterPass=
}


