//Importing Required Modules
import 'dart:convert';

import 'package:LinuxTerminal/pages/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var newIP, uname, passwd;

class ChangeIP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 240,
        child: Column(
          children: <Widget>[
            Card(
              elevation: 10,
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp("[ ]")),
                  ],
                  decoration: InputDecoration(
                    labelText: "Host IP",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  onChanged: (value) {
                    newIP = value;
                  },
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Host Username",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  onChanged: (value) {
                    uname = value;
                  },
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Container(
                margin: EdgeInsets.all(5),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                  ),
                  onChanged: (value) {
                    passwd = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Function to Change Host Configuations
setHostConfToSP(var key, val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, val);
}

var loginStatus, loginOutput;
//Function to Login
appLogin() async {
  var url =
      "http://$newIP/cgi-bin/linuxlogin.py?username=$uname&password=$passwd";
  print(url);
  var response = await http.get(url);
  var responseBody = jsonDecode(response.body);
  loginStatus = responseBody["status"];
  loginOutput = responseBody["output"];
}

class HelpDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(
              "1) When Changing the Host, Make Sure that IP you connect must be reachable and have CGI Files\n"),
          Text("2) Not Liking Light Theme, Turn on dark Mode in you mobile\n"),
          Text("3) Run 'clear' command to clear the Screen\n"),
          Text(
              "4) Use 'tput' command with 'setaf' and 'setbf' subcommand to change colors\n"),
          Text(
              "4) Open Side Drawer to see History and to see output of any command in history Click on it"),
        ],
      ),
    );
  }
}

class ChngIPActions extends StatefulWidget {
  @override
  _ChngIPActionsState createState() => _ChngIPActionsState();
}

class _ChngIPActionsState extends State<ChngIPActions> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      isLoading ? CircularProgressIndicator() : Container(),
      FlatButton(
        padding: EdgeInsets.fromLTRB(30, 0, 5, 0),
        child: Text('Change'),
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          await appLogin();
          if (loginStatus == 0) {
            setState(() {
              setHostConfToSP('hostIP', newIP);
              ip = newIP;
              setHostConfToSP('User', uname);
              user = uname;
            });
            lst = [loginOutput];
            Navigator.of(context).pop();
          } else {
            lst = [loginOutput];
            Navigator.of(context).pop();
          }
          setState(() {
            isLoading = false;
          });
        },
      ),
      FlatButton(
        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
        child: Text('Cancel'),
        onPressed: () {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        },
      ),
    ]);
  }
}
