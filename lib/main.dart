import 'dart:io';

import 'package:expence_diary/widgets/chart.dart';
import 'package:expence_diary/widgets/new_transaction.dart';
import 'package:expence_diary/widgets/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          accentColor: Colors.purple,
          fontFamily: 'Quicksand',
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  titleMedium:
                      const TextStyle(fontFamily: 'OpenSans', fontSize: 20)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    Transaction(id: 't1', title: 'Shoes', amount: 69.69, date: DateTime.now()),
    Transaction(id: 't2', title: 'Watch', amount: 30.69, date: DateTime.now()),
    Transaction(id: 't3', title: 'Shirt', amount: 40.69, date: DateTime.now()),
    Transaction(id: 't4', title: 'Mobile', amount: 63.69, date: DateTime.now()),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        const Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(
      String titleTxt, double amount, DateTime choosenDate) {
    final newTransaction = Transaction(
        id: DateTime.now().toString(),
        title: titleTxt,
        amount: amount,
        date: choosenDate);

    setState(() {
      _transactions.add(newTransaction);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  void _startAddnewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: NewTransaction(handleAddTransation: _addNewTransaction),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final isIOS = Platform.isIOS;
    final PreferredSizeWidget appbar = isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Expence Diary'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _startAddnewTransaction(context),
                )
              ],
            ),
          ) as PreferredSizeWidget
        : AppBar(
            title: const Text('Expence Diary'),
            actions: [
              IconButton(
                  onPressed: () => _startAddnewTransaction(context),
                  icon: const Icon(
                    Icons.add,
                  ))
            ],
          );
    final txListWidget = SizedBox(
      height: (mediaQuery.size.height -
              appbar.preferredSize.height -
              mediaQuery.padding.top) *
          0.6,
      child: TransactionList(
          transactions: _transactions, deleteTransaction: _deleteTransaction),
    );

    final body = SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Show Charts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch.adaptive(
                    activeColor: Theme.of(context).colorScheme.secondary,
                    value: _showChart,
                    onChanged: (value) {
                      setState(() {
                        _showChart = value;
                      });
                    }),
              ],
            ),
          if (!isLandscape)
            SizedBox(
                height: (mediaQuery.size.height -
                        appbar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions)),
          if (!isLandscape) txListWidget,
          if (isLandscape)
            _showChart
                ? SizedBox(
                    height: (mediaQuery.size.height -
                            appbar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTransactions))
                : txListWidget
        ],
      ),
    );

    return isIOS
        ? CupertinoPageScaffold(child: body)
        : Scaffold(
            appBar: appbar,
            body: body,

            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _startAddnewTransaction(context),
                  ),
            // This trailing comma makes auto-formatting nicer for build methods.
          );
  }
}
