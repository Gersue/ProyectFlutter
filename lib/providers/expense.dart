class Expense {
  String name;
  double amount;
  List<String> types;
  bool state = false;

  Expense(
      {required this.name,
        required this.amount,
        required this.types,
        this.state = false});
}