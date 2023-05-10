enum FinanceCategory {
  uncategorized,
  rent,
  utilities,
  groceries,
  transportation,
  insurance,
  healthcare,
  repayments,
  savings,
  investment,
  subscriptions,
  shopping,
  foodAndDrink,
  recreation,
  personal,
  miscellaneous,
  income
}

extension FinanceCategoryExtensions on FinanceCategory {
  String toDisplayString() {
    if (this == FinanceCategory.foodAndDrink) {
      return "Food and Drink";
    }

    return "${name[0].toUpperCase()}${name.substring(1).toLowerCase()}";
  }

  static FinanceCategory parse(String input) {
    return FinanceCategory.values.firstWhere((element) => element.name.toUpperCase() == input.toUpperCase());
  }
}