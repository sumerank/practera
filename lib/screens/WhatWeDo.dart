import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:mbansw/configs/config.dart';

import '../sharedWidgets/drawer.dart';

class WhatWeDo extends StatefulWidget {
  const WhatWeDo({super.key});

  @override
  State<WhatWeDo> createState() => _WhatWeDoState();
}

class _WhatWeDoState extends State<WhatWeDo> {
  @override
  void initState() {
    super.initState();
  }

  late final List<Widget> _widgetOptions;

  final List<Map<String, dynamic>> list = [
    {
      'name': 'Counselling Support',
      'ic': Icons.headset,
      'text':
          'If something is going wrong at work, or a personal relationship is causing worry, it can be helpful to speak to someone who is outside the situation but understands the unique pressures of being a doctor. '
    },
    {
      'name': 'Referral /Advocacy',
      'ic': Icons.share,
      'text':
          'If we are unable to help directly, we can usually refer you to someone who can (with consent). This may include legal, insurance or financial counselling as well as issue related programs. We also advocate for doctors individually (with consent) and as a whole, striving to bring awareness to the unique issues faced by the profession'
    },
    {
      'name': 'Financial assistance',
      'ic': Icons.money,
      'text':
          'For a variety of reasons doctors and their families can find themselves under extreme financial stress. A doctor injured in an accident or facing a cancer diagnosis or needing to relocate suddenly due to a domestic violence situation, may quickly find themselves unable to work and in financial distress. '
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _widgetOptions = <Widget>[
      for (int i = 0; i < list.length; i++)
        Column(
          children: [
            Row(
              children: [
                Icon(
                  list[i]['ic'],
                  size: 50,
                  color: Config.primaryColor,
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        TextSpan(
                          text: list[i]['name'],
                          style: TextStyle(
                              color: Config.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: '\n ',
                          style: TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        TextSpan(
                          text: '\n${list[i]['text']}',
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("What We Do"),
        backgroundColor: Config.primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text(
                    textAlign: TextAlign.justify,
                    "The Medical Benevolent Association of NSW helps doctors and their families in need in NSW and the ACT with confidential and meaningful assistance and support. Those in the medical profession are often the most reluctant to ask for help. MBANSW provides a confidential, non-judgemental avenue of support for doctors and their loved ones.",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 15),
                  ),
                ),
                for (int i = 0; i < _widgetOptions.length; i++)
                  ListTile(
                    title: _widgetOptions[i],
                  ),
              ],
            ),
          ),
        )),
      ),
      drawer: const MainDrawer(),
    );
  }
}
