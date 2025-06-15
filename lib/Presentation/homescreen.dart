import 'package:flutter/material.dart';
import 'package:money_tracker_app/Model/cardmodel.dart';

final _formkey = GlobalKey<FormState>();
final ValueNotifier<List<TransactionModel>> modelListNotifier = ValueNotifier([
  // TransactionModel(
  //   id: '1',
  //   transactionNarration: 'Grocery',
  //   transactionType: '-1',
  //   transactionAmount: '2000',
  // ),
  // TransactionModel(
  //   id: '2',
  //   transactionNarration: 'Salary',
  //   transactionType: '+1',
  //   transactionAmount: '50000',
  // ),
]);

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Money Tracker",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder<List<TransactionModel>>(
        valueListenable: modelListNotifier,
        builder: (context, modellist, _) {
          return ListView.separated(
            itemBuilder: (context, index) {
              final transaction = modellist[index];
              return ListTile(
                leading: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      transaction.transactionNarration,
                      style: TextStyle(fontSize: 25),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        showEditTransactionDialog(context, index, transaction);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return SizedBox(
                              width: 500,
                              child: AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                                title: Text(
                                  "Are you sure about this?",
                                  style: TextStyle(
                                    color: Colors.red[400],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      modelListNotifier.value = List.from(
                                        modellist,
                                      )..removeAt(index);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Yes Proceed"),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
                subtitle: Text(
                  "Amount: ${transaction.transactionAmount}",
                  style: TextStyle(
                    color: transaction.transactionType == "+1"
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              );
            },

            separatorBuilder: (context, index) => const Divider(),
            itemCount: modellist.length,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransactionDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[200],
      ),
    );
  }

  void showAddTransactionDialog(BuildContext context) {
    final narrationController = TextEditingController();
    final amountController = TextEditingController();
    final transactionTypeNotifier = ValueNotifier<String>('');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Add Transaction", style: TextStyle(color: Colors.red[400])),
            ],
          ),
          content: Form(
            key: _formkey,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: narrationController,
                    decoration: InputDecoration(
                      labelText: "Narration",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a narration";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter an amount";
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable: transactionTypeNotifier,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        value: value.isEmpty ? null : value,
                        decoration: const InputDecoration(
                          hintText: "Select Transaction Type",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: '+1', child: Text("Income")),
                          DropdownMenuItem(value: '-1', child: Text("Expense")),
                        ],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            transactionTypeNotifier.value = newValue;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a transaction type";
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              onPressed: () {
                final narration = narrationController.text.trim();
                final amount = amountController.text.trim();
                final type = transactionTypeNotifier.value;

                if (_formkey.currentState!.validate()) {
                  final narration = narrationController.text.trim();
                  final amount = amountController.text.trim();
                  final type = transactionTypeNotifier.value;

                  final newTransaction = TransactionModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    transactionNarration: narration,
                    transactionType: type,
                    transactionAmount: amount,
                  );
                  modelListNotifier.value = [
                    ...modelListNotifier.value,
                    newTransaction,
                  ];
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void showEditTransactionDialog(
    BuildContext context,
    int index,
    TransactionModel transaction,
  ) {
    final narrationController = TextEditingController(
      text: transaction.transactionNarration,
    );
    final amountController = TextEditingController(
      text: transaction.transactionAmount,
    );
    final transactionTypeNotifier = ValueNotifier<String>(
      transaction.transactionType,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Edit Transaction",
                style: TextStyle(color: Colors.blue[400]),
              ),
            ],
          ),
          content: Form(
            key: _formkey,
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: narrationController,
                    decoration: InputDecoration(
                      labelText: "Narration",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter a narration";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter an amount";
                      }
                      if (double.tryParse(value.trim()) == null) {
                        return "Please enter a valid number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ValueListenableBuilder<String>(
                    valueListenable: transactionTypeNotifier,
                    builder: (context, value, _) {
                      return DropdownButtonFormField<String>(
                        value: value.isEmpty ? null : value,
                        decoration: const InputDecoration(
                          hintText: "Select Transaction Type",
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: '+1', child: Text("Income")),
                          DropdownMenuItem(value: '-1', child: Text("Expense")),
                        ],
                        onChanged: (newValue) {
                          if (newValue != null) {
                            transactionTypeNotifier.value = newValue;
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a transaction type";
                          }
                          return null;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  final updatedTransaction = TransactionModel(
                    id: transaction.id,
                    transactionNarration: narrationController.text.trim(),
                    transactionType: transactionTypeNotifier.value,
                    transactionAmount: amountController.text.trim(),
                  );

                  final updatedList = List<TransactionModel>.from(
                    modelListNotifier.value,
                  );
                  updatedList[index] = updatedTransaction;

                  modelListNotifier.value = updatedList;
                  Navigator.of(context).pop();
                }
              },
              child: const Text("Save Changes"),
            ),
          ],
        );
      },
    );
  }
}
