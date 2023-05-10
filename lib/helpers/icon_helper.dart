import 'package:flutter/material.dart';
import 'package:silverspy/constants/finance_category.dart';

class IconHelper {
  static Icon getIconForCategory(FinanceCategory category) {
    switch (category) {
      case FinanceCategory.uncategorized:
        return const Icon(
          Icons.question_mark,
          color: Colors.blueGrey,
        );
      case FinanceCategory.rent:
        return const Icon(
          Icons.home,
          color: Colors.lightBlue,
        );
      case FinanceCategory.utilities:
        return const Icon(Icons.power, color: Colors.yellow);
      case FinanceCategory.groceries:
        return const Icon(Icons.shopping_cart, color: Colors.green);
      case FinanceCategory.transportation:
        return const Icon(Icons.car_rental, color: Colors.deepPurple);
      case FinanceCategory.insurance:
        return const Icon(Icons.account_balance, color: Colors.lightGreen);
      case FinanceCategory.healthcare:
        return const Icon(Icons.healing, color: Colors.red);
      case FinanceCategory.repayments:
        return const Icon(Icons.paid, color: Colors.deepOrangeAccent);
      case FinanceCategory.savings:
        return const Icon(Icons.money, color: Colors.cyan);
      case FinanceCategory.investment:
        return const Icon(Icons.rocket_launch, color: Colors.red);
      case FinanceCategory.subscriptions:
        return const Icon(Icons.credit_card, color: Colors.green);
      case FinanceCategory.shopping:
        return const Icon(Icons.shopping_bag, color: Colors.pink);
      case FinanceCategory.foodAndDrink:
        return const Icon(Icons.fastfood, color: Colors.pink);
      case FinanceCategory.recreation:
        return const Icon(Icons.kayaking, color: Colors.pink);
      case FinanceCategory.personal:
        return const Icon(Icons.person, color: Colors.pink);
      case FinanceCategory.miscellaneous:
        return const Icon(Icons.miscellaneous_services, color: Colors.pink);
      case FinanceCategory.income:
        return const Icon(Icons.attach_money, color: Colors.green);
      default:
        return const Icon(
          Icons.question_mark,
          color: Colors.blueGrey,
        );
    }
  }
}
