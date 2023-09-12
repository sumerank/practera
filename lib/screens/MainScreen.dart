import 'dart:io';

import 'package:flutter/material.dart';

import '../configs/config.dart';
import '../http/AuthService.dart';
import '../sharedWidgets/drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static Color primary = Config.primaryColor;

  @override
  createState() => _MainScreenState();
}

class Choice {
  const Choice({required this.title, required this.onPress});
  final String title;
  final Function onPress;
}

class _MainScreenState extends State<MainScreen> {
  String? name = AuthService.authUser['name'] ?? "Guest";
  int? role = AuthService.authUser['role'] ?? 0;

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = <Choice>[
      Choice(
        title: "Donate Us",
        onPress: () {
          Navigator.of(context).pushNamed('/donateus');
        },
      ),
    ];

    if (role == 1) {
      choices = <Choice>[
        Choice(
          title: "Donations",
          onPress: () {
            Navigator.of(context).pushNamed('/donations');
          },
        ),
      ];
    }

    // ignore: no_leading_underscores_for_local_identifiers
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

    // return WillPopScope(
    //   onWillPop: _onWillPop,
    //   child: Scaffold(
    //     body: SafeArea(
    //       child: Column(
    //         children: [
    //           AppBar(
    //             title: const Text("MBANSW"),
    //             centerTitle: true,
    //             automaticallyImplyLeading: false,
    //             actions: [
    //               ElevatedButton(
    //                 onPressed: () {
    //                   AuthService().logout().then((res) =>
    //                       {if (res) Navigator.of(context).pushNamed('/login')});
    //                 },
    //                 child: const Icon(Icons.logout_outlined),
    //               ),
    //             ],
    //           ),
    //           const SizedBox(
    //             height: 20,
    //           ),
    //           Text(
    //             "Welcome ${AuthService.authUser['name']}",
    //             style: const TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.bold,
    //             ),
    //           ),
    //           Expanded(
    //             child: GridView.count(
    //               padding: const EdgeInsets.all(20),
    //               // horizontal, this produces 2 rows.
    //               crossAxisCount: 1,
    //               shrinkWrap: true,
    //               crossAxisSpacing: 20,
    //               mainAxisSpacing: 20,
    //               childAspectRatio: 5,
    //               // Generate 100 widgets that display their index in the List.
    //               children: List.generate(choices.length, (index) {
    //                 return ElevatedButton(
    //                   child: Center(
    //                     child: Text(
    //                       choices[index].title,
    //                       textAlign: TextAlign.center,
    //                       style: const TextStyle(
    //                         fontSize: 25,
    //                       ),
    //                     ),
    //                   ),
    //                   onPressed: () {
    //                     choices[index].onPress();
    //                   },
    //                 );
    //               }),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Config.primaryColor,
          title: Text("MBANSW"),
          centerTitle: true,
          // actions: [
          //   ElevatedButton(
          //     onPressed: () {
          //       AuthService().logout().then((res) =>
          //           {if (res) Navigator.of(context).pushNamed('/login')});
          //     },
          //     child: const Icon(Icons.logout_outlined),
          //   ),
          // ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              // color: Config.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Image(
                    image: AssetImage('assets/images/logo.png'),
                    height: 150,
                    width: 150,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: Text(
                      "With thanks to donors just like you, MBANSW has been caring for doctors and their families for since1896. ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "Your kind donation today will help MBANSW encourage doctors to make contact before things get worse. They will be given a safe space to work through the issue with our team of experienced social workers and referral partners, to identify strengths and come to their own solution. Where needed, financial assistance will be provided to enable the doctor to take a break, knowing household bills are taken care of while they recover.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Text(
                      "We know there is so much more we can do with your continued generosity",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Config.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: Text(
                      "Please DONATE TODAY so that any doctor experiencing burnout or any significant life challenge, can access our services and feel safe and supported whilst they recover and hopefully return to their vocation. Doctors simply cannot be replaced in a year, so we need to truly value them, especially when things get tough.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Text(
                      "Scan this QR code to donate by credit card and be issued with a Tax Receipt immediately.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Config.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Image(
                    image: AssetImage('assets/images/qr.png'),
                    height: 80,
                  ),
                  GridView.count(
                    padding: const EdgeInsets.all(20),
                    crossAxisCount: 1,
                    shrinkWrap: true,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: 5,
                    children: List.generate(choices.length, (index) {
                      return ElevatedButton(
                        child: Center(
                          child: Text(
                            choices[index].title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onPressed: () {
                          choices[index].onPress();
                        },
                      );
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
        drawer: const MainDrawer(),
      ),
    );
  }
}
