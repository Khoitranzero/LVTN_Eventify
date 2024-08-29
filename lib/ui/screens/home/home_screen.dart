import 'package:Eventify/data/provider/event_provide.dart';
import 'package:Eventify/ui/component/molcules/UIFormatStatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Eventify/data/repository/event/eventRepository.dart';
import 'package:Eventify/ui/component/modal/addEventModal.dart';
import 'package:Eventify/ui/component/molcules/UIEventItem.dart';
import 'package:Eventify/data/provider/auth_provider.dart';
import 'package:Eventify/data/services/routes_service.dart';
import 'package:Eventify/ui/screens/event/event_index_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RouterService routerService = RouterService();
  EventRepository eventRepository = EventRepository();
  List<EventItem> eventItems = [];
  
  bool isLoading = true;
  bool hasRefreshed = false;

  @override
  void initState() {
    super.initState();
    fetchUserEvents();
    
  }

  Future<void> fetchUserEvents() async {
    try {
    
        final authProvider = await Provider.of<AuthProvider>(context, listen: false);
         if (authProvider.id == '' && !hasRefreshed) {
        hasRefreshed = true;
        onRefresh();
      }
      // print("authProvider.id là :");
      // print(authProvider.id);
      final response = await eventRepository.getUserEvents(authProvider.id);
      // print("fetchUserEvents");
      // print(response);
      if (response['EC'] == 0) {
      
        setState(() {
          eventItems = (response['DT'] as List)
              .map((event) => EventItem(
                    role: event['role'],
                    startAt: event['startAt'],
                    endAt: event['endAt'],
                    name: event['name'],
                    status: formatStatus(event['status']),
                    eventId: event['id'],
                  ))
              .toList();
          isLoading = false;
        });
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.eventState == EventState.none;
    eventProvider.eventId='';
    eventProvider.role='';
    eventProvider.eventName='';
      } else {
        // Handle error case
        print(response['EM']);
      }
    } catch (e) {
      print("Error fetching events: $e");
    }
  }

  void navigateToEventDetail(String eventId,String role, String eventName) async  {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    eventProvider.eventState == EventState.valid;
    eventProvider.eventId=eventId;
    eventProvider.role=role;
    eventProvider.eventName=eventName;
     final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventIndexScreen(),
      ),
    );
      if (result == true) {
      fetchUserEvents();
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return fetchUserEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Trang chủ'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.builder(
                itemCount: eventItems.length,
                itemBuilder: (context, index) {
                  return UIEventItem(
                    event: eventItems[index],
                    onTap: () =>
                        navigateToEventDetail(
                          eventItems[index].eventId,
                          eventItems[index].role,
                          eventItems[index].name),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: AddEventModal(),
                ),
              );
            },
          ).then((value) => onRefresh());
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
