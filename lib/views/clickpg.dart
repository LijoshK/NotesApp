import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteeapp/controllers/controller.dart';
import 'package:noteeapp/views/editpg.dart';

class Clickpg extends StatefulWidget {
  String title;
  String content;
  int index;
   Clickpg({Key? key,required this.title,required this.content,required this.index}) : super(key: key);

  @override
  State<Clickpg> createState() => _ClickpgState();
}

class _ClickpgState extends State<Clickpg> {

  deletedata()async{
    await FirebaseFirestore.instance.collection("notes").doc(docid).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(5,126,192, 1),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: (){
                            Navigator.of(context).pop();
                          },
                          child: Icon(Icons.arrow_back_outlined,color: Colors.black,size: 30,))
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Title :",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.title,
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Content :",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.content,
                                style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Editpg(title2: widget.title, content2: widget.content, index2: widget.index)
                                ));
                              },
                              child: Container(
                                height: 50,
                                width: 80,
                                decoration: BoxDecoration(
                                    color:Color.fromRGBO(225,190,50, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(12))),
                                child: Center(
                                    child: Text("Edit",
                                        style: TextStyle(fontWeight: FontWeight.w500))),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              deletedata();
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 50,
                              width: 80,
                              decoration: BoxDecoration(
                                  color:Color.fromRGBO(225,190,50, 1),
                                  borderRadius: BorderRadius.all(Radius.circular(12))),
                              child: Center(
                                  child: Text("Delete",
                                      style: TextStyle(fontWeight: FontWeight.w500))),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            )


          ],
        ),
      ),
    );
  }
}
