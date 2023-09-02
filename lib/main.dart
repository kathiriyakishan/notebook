import 'dart:io';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:notebook/Note%20Class.dart';
import 'package:path_provider/path_provider.dart';
import 'New Notes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appDocumentsDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentsDir.path);
  Hive.registerAdapter(noteAdapter());
  var box = await Hive.openBox("NoteApp");

  runApp(MaterialApp(home: Home(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box NoteBox = Hive.box('NoteApp');

  TextEditingController _search = TextEditingController();
  List search = [], tempSearch = [];
  bool view = true, deletebar = false;
  var _data, _data1;

  search_data() {
    for (int i = 0; i < NoteBox.length; i++) {
      _data1 = NoteBox.getAt(i) as note;
      Map m = {
        'title': _data1.title,
        'subtitle': _data1.subtitle,
        'date': _data1.date
      };
      search.add(m);
      tempSearch.add(m);
    }
  }

  @override
  void initState() {
    super.initState();
    search_data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(blurRadius: 30, offset: Offset(6, 6))
                ]),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 60,
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
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _search,
                          onChanged: (value) {
                            search = tempSearch
                                .where((element) =>
                                    element.toString().contains(value))
                                .toList();
                            print(value);
                            print(search);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                              hintText: "Search here",
                              contentPadding: EdgeInsets.all(20),
                              border: InputBorder.none),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            view = !view;
                            setState(() {});
                          },
                          icon: Icon((view)
                              ? Icons.list_alt_outlined
                              : Icons.grid_view)),
                    ],
                  ),
                ),
                (NoteBox.length == 0)
                    ? Center(
                        child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: 400,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("images/1.jpg"))),
                          ),
                          const Text("No Notes Are Available!",
                              style: TextStyle(
                                  fontSize: 25, fontStyle: FontStyle.italic)),
                        ],
                      ))
                    : Expanded(
                        child: (view)
                            ? GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: (_search.text.isEmpty)
                                    ? NoteBox.length
                                    : search.length,
                                itemBuilder: (context, index) {
                                  _data = NoteBox.getAt(index) as note;

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return NewNotes(index);
                                        },
                                      ));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(5),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(1, 3),
                                                color: Colors.grey.shade600,
                                                blurRadius: 2),
                                            BoxShadow(
                                              offset: const Offset(-2, 0),
                                              color: Colors.grey.shade400,
                                              blurRadius: 10,
                                            ),
                                          ]),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (_search.text.isEmpty)
                                                    ? "${_data.title}"
                                                    : "${search[index]['title']}",
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black),
                                                maxLines: 1,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                  (_search.text.isEmpty)
                                                      ? "${_data.subtitle}"
                                                      : "${search[index]['subtitle']}",
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  maxLines: 6),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                (_search.text.isEmpty)
                                                    ? "${_data.date}"
                                                    : "${search[index]['date']}",
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.black),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text(
                                                "Are You Want To Delete"),
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.clear)),
                                              IconButton(
                                                  onPressed: () {
                                                    NoteBox.deleteAt(index);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            const SnackBar(
                                                      content:
                                                          Text("Note Deleted"),
                                                      padding:
                                                          EdgeInsets.all(10),
                                                    ));
                                                    setState(() {});
                                                    Navigator.pushReplacement(
                                                        context,
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
                                    },
                                  );
                                },
                              )
                            : ListView.builder(
                                itemCount: NoteBox.length,
                                itemBuilder: (context, index) {
                                  _data = NoteBox.getAt(index) as note;
                                  List<bool> Doption =
                                      List.filled(NoteBox.length, false);

                                  return InkWell(
                                    onLongPress: () {
                                      deletebar = true;
                                      setState(() {});
                                    },
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return NewNotes(index);
                                        },
                                      ));
                                    },
                                    child: Container(
                                      //height: 100,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      padding:
                                          EdgeInsets.fromLTRB(10, 5, 10, 0),
                                      decoration: BoxDecoration(
                                          color: Colors.cyan.shade800,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Wrap(
                                        //crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${_data.title}",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),
                                                maxLines: 1,
                                              ),
                                              const SizedBox(height: 5),
                                              Text("${_data.subtitle}",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  maxLines: 2),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${_data.date}",
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.black),
                                              ),
                                              (deletebar)
                                                  ? Checkbox(
                                                      activeColor: Colors.black,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2)),
                                                      value: Doption[index],
                                                      onChanged: (value) {
                                                        Doption[index] = value!;
                                                        setState(() {});
                                                      },
                                                    )
                                                  : SizedBox(
                                                      height: 30,
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return NewNotes();
                },
              ));
            },
            child: Icon(
              Icons.add,
              size: 35,
            ),
            backgroundColor: Colors.black.withOpacity(0.95)));
  }
}
