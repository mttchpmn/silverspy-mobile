import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:silverspy/components/loading_spinner.dart';
import 'package:silverspy/constants/finance_category.dart';
import 'package:silverspy/helpers/date_helper.dart';
import 'package:silverspy/helpers/icon_helper.dart';
import 'package:silverspy/models/payment_forecast_model.dart';
import 'package:silverspy/providers/auth_provider.dart';
import 'package:silverspy/services/payment_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PaymentsService _paymentsService = PaymentsService();
  String _salutation = 'Hi Matt!'; // TODO - replace with actual user name
  DateTime _currentDate = DateTime.now().toLocal();
  int _daysUntilNextPay = 7; // replace with actual calculation

  late Future<PaymentForecast> _paymentForecast;

  @override
  void initState() {
    super.initState();

    _paymentForecast = _fetchPaymentForecast();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _paymentForecast = _fetchPaymentForecast();
  }

  Future<PaymentForecast> _fetchPaymentForecast() async {
    debugPrint("Fetching transactions...");
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      return _paymentsService.getPaymentForecast(
          DateTime.now().toUtc(), _getNextPayday(), value.accessToken);
    });
  }

  DateTime _getNextPayday() {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int targetDay = 26;

    if (currentDay <= targetDay) {
      // If the current day is before or on the target day, get the target day of the current month
      return DateTime(now.year, now.month, targetDay);
    } else {
      // If the current day is after the target day, get the target day of the next month
      int nextMonth = now.month + 1;
      int nextYear = now.year;
      if (nextMonth > 12) {
        nextMonth = 1;
        nextYear++;
      }
      return DateTime(nextYear, nextMonth, targetDay);
    }
  }

  int _getDaysTilPayday() {
    var payday = _getNextPayday();

    var difference = payday.difference(DateTime.now());

    return difference.inDays;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Hi Matt!, it's ${_currentDate.day}/${_currentDate.month}/${_currentDate.year}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Text(
              "There are ${_getDaysTilPayday()} days until your next payday",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Divider(),
            Expanded(
              child: FutureBuilder<PaymentForecast>(
                future: _paymentForecast,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done ||
                      !snapshot.hasData) {
                    return const LoadingSpinner();
                  }

                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  var data = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Upcoming payments"),
                        Expanded(
                            child: ListView.builder(
                                itemCount: data.payments.length,
                                itemBuilder: (context, index) {
                                  var payment = data.payments[index];

                                  return ListTile(
                                    leading: IconHelper.getIconForCategory(
                                        FinanceCategoryExtensions.parse(
                                            payment.category)),
                                    title: Text(payment.name),
                                    subtitle: Text(DateHelper.getFormattedDate(
                                        payment.paymentDate)),
                                    trailing: Text("\$${payment.value}"),
                                  );
                                })),
                        Text("Total Outgoing: \$${data.totalOutgoing}"),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
