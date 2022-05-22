import 'package:flappy_bird_flutter/services/auth.dart';
import 'package:flappy_bird_flutter/shared/constants.dart';
import 'package:flappy_bird_flutter/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  const SignIn({Key? key, required this. toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 0.0,
        title: const Text("Sign in to Flappy bird"),
        actions: <Widget>[
          FlatButton.icon(
            icon: const Icon(Icons.person),
            label: const Text("Register"),
            onPressed: (){ // Switch view
              widget.toggleView();
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children:  <Widget>[
                    const SizedBox(height: 15.0,),
                    TextFormField( // Email
                      decoration: textInputDecoration.copyWith(hintText: "Email"),
                      validator: (val) => val!.isEmpty ? "Please enter a valid e-mail address!" : null,
                      onChanged: (val){
                        setState(() { email = val; });
                      }
                    ),
                    const SizedBox(height: 15.0,),
                    TextFormField( // Password
                      decoration: textInputDecoration.copyWith(hintText: "Password"),
                      obscureText: true,
                      validator: (val) => val!.length < 6 ? "Please enter a password 6 or more characters long!" : null,
                      onChanged: (val){
                        setState(() { password = val; });
                      }
                    ),
                    const SizedBox(height: 15.0,),
                    RaisedButton( // Sing in button
                       color: Colors.deepOrange,
                       child:
                        const Text("Sign in", style: TextStyle(color: Colors.white)
                       ),
                       onPressed: () async {
                         if(_formKey.currentState!.validate()){
                           setState(() { loading = true; });
                           dynamic result = await _auth.signIn(email, password);
                           if(result == null){
                             setState(() {
                               error = "Invalid e-mail or password!";
                               loading = false;
                             });
                           }
                         }
                       },
                    ),
                    const SizedBox(height: 15.0,),
                    Text(error, style: const TextStyle(color: Colors.red, fontSize: 14.0))
                  ],
                ),
              )
            ),
          ),
          Container( // Grass
            height: 25,
            color: Colors.green,
          ),
          Expanded( // Ground
              child: Container(
                color: Colors.brown,
              )
          )
        ]
      ),
    );
  }
}
