import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BudgetCostItem {
  final String id;
  final String name;
  final String description;
  final int budget;
  final int actual;
  final String eventId;

  BudgetCostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.budget,
    required this.actual,
    required this.eventId,
  });
}

class UIBudgetCostItem extends StatelessWidget {
  final BudgetCostItem cost;
  final VoidCallback onTap;

  UIBudgetCostItem({required this.cost, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Icon(Icons.monetization_on_outlined,color: Colors.yellow[800],),
                        SizedBox(width: 8),
                      Text("${cost.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                      )
                    ),
                  ),
                  Divider(color: Colors.blue),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Dự kiến: ${formatter.format(cost.budget)} VND", style: TextStyle(fontSize: 15)),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Thực tế: ${formatter.format(cost.actual)} VND", style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
