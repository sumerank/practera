import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mbansw/http/StatisticsService.dart';
import 'package:mbansw/screens/DonationsScreen.dart';

import '../configs/config.dart';
import '../http/AuthService.dart';
import '../http/DonationService.dart';
import '../sharedWidgets/drawer.dart';

class DonateUsScreen extends StatefulWidget {
  const DonateUsScreen({Key? key}) : super(key: key);

  @override
  State<DonateUsScreen> createState() => _DonateUsScreenState();
}

class _DonateUsScreenState extends State<DonateUsScreen> {
  Map<String, dynamic>? paymentIntent;
  Map<String, String>? headers = {
    "Authorization":
        "Bearer sk_test_51NUSr5KEj4yLoEM3wRgEPAKHfziwXJr3tjI9U5uvGBaXXH5iuK03hGy9avhK3pnrk2CFNjTnJRRqnamkpkA0Qcfu00OuvBBqdB",
    "Content-Type": "application/x-www-form-urlencoded"
  };
  int? role = AuthService.authUser['role'] ?? 0;

  Future<void> _checkRoleAndNavigate() async {
    if ((AuthService.authUser['role'] ?? 0) == 1) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/donations',
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if ((AuthService.authUser['role'] ?? 0) == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DonationsScreen()));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DonationsScreen()),
        // );
      }
    });
  }

  final amountController = TextEditingController();
  String donationAmount = "";

  void makePayment() async {
    try {
      final paymentIntent = await createPaymentIntent();

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!["client_secret"],
          style: ThemeMode.dark,
          merchantDisplayName: "MBANSW",
          primaryButtonLabel: "Donate",
        ),
      );
      displayPaymentSheet();
    } catch (e) {
      print("Error: ");
      print(e.toString());
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": donationAmount,
        "currency": "USD",
      };

      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: headers);
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      var val = await DonationService().donate(donationAmount, false, null);
      String formattedTime =
          DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

      await StatisticsService().sendMail(
          AuthService.authUser['email'],
          AuthService.authUser['name'],
          donationAmount,
          "Donation",
          formattedTime);

      Navigator.of(context).pushNamed('/thankyou');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: Text("Donate Us"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 20,
                      right: 20,
                    ),
                    child: const Text(
                      "Please select one of the following amount of donations",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: amountController,
                          onChanged: (value) {
                            setState(() {
                              var amount;
                              // var amount = double.parse(value) * 100;
                              var cleanedValue = value.trim();
                              try {
                                if (cleanedValue.isNotEmpty) {
                                  amount = double.tryParse(cleanedValue)! * 100;
                                  donationAmount = amount.toStringAsFixed(0);
                                }
                              } catch (e) {
                                throw Exception(e.toString());
                              }
                              // var amount = double.parse(value) * 100;
                              // try {
                              //   donationAmount = amount.toStringAsFixed(0);
                              // } catch (s) {
                              //   print("Error on type cast");
                              // }
                            });
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Amount is Required'),
                          ]),
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                          decoration: InputDecoration(
                            prefixIcon:
                                const Icon(Icons.monetization_on_outlined),
                            hintText: 'Enter the Amount',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            makePayment();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              elevation: 5),
                          child: const Text("Donate"),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Text("OR,"),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/subscription');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            elevation: 5,
                          ),
                          child: const Text("Donation Subscription"),
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
      drawer: const MainDrawer(),
    );
  }
}
