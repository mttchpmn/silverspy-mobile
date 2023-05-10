import 'package:flutter/material.dart';
import 'package:silverspy/components/period_selector.dart';
import 'package:silverspy/constants/finance_category.dart';
import 'package:silverspy/helpers/icon_helper.dart';

import '../models/transaction_response_model.dart';

class CategoryTotalList extends StatelessWidget {
  final List<TransactionCategorySummary> categoryTotals;
  final ValueChanged<FinanceCategory> onTapCallback;
  final DatePeriodType datePeriodType;

  const CategoryTotalList(
      {super.key,
      required this.categoryTotals,
      required this.onTapCallback,
      required this.datePeriodType});

  @override
  Widget build(BuildContext context) {
    var sortedTotals = _sortList(categoryTotals);

    return Expanded(
      child: ListView.builder(
        itemCount: sortedTotals.length,
        itemBuilder: (context, index) {
          var ct = sortedTotals[index];

          return CategoryTotalRow(
            category: ct.category,
            total: ct.currentSpend,
            target: ct.budget,
            onTapCallback: onTapCallback,
            datePeriodType: datePeriodType,
          );
        },
      ),
    );
  }

  List<TransactionCategorySummary> _sortList(
      List<TransactionCategorySummary> categoryTotals) {
    var budgets = List.of(categoryTotals);
    var nonBudgets = List.of(categoryTotals);

    budgets.retainWhere((element) => element.budget > 0);
    budgets.sort((a, b) => a.currentSpend.compareTo(b.currentSpend));

    nonBudgets.retainWhere((element) => element.budget == 0);
    nonBudgets.sort((a, b) => a.currentSpend.compareTo(b.currentSpend));

    return budgets + nonBudgets;
  }
}

class CategoryTotalRow extends StatelessWidget {
  final FinanceCategory category;
  final double total;
  final double target;
  final ValueChanged<FinanceCategory> onTapCallback;
  final DatePeriodType datePeriodType;

  const CategoryTotalRow(
      {super.key,
      required this.category,
      required this.total,
      required this.target,
      required this.datePeriodType,
      required this.onTapCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconHelper.getIconForCategory(category),
      title: Text(
        category.toDisplayString(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('\$${total.abs().toStringAsFixed(2)}'),
            ],
          ),
          if (target > 0)
            (SpendProgress(
              target: target,
              currentSpend: total,
              datePeriodType: datePeriodType,
            ))
        ],
      ),
      onTap: () {
        onTapCallback(category);
      },
    );
  }
}

class SpendProgress extends StatelessWidget {
  const SpendProgress(
      {super.key,
      required this.currentSpend,
      required this.target,
      required this.datePeriodType});

  final double currentSpend;
  final double target;
  final DatePeriodType datePeriodType;

  double _getAdjustedSpendTarget(double target) {
    switch (datePeriodType) {
      case DatePeriodType.Weekly:
        return target;
      case DatePeriodType.Fortnightly:
        return target * 2;
      case DatePeriodType.Monthly:
        return target * 4.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    var value = (currentSpend / target).abs();
    var color = value > 1 ? Colors.red : Colors.purple;
    var adjustedTarget = _getAdjustedSpendTarget(target);

    return Row(
      children: [
        Expanded(
            child: LinearProgressIndicator(
          value: value,
          // backgroundColor: Colors.grey,
          color: color,
        )),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text("\$$adjustedTarget"),
        ),
      ],
    );
  }
}
