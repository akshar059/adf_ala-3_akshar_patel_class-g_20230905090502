import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import 'add_edit_screen.dart';

class AllTransactionsScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback toggleTheme;
  final Function loadData;

  const AllTransactionsScreen({
    super.key, 
    required this.transactions, 
    required this.toggleTheme,
    required this.loadData,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: Colors.white),
            onPressed: toggleTheme,
          ),
        ],
      ),
      body: transactions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 80, color: colorScheme.outline.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text(
                    "No transactions available",
                    style: TextStyle(fontSize: 18, color: colorScheme.outline),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final t = transactions[index];
                final isIncome = t.type == "Income";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isIncome ? Colors.green : Colors.red).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        isIncome ? Icons.keyboard_double_arrow_down_rounded : Icons.keyboard_double_arrow_up_rounded,
                        color: isIncome ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(
                      t.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${t.category} • ${t.date}"),
                    trailing: Text(
                      "${isIncome ? "+" : "-"} ₹${t.amount.toStringAsFixed(0)}",
                      style: TextStyle(
                        color: isIncome ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditScreen(transaction: t, toggleTheme: toggleTheme),
                      ),
                    ).then((_) => loadData()),
                  ),
                );
              },
            ),
    );
  }
}
