import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteeapp/views/homepg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpag extends StatefulWidget {
  const Loginpag({Key? key}) : super(key: key);

  @override
  State<Loginpag> createState() => _LoginpagState();
}

class _LoginpagState extends State<Loginpag> {
  bool log = false;
  TextEditingController usernm = TextEditingController();
  TextEditingController pswrd = TextEditingController();

  setprfrnc() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("email", usernm.text);
    preferences.setString("password", pswrd.text);
  }

  final formvalidate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(5, 126, 192, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 350,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Form(
                key: formvalidate,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    log == false
                        ? Text(
                            "Login",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          )
                        : Text(
                            "Sign",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: usernm,
                        decoration: InputDecoration(hintText: "username"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: pswrd,
                        decoration: InputDecoration(hintText: "password"),
                      ),
                    ),
                    log == false
                        ? InkWell(
                            onTap: () async {
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: usernm.text,
                                        password: pswrd.text);

                                // print(usser.user!.uid);
                                setprfrnc();
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Homepg(),
                                ));
                              } catch (e) {
                                // print("$e");
                                String invalidEmail = e.toString();
                                if (invalidEmail.contains(
                                    "There is no user record corresponding to this identifier. The user may have been deleted.")) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Check email")));
                                }
                                if (invalidEmail.contains(
                                    "The password is invalid or the user does not have a password.")) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Check password")));
                                }
                              }
                            },
                            child: Container(
                                height: 50,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: Color.fromRGBO(225, 190, 50, 1)),
                                child: Center(
                                    child: Text(
                                  "Login",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))))
                        : InkWell(
                            onTap: () async {
                              final valid =
                                  formvalidate.currentState!.validate();
                              if(valid==true){
                                if(usernm.text.contains("@gmail.com")){
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                        email: usernm.text,
                                        password: pswrd.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                            Text("Created a new Account")));
                                    setprfrnc();
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Homepg(),
                                    ));
                                  }
                                  catch (e) {
                                    print("$e");
                                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Wrong")));
                                    String invalidemail = e.toString();
                                    if (invalidemail.contains(
                                        "The email address is already in use by another account")) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content:
                                              Text(" Email already exists")));
                                    }
                                    if (invalidemail.contains(
                                        "The email address is badly formatted.")) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Invalid Email-id")));
                                    }
                                    if (invalidemail.contains(
                                        "Password should be at least 6 characters")) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text("Invalid password")));
                                    }
                                  }
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Check Gmail correctly")));
                                }


                              }
                              else{
                                return  ;
                              }

                            },
                            child: Container(
                                height: 50,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    color: Color.fromRGBO(225, 190, 50, 1)),
                                child: Center(
                                    child: Text(
                                  "Sign up",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )))),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       try {
                    //         await FirebaseAuth.instance
                    //             .signInWithEmailAndPassword(
                    //                 email: usernm.text, password: pswrd.text);
                    //
                    //         // print(usser.user!.uid);
                    //         setprfrnc();
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //           builder: (context) => Homepg(),
                    //         ));
                    //       } catch (e) {
                    //         print("$e");
                    //         String invalidEmail = e.toString();
                    //         if (invalidEmail.contains(
                    //             "There is no user record corresponding to this identifier. The user may have been deleted.")) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(content: Text("Check email")));
                    //         }
                    //         if (invalidEmail.contains(
                    //             "The password is invalid or the user does not have a password.")) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(content: Text("Check password")));
                    //         }
                    //       }
                    //     },
                    //     child: )
                    // : ElevatedButton(
                    //     onPressed: () async {
                    //       try {
                    //         await FirebaseAuth.instance
                    //             .createUserWithEmailAndPassword(
                    //                 email: usernm.text, password: pswrd.text);
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //             SnackBar(
                    //                 content: Text("Created a new Account")));
                    //         setprfrnc();
                    //          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Homepg(),));
                    //       } catch (e) {
                    //         print("$e");
                    //         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something Wrong")));
                    //         String invalidemail = e.toString();
                    //         if (invalidemail.contains(
                    //             "The email address is already in use by another account")) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                   content:
                    //                       Text(" Email already exists")));
                    //         }
                    //         if (invalidemail.contains(
                    //             "The email address is badly formatted.")) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                   content: Text("Invalid Email-id")));
                    //         }
                    //         if (invalidemail.contains(
                    //             "Password should be at least 6 characters")) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                   content: Text("Invalid password")));
                    //         }
                    //       }
                    //     },
                    //     child: Text("Sign up")),
                    InkWell(
                        onTap: () {
                          setState(() {
                            log = true;
                          });
                        },
                        child: log == false
                            ? Container(
                                child: Text("Create an Account.. Sign Up"))
                            : Container(child: Text(""))),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
