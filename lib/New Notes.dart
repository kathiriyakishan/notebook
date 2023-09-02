import 'dart:core';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notebook/Note%20Class.dart';

import 'main.dart';

class NewNotes extends StatefulWidget {
  int? ind;

  NewNotes([this.ind]);

  @override
  State<NewNotes> createState() => _NewNotesState();
}

class _NewNotesState extends State<NewNotes> {
  TextEditingController _title = TextEditingController();
  TextEditingController _subtitle = TextEditingController();
  Box NoteBox = Hive.box('NoteApp');
  bool temp = false;
  var _data;

  @override
  void initState() {
    super.initState();
    print(widget.ind);

    if (widget.ind != null) {
      _data = NoteBox.getAt(widget.ind!);
      _title.text = _data.title;
      _subtitle.text = _data.subtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(6, 6),
              )
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 20, offset: Offset(6, 6), spreadRadius: 2)
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            if (_title.text.isEmpty && _subtitle.text.isEmpty) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Home();
                                },
                              ));
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Are You Want Discard ?"),
                                    actions: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.clear)),
                                      IconButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                              builder: (context) {
                                                return Home();
                                              },
                                            ));
                                          },
                                          icon: const Icon(Icons.done)),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.arrow_circle_left_rounded,
                            size: 32,
                          )),

                      //-----Delete----------------
                      (widget.ind != null)
                          ? IconButton(
                              onPressed: () {
                                NoteBox.deleteAt(widget.ind!);

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Note Deleted"),
                                  padding: EdgeInsets.all(10),
                                ));
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Home();
                                  },
                                ));
                              },
                              icon: const Icon(
                                Icons.delete,
                                size: 32,
                              ))
                          : const Text(
                              'Add Note',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),

                      IconButton(
                          onPressed: () {
                            String title, subtitle, Today;
                            title = _title.text;
                            subtitle = _subtitle.text;
                            DateTime now = new DateTime.now();
                            DateTime date =
                                new DateTime(now.year, now.month, now.day);

                            Today = date.toString().substring(0, 10);

                            if (widget.ind != null) {
                              _data.title = title;
                              _data.subtitle = subtitle;
                              _data.save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Note Updated")));
                              setState(() {});
                              Navigator.pop(context);
                            } else {
                              if (title.isEmpty || subtitle.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Filed Empty.")));
                              } else {
                                note add = note(title, subtitle, Today);
                                NoteBox.add(add);
                                //setState(() {});
                                Navigator.pop(context);
                              }
                            }
                          },
                          icon: const Icon(
                            Icons.save,
                            size: 32,
                          )),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Container(
                        width : double.infinity,
                        child: Card(
                          child: TextField(
                            controller: _title,
                            cursorColor: Colors.black,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Title",
                                hintStyle: TextStyle(
                                    fontSize: 15, color: Colors.grey.shade400)),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Card(
                          child: TextField(
                            controller: _subtitle,
                            maxLines: null,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.only(top: -8),
                                hintText: "Note",
                                hintStyle: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade400)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
