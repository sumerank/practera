import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../configs/config.dart';
import '../http/AuthService.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();

  String firstName = "";
  String lastName = "";
  String email = "";
  String confirmEmail = "";
  String contactNumber = "";
  String country = "";
  String state = "";
  String city = "";
  String password = "";
  String confirmPassword = "";

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmEmailController = TextEditingController();
  final contactNumberController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<bool> register() {
    var res = AuthService().register(
      firstName,
      lastName,
      email,
      confirmEmail,
      contactNumber,
      country,
      state,
      city,
      password,
      confirmPassword,
    );
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Config.primaryColor,
          title: const Text("Registration"),
          centerTitle: true,
          leading: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // AuthService().logout().then((res) =>
              //     {if (res) Navigator.of(context).pushNamed('/login')});
            },
            child: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: const Text(
                  'New user | Registration Form',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Form(
                key: _formkey,
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: () {
                  Form.of(primaryFocus!.context!)?.save();
                },
                child: Column(
                  children: [
                    // First Name
                    TextFormField(
                      controller: firstNameController,
                      onSaved: (value) {
                        firstName = value!;
                      },
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'First Name is Required'),
                      ]),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Last Name
                    TextFormField(
                      controller: lastNameController,
                      onSaved: (value) {
                        lastName = value!;
                      },
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Last Name is Required'),
                      ]),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        labelText: 'Last Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Confirm Email
                    TextFormField(
                      controller: confirmEmailController,
                      onSaved: (value) {
                        confirmEmail = value!;
                      },
                      validator: (value) {
                        if (emailController.text == value) {
                          return null;
                        }
                        return "Email does not match";
                      },
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Confirm Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Contact no.
                    TextFormField(
                      controller: contactNumberController,
                      onSaved: (value) {
                        contactNumber = value!;
                      },
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: 'Contact Number is Required'),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        labelText: 'Contact no.',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Country
                    // TextFormField(
                    //   controller: countryController,
                    //   onSaved: (value) {
                    //     country = value!;
                    //   },
                    //   validator: MultiValidator([
                    //     RequiredValidator(errorText: 'Country is Required'),
                    //   ]),
                    //   keyboardType: TextInputType.emailAddress,
                    //   style: const TextStyle(
                    //       fontSize: 16, fontWeight: FontWeight.normal),
                    //   decoration: InputDecoration(
                    //     prefixIcon: const Icon(Icons.flag),
                    //     labelText: 'Country',
                    //     border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0)),
                    //   ),
                    // ),
                    // State
                    TextFormField(
                      controller: stateController,
                      onSaved: (value) {
                        state = value!;
                      },
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'State is Required'),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.place),
                        labelText: 'State',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // City
                    TextFormField(
                      controller: cityController,
                      onSaved: (value) {
                        city = value!;
                      },
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'city is Required'),
                      ]),
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.place),
                        labelText: 'City',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password
                    TextFormField(
                      controller: passwordController,
                      onSaved: (value) {
                        password = value!;
                      },
                      validator: MultiValidator([
                        MaxLengthValidator(15,
                            errorText: 'should be less than 15 charactert'),
                        MinLengthValidator(6,
                            errorText: 'should be at least 6'),
                        RequiredValidator(errorText: 'Password is Required'),
                      ]),
                      obscureText: true,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Confirm Password
                    TextFormField(
                      controller: confirmPasswordController,
                      onSaved: (value) {
                        confirmPassword = value!;
                      },
                      validator: (value) {
                        if (passwordController.text == value) {
                          return null;
                        }
                        return "Password does not match";
                      },
                      obscureText: true,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        if (!_formkey.currentState!.validate()) return;
                        register().then((res) => {
                              if (res)
                                {Navigator.of(context).pushNamed('/home')}
                            });
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
