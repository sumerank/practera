import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:d_chart/time/bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pie_chart/pie_chart.dart';

import '../configs/config.dart';
import '../http/AuthService.dart';
import '../http/StatisticsService.dart';
import '../sharedWidgets/drawer.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late Map<String, double> donorVsNonDonor = {
    "Non-Donor": 0,
    "Donor": 0,
  };

  late Map<String, double> oneTimeVsRecurring = {
    "One-Time": 0,
    "Recurring": 0,
  };

  late Map<String, double> recurringDonorType = {
    "Daily": 0,
    "Weekly": 0,
    "Monthly": 0,
    "Yearly": 0,
  };

  late List<TimeGroup> timeGroup = [];
  late List<TimeGroup> loginGroup = [];

  @override
  void initState() {
    super.initState();
    fetchDonorNumber();
    fetchDonorType();
    fetchRecurringDonorType();
    fetchRegistrationData();
    fetchLoginData();
  }

  fetchDonorNumber() {
    StatisticsService().getDonorNumber().then((value) {
      double totalUsers = value['user_no'].toDouble();
      double donorCount = value['donor_no'].toDouble();
      setState(() {
        donorVsNonDonor["Donor"] = (donorCount / totalUsers) * 100;
        donorVsNonDonor["Non-Donor"] =
            ((totalUsers - donorCount) / totalUsers) * 100;
      });
    });
  }

  fetchDonorType() {
    StatisticsService().getDonorType().then((value) {
      double totalDonation = value['donation'].toDouble();
      double oneTimeDonation = value['onetime'].toDouble();
      double recurringDonation = value['recurring'].toDouble();

      setState(() {
        oneTimeVsRecurring["One-Time"] =
            (oneTimeDonation / totalDonation) * 100;
        oneTimeVsRecurring["Recurring"] =
            (recurringDonation / totalDonation) * 100;
      });
    });
  }

  fetchRecurringDonorType() {
    StatisticsService().getRecurringDonorType().then((value) {
      double totalDonation = value['donation'].toDouble();
      double dailyDonation = value['daily'].toDouble();
      double weeklyDonation = value['weekly'].toDouble();
      double monthlyDonation = value['monthly'].toDouble();
      double yearlyDonation = value['yearly'].toDouble();

      setState(() {
        recurringDonorType["Daily"] = (dailyDonation / totalDonation) * 100;
        recurringDonorType["Weekly"] = (weeklyDonation / totalDonation) * 100;
        recurringDonorType["Monthly"] = (monthlyDonation / totalDonation) * 100;
        recurringDonorType["Yearly"] = (yearlyDonation / totalDonation) * 100;
      });
    });
  }

  fetchRegistrationData() {
    StatisticsService().getRegistrationData().then((value) {
      List<TimeData> dataList = [];
      for (var item in value) {
        DateTime date = DateTime.parse(item['date']);
        double count = item['count'].toDouble();
        dataList.add(TimeData(domain: date, measure: count));
      }
      setState(() {
        timeGroup = [
          TimeGroup(id: '1', data: dataList),
        ];
      });
    });
  }

  fetchLoginData() {
    StatisticsService().getLoginData().then((value) {
      List<TimeData> dataList = [];
      for (var item in value) {
        DateTime date = DateTime.parse(item['date']);
        double count = item['count'].toDouble();
        dataList.add(TimeData(domain: date, measure: count));
      }
      setState(() {
        loginGroup = [
          TimeGroup(id: '1', data: dataList),
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistics"),
        backgroundColor: Config.primaryColor,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(children: [
              const Text("Percentage of Donors vs Non-Donors"),
              PieChart(
                dataMap: donorVsNonDonor,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
              ),
              const SizedBox(height: 50),
              const Text("Percentage of One-Time Donors vs Recurring Donors"),
              PieChart(
                dataMap: oneTimeVsRecurring,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
              ),
              const SizedBox(height: 50),
              const Text("Percentage of Types of Recurring Donors"),
              PieChart(
                dataMap: recurringDonorType,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: MediaQuery.of(context).size.width / 3.2,
                initialAngleInDegree: 0,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
              ),
              const SizedBox(height: 50),
              const Text("User Registration Trend (Last 7 Days)"),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: DChartBarT(
                  groupList: timeGroup,
                ),
              ),
              const SizedBox(height: 50),
              const Text("User Login Trend (Last 7 Days)"),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: DChartBarT(
                  groupList: loginGroup,
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
