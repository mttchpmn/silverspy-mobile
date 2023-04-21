import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:silverspy/models/transaction_model.dart';
import 'package:silverspy/models/transaction_response_model.dart';
import 'package:silverspy/providers/auth_provider.dart';
import 'package:silverspy/services/transaction_service.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({Key? key}) : super(key: key);

  @override
  _TransactionListPageState createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late String _accessToken;
  late Future<TransactionResponse> transactions;
  final TransactionService _transactionsService = TransactionService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    transactions = fetchTransactions();
  }

  @override
  void initState() {
    super.initState();

    transactions = fetchTransactions();
  }

  Future<TransactionResponse> fetchTransactions() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);

    return authProvider.getCredentials().then((value) {
      _accessToken = value.accessToken;
      return _transactionsService.fetchTransactions(value.accessToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Transactions'),
        ),
        body: FutureBuilder<TransactionResponse>(
            future: transactions,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TransactionsList(data: data),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    )
                  ]);
            }));
  }
}

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    required this.data,
  });

  final TransactionResponse data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.transactions.length,
        itemBuilder: (context, index) {
          final transaction = data.transactions[index];
          return ListTile(
            // leading: transaction.type == PaymentType.incoming ? Icon(Icons.arrow_circle_up, color: Colors.green,) : Icon(Icons.arrow_circle_down, color: Colors.red,),
            title: Text(transaction.reference),
            subtitle: Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(transaction.transactionDate).toLocal())),
            trailing: Text('\$${transaction.value}'),
            onTap: () {},
          );
        },
      ),
    );
  }
}

