import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/data/repository/notification/notificationRepository.dart';
import 'package:Eventify/ui/component/molcules/UIAppTextfield.dart';
import 'package:Eventify/ui/component/molcules/UICustomButton.dart';
import 'package:Eventify/ui/component/molcules/UIToastNN.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateBudgetModal extends StatefulWidget {
  final int currentBudget;
  const UpdateBudgetModal({Key? key, required this.currentBudget}) : super(key: key);

  @override
  State<UpdateBudgetModal> createState() => _UpdateBudgetModalModalState();
}

class _UpdateBudgetModalModalState extends State<UpdateBudgetModal> {
  late TextEditingController _budgetController;


  final CostRepository _costRepository = CostRepository();
  final NotificationRepository _notificationRepository = NotificationRepository();
  final formatter = NumberFormat('#,##0', 'en_US');
  @override
  void initState() {
    super.initState();
 _budgetController = TextEditingController(
        text: formatter.format(widget.currentBudget).toString());
  }

  

  Future<void> _updateEventCost() async {
  final eventProvider = Provider.of<EventProvider>(context, listen: false);

    final newBudget = _budgetController.text;

    final updateResult = await _costRepository.updateEventBudgetCost(
      eventProvider.eventId,
      newBudget,
    );

   
    if (updateResult['EC'] == 0) {
      // final notify = await _notificationRepository.createNotifycation(
      //       'createcost',
      //       "Sự kiện '${eventProvider.eventName}': '${authProvider.fullName}', đã thêm chi phí '${_categoryController.text.trim()}: ${_actualController.text.trim()} VND' cho công việc '${eventProvider.taskName}' !",
      //       eventProvider.eventId,
      //       authProvider.id);
    Navigator.pop(context, true);

    } else {
       UIToastNN.showToastError(updateResult['EM']);
 
    }
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Chỉnh sửa vốn",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),
          UIAppTextField(
            hintText: "Tổng vốn",
            labelText: "Tổng vốn",
            isReadOnly: false,
            textController: _budgetController,
            keyboardType: TextInputType.number,
            maxLength: 13,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              NumberInputFormatter(),
            ],
          ),
          SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: UICustomButton(
              buttonText: "Cập nhật",
              onPressed: _updateEventCost,
            ),
          ),
        ],
      ),
    );
  }
}
