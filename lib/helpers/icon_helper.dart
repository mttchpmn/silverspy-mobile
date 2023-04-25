import 'package:flutter/material.dart';

class IconHelper {
  static Icon getIconForCategory(String category) {
    switch (category) {
      case "UNCATEGORIZED":
        return const Icon(
          Icons.question_mark,
          color: Colors.blueGrey,
        );
      case "RENT":
        return const Icon(
          Icons.home,
          color: Colors.lightBlue,
        );
      case "UTILITIES":
        return const Icon(Icons.power, color: Colors.yellow);
      case "GROCERIES":
        return const Icon(Icons.shopping_cart, color: Colors.green);
      case "TRANSPORTATION":
        return const Icon(Icons.car_rental, color: Colors.deepPurple);
      case "INSURANCE":
        return const Icon(Icons.account_balance, color: Colors.lightGreen);
      case "HEALTHCARE":
        return const Icon(Icons.healing, color: Colors.red);
      case "REPAYMENTS":
        return const Icon(Icons.paid, color: Colors.deepOrangeAccent);
      case "SAVINGS":
        return const Icon(Icons.money, color: Colors.cyan);
      case "INVESTMENT":
        return const Icon(Icons.rocket_launch, color: Colors.red);
      case "SUBSCRIPTIONS":
        return const Icon(Icons.credit_card, color: Colors.green);
      case "SHOPPING":
        return const Icon(Icons.shopping_bag, color: Colors.pink);
      case "FOODANDDRINK":
        return const Icon(Icons.fastfood, color: Colors.pink);
      case "RECREATION":
        return const Icon(Icons.kayaking, color: Colors.pink);
      case "PERSONAL":
        return const Icon(Icons.person, color: Colors.pink);
      case "MISCELLANEOUS":
        return const Icon(Icons.miscellaneous_services, color: Colors.pink);
      default:
        return const Icon(Icons.question_mark, color: Colors.pink);
    }
  }
}
