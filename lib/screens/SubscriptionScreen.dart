import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mbansw/http/DonationService.dart';
import 'package:mbansw/sharedWidgets/drawer.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../http/AuthService.dart';
import '../http/StatisticsService.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final client = http.Client();
  Map<String, String>? headers = {
    "Authorization":
        "Bearer sk_test_51NUSr5KEj4yLoEM3wRgEPAKHfziwXJr3tjI9U5uvGBaXXH5iuK03hGy9avhK3pnrk2CFNjTnJRRqnamkpkA0Qcfu00OuvBBqdB",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  TextEditingController amountController = TextEditingController();
  String donationAmount = "5000";
  String donationAmountManual = "";
  String interval = "day";
  bool isLoading = false;

  CardEditController cardController = CardEditController();

  // ignore: prefer_typing_uninitialized_variables
  var customerCard;

  Future<Map<String, dynamic>> _createCustomer() async {
    const String url = 'https://api.stripe.com/v1/customers';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'description': 'new customer',
        "email": AuthService.authUser['email'],
        "name": AuthService.authUser['name']
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'Failed to register as a customer.';
    }
  }

  Future<Map<String, dynamic>> _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'type': 'card',
        'card[number]': '$number',
        'card[exp_month]': '$expMonth',
        'card[exp_year]': '$expYear',
        'card[cvc]': '$cvc',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'Failed to create PaymentMethod.';
    }
  }

  Future<Map<String, dynamic>> _attachPaymentMethod(
      String paymentMethodId, String customerId) async {
    final String url =
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'Failed to attach PaymentMethod.';
    }
  }

  Future<Map<String, dynamic>> _updateCustomer(
      String paymentMethodId, String customerId) async {
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'Failed to update Customer.';
    }
  }

  Future<Map<String, dynamic>> _createSubscriptions(
      String customerId, String priceId) async {
    const String url = 'https://api.stripe.com/v1/subscriptions';

    Map<String, dynamic> body = {
      'customer': customerId,
      'items[0][price]': priceId,
    };

    var response =
        await client.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw 'Failed to register as a subscriber.';
    }
  }

  Future<void> subscriptions(priceId) async {
    final customer = await _createCustomer();
    final paymentMethod = await _createPaymentMethod(
        number: customerCard.number.toString(),
        expMonth: customerCard.expiryMonth.toString(),
        expYear: customerCard.expiryYear.toString(),
        cvc: customerCard.cvc.toString());
    await _attachPaymentMethod(paymentMethod['id'], customer['id']);
    await _updateCustomer(paymentMethod['id'], customer['id']);
    await _createSubscriptions(customer['id'], priceId);
  }

  Future<String> getDonationId() async {
    const String url = "https://api.stripe.com/v1/products";
    var response = await client.get(Uri.parse(url), headers: headers);

    var products = json.decode(response.body);

    for (var product in products["data"]) {
      if (product["name"] == "Donation") {
        return product['id'];
      }
    }

    return "";
  }

  final List<String> intervals = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
    'One-off'
  ];

  List<String> intervalValues = ['day', 'week', 'month', 'year', ''];

  final List<num> _donationAmount = [50, 100, 150, 250, 500];

  Future<String> createPrice(
      String productId, String interval, String amount) async {
    const String url = "https://api.stripe.com/v1/prices";
    var body;
    if (interval == "") {
      body = {"unit_amount": amount, "currency": "usd", "product": productId};
    } else {
      body = {
        "unit_amount": amount,
        "currency": "usd",
        "recurring[interval]": interval,
        "product": productId
      };
    }

    var response =
        await client.post(Uri.parse(url), headers: headers, body: body);

    var price = json.decode(response.body);
    return price["id"];
  }

  subscribe() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    var finalDonationAmount;

    if (donationAmountManual != "" && donationAmountManual != "0") {
      finalDonationAmount = donationAmountManual;
    } else {
      finalDonationAmount = donationAmount;
    }
    String productId = await getDonationId();
    String priceId =
        await createPrice(productId, interval, finalDonationAmount);
    if (interval != "") {
      await subscriptions(priceId);
    }
    setState(() {
      isLoading = false;
    });
    await DonationService().donate(finalDonationAmount, true, interval);
    String formattedTime =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    await StatisticsService().sendMail(
        AuthService.authUser['email'],
        AuthService.authUser['name'],
        donationAmount,
        "Subscription",
        formattedTime);
    Navigator.of(context).pushNamed('/thankyou');
  }

  String _displayMessage = '';

  List<String> messages = [
    'Will contribute to the cost of a doctor’s prescribed medicines during treatment.',
    'Will help keep a doctor’s health insurance current while they take a short break to recover from burnout.',
    'Will help cover the monthly utility bills for a doctor unable to work due to an accident.',
    'Will provide fortnightly counselling to a doctor and their family experiencing severe grief.',
    'Will help pay for emergency accommodation for a doctor and their children escaping domestic violence.',
  ];

  setMessage(index) {
    setState(() {
      _displayMessage = messages[index!];
      initialLabelIndex = index!;
    });
  }

  int initialLabelIndex = 0;
  int initialIntervalIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subscription Donation"),
        centerTitle: true,
        // automaticallyImplyLeading: false,
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
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleSwitch(
                      initialLabelIndex: initialIntervalIndex,
                      totalSwitches: 5,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      inactiveBgColor: Colors.white,
                      borderWidth: 1.0,
                      borderColor: [Colors.grey],
                      labels: intervals,
                      onToggle: (index) {
                        initialIntervalIndex = index!;
                        setState(() {
                          interval = intervalValues[index!];
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleSwitch(
                      initialLabelIndex: initialLabelIndex,
                      totalSwitches: 5,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      inactiveBgColor: Colors.white,
                      borderWidth: 1.0,
                      borderColor: [Colors.grey],
                      labels: _donationAmount
                          .map((e) => '\$' + e.toString())
                          .toList(),
                      onToggle: (index) {
                        setMessage(index);
                        setState(() {
                          var amount = _donationAmount[index!] * 100;
                          try {
                            donationAmount = amount.toStringAsFixed(0);
                          } catch (e) {
                            throw Exception(e.toString());
                          }
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                          donationAmountManual = amount.toStringAsFixed(0);
                        } else {
                          donationAmountManual = "";
                        }
                      } catch (e) {
                        throw Exception(e.toString());
                      }
                    });
                  },
                  validator: MultiValidator([
                    RequiredValidator(errorText: 'Amount is Required'),
                  ]),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    hintText: 'Other Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _displayMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                ),
                // DropdownButtonHideUnderline(
                //   child: ButtonTheme(
                //     alignedDropdown: true,
                //     child: DropdownButton(
                //       value: interval,
                //       dropdownColor: Colors.grey,
                //       isExpanded: true,
                //       elevation: 10,
                //       items: intervals.map((String value) {
                //         return DropdownMenuItem(
                //           value: value,
                //           child: Text(value),
                //         );
                //       }).toList(),
                //       onChanged: (String? value) {
                //         setState(() {
                //           interval = value!;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                CardField(
                  controller: cardController,
                  dangerouslyGetFullCardDetails: true,
                  onCardChanged: (card) {
                    setState(() {
                      if (card!.complete) {
                        customerCard = card;
                      }
                    });
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 5,
                  ),
                  onPressed: subscribe,
                  child: Text(isLoading ? 'Loading...' : "Subscribe !"),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const MainDrawer(),
    );
  }
}
