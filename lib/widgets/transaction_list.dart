import 'package:expence_diary/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(
      {required this.transactions, required this.deleteTransaction});

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: ((p0, p1) {
            return Column(
              children: [
                Text(
                  'No Transaction found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    height: p1.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ))
              ],
            );
          }))
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                          child: Text(
                              '\$${transactions[index].amount.toStringAsFixed(2)}')),
                    ),
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat.yMMMd().format(transactions[index].date),
                  ),
                  trailing: MediaQuery.of(context).size.width > 460
                      ? TextButton.icon(
                          onPressed: (() =>
                              deleteTransaction(transactions[index].id)),
                          style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).errorColor),
                          icon: const Icon(Icons.delete),
                          label: const Text('Delete'))
                      : IconButton(
                          icon: const Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: (() =>
                              deleteTransaction(transactions[index].id))),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}


//                    Card(
                //   child: Row(
                //     children: [
                //       Container(
                //         margin: const EdgeInsets.symmetric(
                //             horizontal: 10, vertical: 10),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //                 color: Theme.of(context).primaryColor,
                //                 width: 2)),
                //         padding: const EdgeInsets.all(10),
                //         child: Text(
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               color: Theme.of(context).primaryColor,
                //             ),
                //             '\$${transactions[index].amount.toStringAsFixed(2)}'),
                //       ),
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             transactions[index].title,
                //             style: const TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.blue),
                //             textAlign: TextAlign.start,
                //           ),
                //           Text(
                //             transactions[index].date.toIso8601String(),
                //             style: const TextStyle(
                //                 fontSize: 14, color: Colors.grey),
                //             textAlign: TextAlign.start,
                //           ),
                //         ],
                //       )
                //     ],
                //   ),
                // );