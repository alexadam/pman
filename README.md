pman
====

Password Manager

![alt ex1.png](https://github.com/alexadam/pman/blob/master/ex1.png?raw=true "ex1.png")

How to use it:

source pman.sh

then:

```
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
```

pman.sh sha512sum:

9a0f2e2537668da7c074a0bb0056e30b4f21f3df62d61a574f310e7b04be525af1819426643ef7a2f00cac287ffac1afdf6caa2311f9f8ba41aeb004e9bba004

drawing made with: www.draw.io
