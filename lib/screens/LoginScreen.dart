import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../http/AuthService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passContoller = TextEditingController();

  String email = "";
  String password = "";

  Future<bool> login() {
    var res = AuthService().login(email, password);
    return res;
  }

  @override
  void dispose() {
    emailController.dispose();
    passContoller.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => exit(0),
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        return false;
        // return Navigator.canPop(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(25, 25, 25, 50),
            child: Container(
              // alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 200,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: const Text(
                      'Welcome user | Login Form',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                    key: _formkey,
                    onChanged: () {
                      Form.of(primaryFocus!.context!)?.save();
                    },
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          onSaved: (value) {
                            email = value!;
                          },
                          validator: MultiValidator([
                            EmailValidator(errorText: 'invalid email'),
                            RequiredValidator(errorText: 'Email is Required'),
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: passContoller,
                          onSaved: (value) {
                            password = value!;
                          },
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Password is Required'),
                          ]),
                          obscureText: true,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            labelText: 'Password',
                            hintText: 'Enter your Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () {
                            if (!_formkey.currentState!.validate()) return;
                            _formkey.currentState!.save();
                            login().then((res) => {
                                  if (res)
                                    {
                                      Navigator.of(context)
                                          .pushNamed('/donateus')
                                    }
                                });
                          },
                          child: const Text('Login'),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "or, Create a new Account",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          onPressed: () =>
                              Navigator.of(context).pushNamed('/register'),
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
