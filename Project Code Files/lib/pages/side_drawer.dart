//Importing Required Modules
import 'package:LinuxTerminal/pages/global_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

var fsconnect = FirebaseFirestore.instance;

//Side Drawer for Hostory Class
class HistoryDrawer extends StatefulWidget {
  @override
  _HistoryDrawerState createState() => _HistoryDrawerState();
}

class _HistoryDrawerState extends State<HistoryDrawer> {
  var history = [];
  getHistory() async {
    var hist = await fsconnect
        .collection("TerminalHistory")
        .orderBy('id', descending: true)
        .get();
    for (var i in hist.docs) {
      setState(() {
        history.add({
              "id": i.data()['id'],
              "command": i.data()['command'],
              "output": i.data()['output']
            } ??
            " ");
      });
    }
  }

  //Initial State of Side Drawer
  @override
  void initState() {
    history = [];
    getHistory();
    super.initState();
  }

  //Function to Create IP dialog Box
  Future outputDialog(var id) async {
    histOutput(var id) {
      var cmndOutput;
      history.forEach((element) {
        if (element['id'] == id) {
          cmndOutput = element['output'];
        }
      });
      return cmndOutput;
    }

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Its Output'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("${histOutput(id)}"),
              ],
            ),
          ),
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
    return Drawer(
        child: Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.blueGrey,
            alignment: Alignment.center,
            height: deviceHeight * 0.083,
            child: Text(
              "History",
              textScaleFactor: 2,
            ),
          ),
          Container(
            height: deviceHeight * 0.85,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    dense: true,
                    title: Text("${history[index]['command']}"),
                    leading: CircleAvatar(
                      child: Text("${history[index]['id']}"),
                    ),
                    onTap: () {
                      outputDialog(history[index]['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}
