class TransactionModel {
  final String id;
  String transactionNarration;
  String transactionType;
  String transactionAmount;

  TransactionModel({
    required this.id,
    required this.transactionNarration,
    required this.transactionType,
    required this.transactionAmount,
  });
}
