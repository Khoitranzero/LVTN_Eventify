import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/data/repository/cost/costRepository.dart';
import 'package:Eventify/ui/component/modal/addBudgetCostModal.dart';
import 'package:Eventify/ui/component/modal/detailBudgetCostModal.dart';
import 'package:Eventify/ui/component/modal/updateBudgetModal.dart';
import 'package:Eventify/ui/component/molcules/UIBudgetCostItem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventCostScreen extends StatefulWidget {
  const EventCostScreen({Key? key}) : super(key: key);

  @override
  _EventCostScreenState createState() => _EventCostScreenState();
}

class _EventCostScreenState extends State<EventCostScreen> {
  CostRepository costRepository = CostRepository();
  List<BudgetCostItem> budgetCosts = [];
  bool isLoading = true;
  String? userRole;
  int? Budget = 0;
  int? totalBudget = 0;
  int? totalActual = 0;

  @override
  void initState() {
    super.initState();
    fetchCostData();
  }

  Future<void> fetchCostData() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);

    try {
      final responses = await Future.wait([
        costRepository.getAllEventCost(eventProvider.eventId),
        costRepository.getTotalCost(eventProvider.eventId),
      ]);

      final eventCostResponse = responses[0];
      final totalCostResponse = responses[1];

      if (eventCostResponse['EC'] == 0) {
        setState(() {
          budgetCosts = (eventCostResponse['DT'] as List)
              .map((budgetcost) => BudgetCostItem(
                    actual: budgetcost['actualAmount'],
                    name: budgetcost['CostCategory']['name'],
                    budget: budgetcost['budgetAmount'],
                    description: budgetcost['description'],
                    eventId: budgetcost['eventId'],
                    id: budgetcost['id'],
                  ))
              .toList();
          isLoading = false;
        });
      } else {
        print(eventCostResponse['EM']);
      }

      if (totalCostResponse['EC'] == 0) {
        // print("totalCostResponse['DT']");
        // print(totalCostResponse['DT']);
        setState(() {
          Budget = totalCostResponse['DT']['totalCost']['totalBudget'];
          totalBudget = totalCostResponse['DT']['totalBudgetAmount'];
          totalActual = totalCostResponse['DT']['totalCost']['totalActualCost'];
        });
      } else {

        print(totalCostResponse['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }
 void showUpdateBudgetModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: UpdateBudgetModal(currentBudget: Budget ?? 0),
          ),
        );
      },
    ).then((result) {
      if (result != null && result == true) {

        fetchCostData();
      }
    });
  }
 void navigateToBudgetCostDetail(String id) {
     showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        backgroundColor: Colors.white,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: DetailBudgetCostModal(costId: id),
                        ),
                      );
                    },
                  ).then((result) {
    if (result != null && result == true) {
      // If the modal was closed with success (true), fetch updated data
      fetchCostData();
    }
  });
          
  }
  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fetchCostData();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
     final bool isMember = eventProvider.role == 'Member';
     final formatter = NumberFormat('#,##0', 'en_US');
    return Scaffold(
         backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: Column(
                children: [
                 Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black), 
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black,
                          ),

                           Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                              GestureDetector(
                                onTap: isMember? null : showUpdateBudgetModal,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Tổng nguồn vốn:",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, 
                                        color: isMember ? Colors.black : Colors.blue),
                                      ),
                                      isMember ? Container()
                                      :
                                      Container(child: 
                                      IconButton(
                                        icon: Icon(Icons.mode_edit_outlined, size: 16,color: Colors.blue,), 
                                        onPressed: showUpdateBudgetModal,
                                      ),
                                      height: 35,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(), // Căn lề phải
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text("${formatter.format(Budget ?? 0)} VND",
                                style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text("Tổng phí dự kiến:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                              ),
                              Spacer(), // Căn lề phải
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                               child: Text("${formatter.format(totalBudget ?? 0)} VND",
                                 style: TextStyle(fontSize: 16),
                               ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text("Tổng phí thực tế:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Text("${formatter.format(totalActual ?? 0)} VND",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  Text(
                      'Danh mục chi phí',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: budgetCosts.length,
                      itemBuilder: (context, index) {
                        return UIBudgetCostItem(
                          cost: budgetCosts[index],
                          onTap: () =>
                              navigateToBudgetCostDetail(budgetCosts[index].id),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: eventProvider.role!='Member'? FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.white,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AddBudgetCostModal(),
                ),
              );
            },
          ).then((_) {
            fetchCostData();
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ) : null,
    );
  }
}
