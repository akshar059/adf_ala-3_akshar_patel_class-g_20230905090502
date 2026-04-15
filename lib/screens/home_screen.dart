import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import 'add_edit_screen.dart';
import 'all_transactions_screen.dart';
import 'analytics_screen.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  const HomeScreen({super.key, required this.toggleTheme});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TransactionModel> transactions = [];
  double income = 0;
  double expense = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DatabaseHelper.instance.getAll();
    double inc = 0, exp = 0;
    for (var t in data) {
      if (t.type == "Income") {
        inc += t.amount;
      } else {
        exp += t.amount;
      }
    }
    setState(() {
      transactions = data;
      income = inc;
      expense = exp;
    });
  }

  @override
  Widget build(BuildContext context) {
    double balance = income - expense;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340,
            floating: false,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF00C9FF),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    // Premium Balance Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5B86E5).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Balance",
                              style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text("₹${balance.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -1)),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem("Income", income, Icons.arrow_downward, Colors.greenAccent),
                              _buildStatItem("Expense", expense, Icons.arrow_upward, Colors.redAccent),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text("MY WALLET", 
                style: TextStyle(
                  fontWeight: FontWeight.w900, 
                  color: Colors.white, 
                  fontSize: 16,
                  letterSpacing: 4.0,
                )),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.analytics_rounded, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnalyticsScreen(transactions: transactions, toggleTheme: widget.toggleTheme))),
              ),
              IconButton(
                icon: Icon(theme.brightness == Brightness.dark ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
                onPressed: widget.toggleTheme,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Recent Activity", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AllTransactionsScreen(
                            transactions: transactions,
                            toggleTheme: widget.toggleTheme,
                            loadData: loadData,
                          ),
                        ),
                      ).then((_) => loadData());
                    },
                    child: Row(
                      children: [
                        Text(
                          "See All",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          transactions.isEmpty
              ? SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 64, color: colorScheme.outline.withOpacity(0.3)),
                        const SizedBox(height: 16),
                        Text("No transactions yet", style: TextStyle(color: colorScheme.outline)),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final t = transactions[i];
                        final isIncome = t.type == "Income";
                        return _buildTransactionItem(t, isIncome, colorScheme);
                      },
                      childCount: transactions.length,
                    ),
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditScreen(toggleTheme: widget.toggleTheme))).then((_) => loadData()),
        icon: const Icon(Icons.add_rounded),
        label: const Text("New Entry"),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildStatItem(String label, double amount, IconData icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
        Text("₹${amount.toStringAsFixed(0)}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionModel t, bool isIncome, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
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
            borderRadius: BorderRadius.circular(18),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    t.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(t.date, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
        trailing: Text(
          "${isIncome ? "+" : "-"} ₹${t.amount.toStringAsFixed(0)}",
          style: TextStyle(
            color: isIncome ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditScreen(transaction: t, toggleTheme: widget.toggleTheme))).then((_) => loadData()),
        onLongPress: () => _showDeleteDialog(t),
      ),
    );
  }

  void _showDeleteDialog(TransactionModel t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text("Delete Transaction?"),
        content: const Text("This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.delete(t.id!);
              Navigator.pop(context);
              loadData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
