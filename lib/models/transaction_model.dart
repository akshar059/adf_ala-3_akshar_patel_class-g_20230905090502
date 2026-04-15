class TransactionModel {
  int? id;
  String title;
  double amount;
  String type;
  String date;
  String category;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'date': date,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      date: map['date'],
      category: map['category'],
    );
  }
}
