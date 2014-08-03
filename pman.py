#!/usr/bin/python

'''

    pman v <file_name> 
        -> insert master pass
        = show all services
        
    pman s <service_name> <file_name>
        -> insert master pass
        -> insert service master pass
        = show service pass
        
    pman a <service_name> <file_name>
        -> insert master pass
        -> insert service master pass
        -> re insert service master pass 
        -> insert sercvice pass
        -> reinsert service pass 
        = add new service
        
    pman d <service_name> <file_name>
        -> insert master pass
        -> insert service master pass
        -> are you sure ? etc.
        = delete service
        
        
        
=================================    
        
--service1
passlasdkashdkasjhakjdhjasd
--service2
asldjkasjhdaksjdhasjkdh
--service3
alsdkasjhdaskjdhasjd
    
'''

import sys
from Crypto.Cipher import AES
from Crypto import Random
import os.path
import base64

from simplecrypt import encrypt, decrypt

#ciphertext = encrypt(password, 'my secret')
#plaintext = decrypt(password, ciphertext)

def checkFile(fileName):
    #check if file is empty; if empty set-up the master password
    pass

def getMasterContent():
    #return the decrypted master content
    pass

def parseMasterContent(content):
    #returns a dictionary with service name as KEY and the encrypted password as VALUE
    if len(content) == 0:
        return ''
    
    contentLines = content.split('\n')
    
    contentDict = {}
    
    for i in range(0, len(contentLines), 2):
        contentDict[contentLines[i]] = contentLines[i+1]
    
    pass

def flushData(content, fileName):
    #save content{} to file
    pass

if __name__ == '__main__':
    
    if len(sys.argv) < 2:
        print "Wrong arguments!!!!!"
        exit();
        
    firstAction = sys.argv[1]
        
    if firstAction == 'v':
        # show all services
        pass
    elif firstAction == 's':
        # show service pass
        pass
    elif firstAction == 'a':
        #add new service
        pass
    elif firstAction == 'd':
        #delete service
        pass
    else:
        print 'wrong arguments'
    
    passFileName = sys.argv[1]
    
    f = open(passFileName, 'w+')
    passFileContent = f.read()
    decContent = ''
    encContent = ''
    
    #TODO check if file exists and it's readable
    
    if len(passFileContent) == 0:
        print 'no services registered.'
        masterPassRegitered = False
        
        while not masterPassRegitered:
            newMasterPass1 = raw_input('set up a new master pass\n')
            newMasterPass2 = raw_input('re-enter the master pass\n')
            if newMasterPass1 != newMasterPass2:
                print 'p2 & p2 do not match...'
            else:
                masterPassRegitered = True
                encContent = encrypt(newMasterPass1, passFileContent)
                f.write()
                f.flush()
    else:
        masterPass = raw_input('insert the master pass...')
        decContent = decrypt(masterPass, passFileContent)
        

    
    exitCommand = False
    
    while not exitCommand:
        command = raw_input('>')
        
        if command == 'q':
            exitCommand = True
        elif command == 'h':
            print 'help stuff ' #TODO
            

    
    
