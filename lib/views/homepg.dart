import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteeapp/views/clickpg.dart';
import 'package:noteeapp/views/loginpg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/controller.dart';
import 'notesadd.dart';

class Homepg extends StatefulWidget {
  const Homepg({Key? key}) : super(key: key);

  @override
  State<Homepg> createState() => _HomepgState();
}

class _HomepgState extends State<Homepg> {
  int selectedIndex = 0;

  getdata() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      emailid = preferences.getString("email");
    });
  }

  deletedata(dynamic id) async {
    await FirebaseFirestore.instance.collection("notes").doc(id).delete();
  }

  List<dynamic> notes = [];
  List<dynamic> searchnotes = [];

  TextEditingController searchtxt = TextEditingController();

  showdata(String items) {
    searchnotes.clear();
    notes.forEach((element) {
      if (element["title"].toString().contains(items) ||
          element["content"].toString().contains(items)) {
        setState(() {
          searchnotes.add({
            "title": element["title"].toString(),
            "content": element["content"].toString()
          });
        });
      }
    });
  }

  bool search = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      shape: BoxShape.circle)),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(emailid.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              ),
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Loginpag(),));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Center(
                      child: Text("LogOut",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(225, 190, 50, 1),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Notesadd(),
          ));
        },
      ),
      backgroundColor: Color.fromRGBO(5, 126, 192, 1),
      body: SafeArea(
        child: Column(
          children: [
            // Stepper(steps:[
            //   Step(title: Text("hello"), content:Text("world")),
            //   Step(title: Text("hello"), content: Container(
            //     decoration: BoxDecoration(color: Colors.white),
            //   )),
            // ]),
             Container(
              height: 40,
              width: 320,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: TextField(
                controller: searchtxt,
                onChanged: (value){
                  showdata(value);
                  search=true;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.search),
                  ),
                  hintText: "Search from notes",
                ),
              ),
              // Row(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(left: 8.0),
              //       child: Icon(Icons.search),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.only(left: 14.0),
              //       child: Text("Search from notes"),
              //     ),
              //   ],
              // ),
           ),

            Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("notes")
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasData) {
                        notes.clear();

                        snapshot.data!.docs.forEach((element) {
                          if (emailid == element.data()["email"]) {
                            notes.add(element);
                          }
                        });

                        return

                         search==false? GridView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  selectedIndex = index;
                                  docid = notes[index].id;
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Clickpg(
                                        title: notes[index]["title"],
                                        content: notes[index]["content"],
                                        index: index),
                                  ));
                                },
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          notes[index]["title"],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          notes[index]["content"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 4,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 108.0, top: 30, bottom: 8),
                                        child: InkWell(
                                            onTap: () {
                                              deletedata(notes[index].id);
                                            },
                                            child: Icon(Icons.delete)),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                            // childAspectRatio: 2 / 2
                          ),
                        ):GridView.builder(
                           itemCount: searchnotes.length,
                           itemBuilder: (context, index) {
                             return Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: InkWell(
                                 onTap: () {
                                   selectedIndex = index;
                                   docid = notes[index].id;
                                   Navigator.of(context).push(MaterialPageRoute(
                                     builder: (context) => Clickpg(
                                         title: searchnotes[index]["title"],
                                         content: searchnotes[index]["content"],
                                         index: index),
                                   ));
                                 },
                                 child: Container(
                                   height: MediaQuery.of(context).size.height,
                                   decoration: BoxDecoration(
                                       color: Colors.white,
                                       borderRadius:
                                       BorderRadius.all(Radius.circular(8))),
                                   child: Column(
                                     mainAxisAlignment:
                                     MainAxisAlignment.spaceEvenly,
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text(
                                           searchnotes[index]["title"],
                                           style: TextStyle(
                                               fontWeight: FontWeight.bold),
                                         ),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text(
                                           searchnotes[index]["content"],
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                           ),
                                           maxLines: 4,
                                         ),
                                       ),
                                       Padding(
                                         padding: const EdgeInsets.only(
                                             left: 108.0, top: 30, bottom: 8),
                                         child: InkWell(
                                             onTap: () {
                                               deletedata(searchnotes[index].id);
                                             },
                                             child: Icon(Icons.delete)),
                                       )
                                     ],
                                   ),
                                 ),
                               ),
                             );
                           },
                           gridDelegate:
                           SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,
                             crossAxisSpacing: 4,
                             mainAxisSpacing: 4,
                             // childAspectRatio: 2 / 2
                           ),
                         );
                      } else {
                        return Text(
                          "Make a note",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      }

                      // else

                      //   {
                      //     Text("");
                      //   }
                    })),

            // Center(
            //   child: Container(
            //     height: 50,
            //     width: 60,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Color.fromRGBO(236, 102, 102, 1),
            //     ),
            //     child: Icon(
            //       Icons.add,
            //       color: Colors.white,
            //       size: 40,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
