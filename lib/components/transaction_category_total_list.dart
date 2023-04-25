import 'package:flutter/material.dart';
import 'package:silverspy/helpers/icon_helper.dart';

import '../models/transaction_response_model.dart';

class CategoryTotalList extends StatelessWidget {
  final List<TransactionCategoryTotal> categoryTotals;

  const CategoryTotalList({super.key, required this.categoryTotals});

  @override
  Widget build(BuildContext context) {
    var totals = categoryTotals;
    totals.retainWhere((x) => x.value != 0 );
    totals.sort((a, b) => a.value.compareTo(b.value));
    return Expanded(
      child: ListView.builder(
        itemCount: categoryTotals.length,
        itemBuilder: (context, index) {
          return CategoryTotalRow(
            name: categoryTotals[index].category,
            total: categoryTotals[index].value,
          );
        },
      ),
    );
  }
}

class CategoryTotalRow extends StatelessWidget {
  final String name;
  final double total;

  CategoryTotalRow({required this.name, required this.total});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconHelper.getIconForCategory(name),
      title: Text(name),
      subtitle: Text('\$' + total.toStringAsFixed(2)),
    );
  }
}
