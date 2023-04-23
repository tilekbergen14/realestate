import "dart:math";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:realestate/pages/home.dart";
import "package:realestate/pages/root.dart";
import "../models/auth.dart";

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  var _passwordVisible = false;
  var _login = true;
  String? _error = "";
  bool _isLoading = false;
  final email = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          height: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$_error",
                style: TextStyle(color: Colors.red),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Email',
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: TextField(
                  controller: password,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Password',
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              !_login
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: password2,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Confirm Password',
                          labelText: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: const Text(""),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _login
                        ? "Don't have an account?"
                        : "Already have an account?",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _login = !_login;
                        _error = "";
                      });
                    },
                    child: Text(
                      _login ? " Sign up" : " Sign in",
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40),
                ),
                onPressed: () {
                  _login
                      ? SignInWithEmailAndPassword()
                      : CreateUserWithEmailAndPassword();
                },
                child: Text(
                  _login ? "Login" : " Register",
                ),
              )
            ],
          ),
        ),
      ),
      if (_isLoading)
        const Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ),
      if (_isLoading)
        const Center(
          child: CircularProgressIndicator(),
        ),
    ]);
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> SignInWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
        _error = "";
      });
      await Auth().signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Navigator.push(context, MaterialPageRoute(builder: (_) => RootApp()));
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }

  Future<void> CreateUserWithEmailAndPassword() async {
    try {
      setState(() {
        _isLoading = true;
        _error = "";
      });
      var loggedUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(loggedUser.user?.uid)
          .set({"profile": "", "username": "", "lastMessageTime": ""});
      Navigator.push(context, MaterialPageRoute(builder: (_) => RootApp()));
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
      });
    }
  }
}
