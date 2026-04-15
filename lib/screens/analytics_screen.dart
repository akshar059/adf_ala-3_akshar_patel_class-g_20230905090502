import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class AnalyticsScreen extends StatefulWidget {
  final List<TransactionModel> transactions;
  final VoidCallback toggleTheme;

  const AnalyticsScreen({
    super.key, 
    required this.transactions, 
    required this.toggleTheme,
  });

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    Map<String, double> data = {};

    for (var t in widget.transactions) {
      if (t.type == "Expense") {
        data[t.category] = (data[t.category] ?? 0) + t.amount;
      }
    }

    if (data.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Analytics"),
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: widget.toggleTheme,
            ),
          ],
        ),
        body: Center(
          child: Text(
            "No expenses to analyze",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Pie Chart with labels OUTSIDE
            SizedBox(
              height: 300,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: data.entries.map((e) {
                        int index = data.keys.toList().indexOf(e.key);
                        
                        return PieChartSectionData(
                          value: e.value * controller.value,
                          title: "${e.key}\n₹${e.value.toInt()}",
                          radius: 70,
                          // ✅ CRITICAL FIX: Move title outside
                          titlePositionPercentageOffset: 1.4, 
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          color: Colors.primaries[index % Colors.primaries.length],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 80),
            
            // Modern List Legend for better readability
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Breakdown", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  const SizedBox(height: 16),
                  ...data.entries.map((e) {
                    int index = data.keys.toList().indexOf(e.key);
                    final color = Colors.primaries[index % Colors.primaries.length];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: isDark ? [] : [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          const SizedBox(width: 16),
                          Expanded(child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold))),
                          Text("₹${e.value.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
