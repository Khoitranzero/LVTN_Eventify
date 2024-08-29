import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActualCostItem {
  final String id;
  final String name;
  final String description;
  final int actual;

  ActualCostItem({
    required this.id,
    required this.name,
    required this.description,
    required this.actual,
  });
}

class UIActualCostItem extends StatelessWidget {
  final ActualCostItem cost;
  final VoidCallback onTap;

  UIActualCostItem({required this.cost, required this.onTap});

  @override
  Widget build(BuildContext context) {
     final formatter = NumberFormat('#,##0', 'en_US');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
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
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Icon(Icons.monetization_on_outlined,color: Colors.orange,),
                        SizedBox(width: 8),
                      Text("${cost.name}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                      )
                    ),
                  ),
                  Divider(color: Colors.blue),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerRight,
                             child: Text("Chi phí : ${formatter.format(cost.actual)} VND", style: TextStyle(fontSize: 15)),
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
