import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteeapp/views/homepg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notesadd extends StatefulWidget {
  const Notesadd({Key? key}) : super(key: key);

  @override
  State<Notesadd> createState() => _NotesaddState();
}

class _NotesaddState extends State<Notesadd> {
  String? emailid;

  getprfrnc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      emailid = preferences.getString("email");
      var data2 = preferences.getString("password");
    });
  }

  adddata() async {
    await FirebaseFirestore.instance.collection("notes").add({
      "title": txtfld1.text,
      "content": txtfld2.text,
      "email": emailid,
      "date": DateTime.now()
    });
  }

  TextEditingController txtfld1 = TextEditingController();
  TextEditingController txtfld2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    getprfrnc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(5,126,192, 1),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Icon(Icons.arrow_back_outlined,size: 30,color: Colors.black,)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white60),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Title ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: txtfld1,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Content ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: TextField(
                        controller: txtfld2,
                        maxLines: 4,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                         await adddata();
                          // await FirebaseFirestore.instance.collection("notes").add({})
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Homepg(),
                          ));
                        },
                        child: Container(
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(225,190,50, 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                              child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
