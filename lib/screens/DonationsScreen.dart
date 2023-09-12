import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mbansw/configs/config.dart';
import 'package:mbansw/http/DonationService.dart';
import 'package:mbansw/sharedWidgets/drawer.dart';

import '../http/AuthService.dart';

class DonationsScreen extends StatefulWidget {
  const DonationsScreen({super.key});

  @override
  State<DonationsScreen> createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  List donations = [];

  @override
  // ignore: must_call_super
  void initState() {
    DonationService().getDonations().then((value) {
      setState(() {
        donations = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: const Text("Subscription Donation"),
        centerTitle: true,
        actions: [
          ElevatedButton(
            onPressed: () {
              AuthService().logout().then((res) =>
                  {if (res) Navigator.of(context).pushNamed('/login')});
            },
            child: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(shrinkWrap: true, slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Recent Donations",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(children: [
                        Container(
                          color: Config.primaryColor,
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: const Text('Name',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          color: Config.primaryColor,
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: const Text('Amount',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                        Container(
                          color: Config.primaryColor,
                          padding: const EdgeInsets.only(top: 5, bottom: 5),
                          child: const Text('Recurring',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ]),
                      ...List.generate(
                        donations!.length,
                        (index) => TableRow(
                          decoration: BoxDecoration(
                            color: index % 2 == 0
                                ? Colors.white
                                : Colors.grey[400],
                            // border: Border(
                            //   bottom: BorderSide(
                            //     color: Colors.grey,
                            //   ),
                            // ),
                          ),
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                donations[index]["user"]["name"],
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                "\$${donations[index]['amount']}",
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 5, bottom: 5),
                              child: Text(
                                donations[index]['recurring'] == 0
                                    ? 'One-Time'
                                    : donations[index]['interval'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Config.primaryColor,
                  child: const Text(
                    "Thank you for being part of the solution and supporting your colleagues in need.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
      drawer: const MainDrawer(),
    );
  }
}
