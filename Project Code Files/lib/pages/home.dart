//Importing Requigreen Modules
import 'dart:convert';
import 'dart:math';

import 'package:LinuxTerminal/pages/change_ip.dart';
import 'package:LinuxTerminal/pages/global_variables.dart';
import 'package:LinuxTerminal/pages/side_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//Linux App Class
class LinuxAppHome extends StatefulWidget {
  @override
  _LinuxAppHomeState createState() => _LinuxAppHomeState();
}

class _LinuxAppHomeState extends State<LinuxAppHome> {

  //Variables Local to Class
  var command, status, output, id = 0;
  var cmndInput = TextEditingController();
  FocusNode inputCmndNode;
  Color activefClr = Colors.green;
  Color activebClr = Colors.black;

  //Functions to get Host Configuration
  getHostConfFromSP(var key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  setHC () async {
    ip = await getHostConfFromSP('hostIP')  ?? "127.0.0.1";
    user = await getHostConfFromSP('User')  ?? "root";
  }


  @override
  void initState() {
    super.initState();
    setHC();
    inputCmndNode = FocusNode();
  }

  @override
  void dispose() {
    //Clean up the focus node when the Form is disposed
    inputCmndNode.dispose();
    super.dispose();
  }


  //Function to get Command Output from Linux
  runCmnd() async {
    var url = "http://$ip/cgi-bin/linuxcmnd.py?command=$command";
    var response = await http.get(url);
    var responseBody = jsonDecode(response.body);
    status = responseBody["status"];
    output = responseBody["output"];
  }


  storeOutput() async {
    var ids=[0];
    var d = await fsconnect.collection("TerminalHistory").get();
    for (var i in d.docs) {
      ids.add(i.data()['id']);
    }
    id = ids.reduce(max) + 1;

    fsconnect.collection("TerminalHistory").add({
      'id' : id,
      'command': command,
      'status': status,
      'output': output,
    });
  }


  terManage() { 
    setState(() {
      if (command == 'tput setaf 0') {
        activefClr = Colors.black;
        output = '$activefClr';
      } else if (command == 'tput setaf 1') {
        activefClr = Colors.red;
        output = '$activefClr';   
      } else if (command == 'tput setaf 2') {
        activefClr = Colors.green;  
        output = '$activefClr';    
      } else if (command == 'tput setaf 3') {
        activefClr = Colors.yellow;  
        output = '$activefClr';    
      } else if (command == 'tput setaf 4') {
        activefClr = Colors.blue;     
        output = '$activefClr'; 
      } else if (command == 'tput setaf 5') {
        activefClr = Colors.pink;   
        output = '$activefClr';   
      } else if (command == 'tput setaf 6') {
        activefClr = Colors.cyan;    
        output = '$activefClr';  
      } else if (command == 'tput setaf 7') {
        activefClr = Colors.white;    
        output = '$activefClr';  
      } else if (command == 'tput setbf 0') {
        activebClr = Colors.black;
        output = '$activebClr';
      } else if (command == 'tput setbf 1') {
        activebClr = Colors.red;      
        output = '$activebClr';
      } else if (command == 'tput setbf 2') {
        activebClr = Colors.green;    
        output = '$activebClr';  
      } else if (command == 'tput setbf 3') {
        activebClr = Colors.yellow;  
        output = '$activebClr';
      } else if (command == 'tput setbf 4') {
        activebClr = Colors.blue;     
        output = '$activebClr'; 
      } else if (command == 'tput setbf 5') {
        activebClr = Colors.pink;     
        output = '$activebClr'; 
      } else if (command == 'tput setbf 6') {
        activebClr = Colors.cyan;     
        output = '$activebClr'; 
      } else if (command == 'tput setbf 7') {
        activebClr = Colors.white;  
        output = '$activebClr';    
      } else if (command == 'tput reset' || command == 'reset') {
        activefClr = Colors.green;
        activebClr = Colors.black;
        output = 'Terminal Reset to Default';   
        lst = [];
      }
    });
  }

  Future<String> getString({int num = 1}) async {
    return "${lst.join('\n')}";
  }

  Stream<String> getStrings(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield await getString();
    }
  }

  //Function to Create IP dialog Box
  Future ipDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Host'),
          content: ChangeIP(),
          actions: <Widget>[ChngIPActions()],
        );
      },
    );
  }


  //Function to Create Help dialog Box
  Future helpDialog() async {

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: HelpDialog(),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {

    //Getting Device Dimensions
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: activebClr,
      drawer: SafeArea(child: HistoryDrawer()),
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Linux Bash', style: TextStyle(color: Colors.amber),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.laptop_mac, color: Colors.greenAccent,),
            onPressed: ipDialog,
            splashColor: Colors.red,
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.redAccent,), 
            onPressed: helpDialog,
            splashColor: Colors.green,
          ),
        ],
      ),

      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          color: activebClr,
          width: deviceWidth,
          child: StreamBuilder(
            stream: getStrings(Duration(microseconds: 1)),
            builder: (context, stream) {
              if (stream.hasData) {
                return Container(child: Text('${stream.data}', style: TextStyle(color: activefClr),));
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),

        Container(
          padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          color: activebClr,
          width: deviceWidth,
          child: Column(
            children: <Widget>[
              TextField(
                autofocus: true,
                focusNode: inputCmndNode,
                cursorColor: activefClr,
                controller: cmndInput,
                style: TextStyle(
                  color: activefClr,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixText: '[${user ?? 'root'}@${ip ?? '127.0.0.1'}]# ',
                  prefixStyle: TextStyle(
                    color: activefClr,
                  )
                ),
                onSubmitted: (value) async {
                  command = value;
                  await runCmnd();
                  terManage();
                  lst.add("[$user@$ip]# $value\n$output");
                  if (command == 'clear') {
                    lst = [];
                  }
                  cmndInput.clear();
                  inputCmndNode.requestFocus();
                  storeOutput();
                },
              ),
            ],
          ),
        ),
      ],
            ),
          ),
        ),
    );
  }
}
