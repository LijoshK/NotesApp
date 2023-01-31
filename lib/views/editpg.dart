import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteeapp/controllers/controller.dart';
import 'package:noteeapp/views/homepg.dart';

class Editpg extends StatefulWidget {
  String title2;
  String content2;
  int index2;
   Editpg({Key? key,required this.title2,required this.content2,required this.index2 }) : super(key: key);

  @override
  State<Editpg> createState() => _EditpgState();
}

class _EditpgState extends State<Editpg> {


  TextEditingController titletxtfld = TextEditingController();
  TextEditingController contenttxtfld = TextEditingController();

  getdata()async{
    titletxtfld.text=widget.title2;
    contenttxtfld.text= widget.content2;
  }
  updatedata()async{
    await FirebaseFirestore.instance
        .collection("notes")
        .doc(docid).update({"title":titletxtfld.text.toString(),"content":contenttxtfld.text.toString()});
  }
  @override
  void initState() {
    // TODO: implement initState
    getdata();
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
                    child: Icon(Icons.arrow_back_outlined,color: Colors.black,size: 30,))
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child:Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Title", style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(


                      controller: titletxtfld,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("Content", style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: contenttxtfld,
                      maxLines: 7,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: ()  {
                        setState(() {
                          updatedata();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepg(),));
                        });

                      },
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                            color:Color.fromRGBO(225,190,50, 1),
                            borderRadius: BorderRadius.all(Radius.circular(12))),
                        child: Center(
                            child: Text("Update",
                                style: TextStyle(fontWeight: FontWeight.w600))),
                      ),
                    ),
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
