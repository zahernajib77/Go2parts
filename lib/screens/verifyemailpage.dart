import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'common/theme_helper.dart';
import 'home.dart';
import 'login.dart';
class verifyEmailPage extends StatefulWidget {
  const verifyEmailPage({Key? key}) : super(key: key);

  @override
  _verifyEmailPageState createState() => _verifyEmailPageState();
}

class _verifyEmailPageState extends State<verifyEmailPage> {
  bool isEmailverified=false;
  bool canResendEmail=false;
  Timer ? timer;
  @override
  void initState(){
    super.initState();
    isEmailverified=FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailverified){
      sendVerificationEmail();

      timer=Timer.periodic(Duration(seconds:3), (_) =>checkEmailVerified());

    }
  }
  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {

      isEmailverified=FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailverified){timer!.cancel();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Homepage()));


    }

  }


  Future sendVerificationEmail() async{
    try  {
      final user =FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(()=>canResendEmail=false );
      await Future.delayed(Duration(seconds: 5));
      setState(()=>canResendEmail=true );



    }catch(e){
     print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text("Email verification"),
        ),
        body:
        Container(
          child: Column(
            children: [
              Text(" A verification email has been sent to your email"),

              SizedBox(height: 50,),
              InkWell(
                child: Column(
                  children: [
                    ElevatedButton.icon(onPressed: (){
                      canResendEmail?  sendVerificationEmail:null;
                    }, icon: Icon(Icons.email), label:Text('Resent email')),

                    SizedBox(width: 20,),
                    InkWell(
                        child: ElevatedButton(
                          // style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding:
                            EdgeInsets.fromLTRB(50, 0, 50, 0),
                            child: Text(
                              'close'.toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,

                              ),
                            ),
                          ),onPressed: (){
                          FirebaseAuth.instance.signOut();
                          // Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             loginpage()));
                        },

                        )
                    )


                  ],
                ),
              )


            ],
          ),
        )


      );
    }


  }

