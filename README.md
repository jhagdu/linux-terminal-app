# Linux Terminal Flutter App
This repo contains the Flutter Dart code, CGI Code of API and apk Build Release of Linux Terminal App

# Use APK   
Download the Apk from this git repo, then install and use it
  
  
# For further development  
# Pre-requisite :-   
Flutter should be installed and configured in your system  

# How to start :-  
Open Terminal/CMD and run command "flutter create AnimatedApp"  
  
After that replace your lib and test folder with my lib and test folders  

# dependencies :- 
Also replace your pubspec.yaml file with mine or Go to your pubspec.yaml file and then write these dependencies there.  
- cupertino_icons: ^1.0.0
- cloud_firestore: ^0.14.0+2
- firebase_core: ^0.5.0
- shared_preferences: ^0.5.8
- toast: ^0.1.5

# Run App :-  
Now App is ready to run -   
- If you are using VSCode, then you can Directly run it using Run without Debugging  
- If you are not using VSCode, So you can run it using "flutter run" command  
  
# Enabling API :-  
- As this app is working over API to run linux commands, so we have to enable API in our Linux Host  
- So for that Start the webserver in that and Cpoy my CGI Files in cgi-bin directory of your webserver  
- Also give permissions to run commands to your webserver service user i.e. apache  
  
# Some more things :-  
As this app is using firestore, so for full functionality of the app you have to connect this with firestore  
  
# Links :-  
YouTube Video :- Coming Soon  
Post :- Coming Soon  
Article :- Coming Soon  
