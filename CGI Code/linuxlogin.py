#!/usr/bin/python3

#Importing Required Modules
import cgi
import subprocess as sp
import json

#HTTP header
print("content-type: text/html")
print()

#Retrive all the Variables from URL
loginData = cgi.FieldStorage()

#Code for Authentication
username = loginData.getvalue("username")
password = loginData.getvalue("password")
authOutput = sp.getstatusoutput("sudo echo '{1}' | su - {0}".format(username,password))
authOutput = json.dumps({"status": int(authOutput[0]), "output": authOutput[1]})
print(authOutput)

