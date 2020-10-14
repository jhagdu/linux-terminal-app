#!/usr/bin/python3

#Importing Required Modules
import cgi
import subprocess as sp
import json

#HTTP header
print("content-type: text/html")
print()

#Retrive all the Variables from URL
inputData = cgi.FieldStorage()

#Code to Run Linux Command and get Output
command = inputData.getvalue("command")
cmndOutput = sp.getstatusoutput("sudo {0}".format(command))
cmndOutput = json.dumps({"status": int(cmndOutput[0]), "output": cmndOutput[1]})
print(cmndOutput)

