import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool isSignedIn=false;

  String phoneNo, verificationId, smsCode;
  Future<void> verifyPhone() async {
    final PhoneVerificationCompleted verified = (FirebaseUser user) {
     print("verifier");
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value){
        print("sined in");
      });
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  Future<void> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title:  Text("Entrer code SMS"),
          content:  TextField(
            onChanged: (value) {
              this.smsCode = value;
            },
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                FirebaseAuth.instance.currentUser().then((user){
                  if(user!=null){
                    Navigator.of(context).pop();
                    print("success");
                  }
                  else{
                    Navigator.of(context).pop();
                    print("false");
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
  /*Future registerUser(String mobile, BuildContext context) async{
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: mobile,
        timeout: Duration(seconds: 60),
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null
    );
  }*/

  Widget buildHomeScreen(){
    return Text("Vous étes déja inscrit");
  }

  Scaffold buildSgnInScreen(){
    return Scaffold(
      backgroundColor: Color(0xff6CCFEE),
      body:Container(
        /*decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end:Alignment.bottomLeft,
            colors: Color(0xff6CCFEE),
          ),
        ),*/

        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: ()=>"buton tapped",
              child: Container(
                margin: EdgeInsets.all(15.0),
                width: 90.0,
                height: 90.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              "Bienvenue!",
              style: TextStyle(fontSize: 65.0,color: Colors.white,fontFamily: "Roboto-Bold"),
            ),
            Container(
              decoration: new BoxDecoration(

                  color: Colors.white,

                borderRadius:BorderRadius.circular(25.0),
              ),
              margin: EdgeInsets.all(12.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Entrer N° de téléphone",
                    fillColor: Colors.white,
                    border:OutlineInputBorder(
                      borderRadius:BorderRadius.circular(25.0),
                      borderSide:  BorderSide(
                          color: Color(0xff6CCFEE),
                      ),
                    ),
                    hintText: "06xxxxxxxx"
                ),
                onChanged: (val) {
                  setState(() {
                    this.phoneNo = val;
                  });
                },
              ),
            ),

            RaisedButton(
              onPressed: verifyPhone,
              child: Text("S'enregistrer", style: TextStyle(color: Colors.black)),
              color: Colors.blueGrey[50],
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    if(isSignedIn)
    {
      return buildHomeScreen();
    }
    else
    {
      return buildSgnInScreen();
    }

  }
}
