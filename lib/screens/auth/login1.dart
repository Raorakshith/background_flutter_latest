import 'package:background_flutter_latest/screens/auth/otp.dart';
import 'package:flutter/material.dart';
class LoginScreen1 extends StatefulWidget {

  @override
  _LoginScreen1State createState() => _LoginScreen1State();
}

class _LoginScreen1State extends State<LoginScreen1> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue[800],
              Colors.blue[600],
            ],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 150,
                          margin: EdgeInsets.only(top: 40,bottom: 10,left: MediaQuery.of(context).size.width/4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/loginpage-5c70d.appspot.com/o/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png?alt=media&token=a925cb9b-a030-4d29-b581-9edae243a0e8'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(height: 20.0,
                        ),
                        Text("Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 10.0,
                        ),
                        Text("Let's check Vitamin D",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    )
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Text(
                              'Enter your Number',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                            ),
                          ),
                        ),
                        SizedBox(height: 40.0,
                        ),
                        TextFormField(

                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter Phone Number',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            prefix: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text('+91'),
                            ),
                          ),
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          controller: _controller,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          width: double.infinity,
                          child: FlatButton(
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OTPScreen(_controller.text)));
                            },
                            child: Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
