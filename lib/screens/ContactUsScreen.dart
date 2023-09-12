import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mbansw/configs/config.dart';
import 'package:mbansw/sharedWidgets/drawer.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
        backgroundColor: Config.primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(children: [
              // Text(
              //   "CONTACT US",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       color: Config.primaryColor,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 30),
              // ),

              const Image(
                image: AssetImage('assets/images/logo.png'),
                height: 150,
                width: 150,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                    ),
                    children: [
                      TextSpan(text: 'All donation inquiries\nPh:'),
                      TextSpan(
                        text: ': 02 9987 0504 (Option 2)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' or \n'),
                      TextSpan(
                        text: 'finance@mbansw.org.au',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                    ),
                    children: [
                      const TextSpan(
                          text:
                              'If you, a family member or a colleague would like to know more about our counselling, social work and/or support services, please call for a confidential chat'),
                      const TextSpan(
                        text: '02 9987 0504 (Option 1)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' or via email at '),
                      const TextSpan(
                        text: 'support@mbansw.org.au',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '\nwww.mbansw.org.au',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Config.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                "All communication is strictly confidential as is any information about assistance given.",
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w300,
                    ),
                    children: [
                      TextSpan(text: 'We are open'),
                      TextSpan(
                        text: ' Monday to Friday: 9.00 am - 5.00 pm. ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text:
                              'Contact outside these hours is possible by appointment only.'),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
      drawer: const MainDrawer(),
    );
  }
}
