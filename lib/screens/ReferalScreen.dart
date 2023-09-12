import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mbansw/configs/config.dart';
import 'package:mbansw/sharedWidgets/drawer.dart';

class ReferalScreen extends StatefulWidget {
  const ReferalScreen({super.key});

  @override
  State<ReferalScreen> createState() => _ReferalScreenState();
}

class _ReferalScreenState extends State<ReferalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Referal"),
        backgroundColor: Config.primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "HOW TO MAKE \nA REFERAL",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Config.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            const Image(
              image: AssetImage('assets/images/hand_shake.jpg'),
              fit: BoxFit.cover,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
              child: Text(
                "If you, a family member or a colleague are in need of support, please contact us to arrange a confidential chat with either our Social Worker or Counsellor, to discuss how MBANSW may be able to assist.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Config.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
              child: Text(
                textAlign: TextAlign.justify,
                'Most people contact us directly to talk about their situation. We also receive referrals from colleagues, employers, family, support services and treating health practitioners. No referral is required. Our service is free. No forms are needed. A telephone call or an email through our website is the best way to get in touch. \n \nPeople who make contact earlier, rather than later, often have a more positive outcome. So please don’t delay in reaching out if something is worrying you.',
              ),
            ),
            Container(
              color: Config.secondaryColor,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300,
                    ),
                    children: [
                      TextSpan(
                          text:
                              'For a confidential chat please contact our Counselling and Support Team on '),
                      TextSpan(
                        text: '02 9987 0504 (Option 1)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' or via email at '),
                      TextSpan(
                        text: 'support@mbansw.org.au',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        )),
      ),
      drawer: const MainDrawer(),
    );
  }
}
