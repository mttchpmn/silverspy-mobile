import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _salutation = 'Hi Matt!'; // replace with actual user name
  DateTime _currentDate = DateTime.now();
  int _daysUntilNextPay = 7; // replace with actual calculation
  List<Map<String, dynamic>> _upcomingPayments = [
    {'name': 'Rent', 'date': 'Apr 1', 'amount': '\$1000'},
    {'name': 'Car Payment', 'date': 'Apr 5', 'amount': '\$350'},
    {'name': 'Phone Bill', 'date': 'Apr 7', 'amount': '\$75'},
  ]; // replace with actual data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _salutation,
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 16.0),
            Text(
              '${_currentDate.day}/${_currentDate.month}/${_currentDate.year}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16.0),
            Text(
              '$_daysUntilNextPay days until next pay',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16.0),
            Text(
              'Transactions over the last month',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Text('Placeholder for transactions graph'),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Upcoming payments',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 8.0),
            DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Amount')),
              ],
              rows: _upcomingPayments.map((payment) {
                return DataRow(
                  cells: [
                    DataCell(Text(payment['name'])),
                    DataCell(Text(payment['date'])),
                    DataCell(Text(payment['amount'])),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
