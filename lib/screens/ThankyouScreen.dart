import 'package:flutter/material.dart';
import 'package:mbansw/configs/config.dart';
import 'package:mbansw/sharedWidgets/drawer.dart';

import '../http/AuthService.dart';

class ThankyouScreen extends StatelessWidget {
  const ThankyouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thank you!"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 130,
                width: 130,
                decoration: BoxDecoration(
                  color: Config.primaryColor,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      spreadRadius: 1,
                      blurRadius: 15,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Text(
                  "Thank you for your donation.",
                  style: TextStyle(
                      fontSize: 20,
                      color: Config.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40),
                child: Text(
                  "Our beneficiaries often comment their colleagues' compassion in donating, is in itself, very healing.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  "Our fundraising costs are typically between 3% and 5%, so you can be confident that a very high percentage of your donation, goes to our services.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/home');
                },
                child: const Text("Go back"),
              )
            ],
          ),
        ),
      ),
      drawer: const MainDrawer(),
    );
  }
}
