//costApiManager.dart
import 'dart:convert';
import 'package:Eventify/config/apiConfig.dart';
import 'package:Eventify/data/services/token_service.dart';
import 'package:http/http.dart' as http;

class CostApiManager {
 
  Future<Map<String, dynamic>> createCategory(String name) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/createCategory');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'name': name,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> getAllEventCost(String eventId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/cost/getAllEventCost?eventId=$eventId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

    Future<Map<String, dynamic>> getAllCategory() async {
      final url = Uri.parse('${ApiConfig.baseAPI}/cost/getAllCategory');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

   Future<Map<String, dynamic>> createBudgetCost(
    String eventId, 
    String categoryId, 
    String budgetAmount, 
    String description) async {
    final formattedBudgetAmount = budgetAmount.replaceAll(',', ''); 
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/createBudgetCost');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'eventId': eventId,
      'categoryId': categoryId,
      'budgetAmount': formattedBudgetAmount,
      'description': description,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

     Future<Map<String, dynamic>> getOneBudgetCost(String costId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/cost/getOneBudgetCost?costId=$costId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

 Future<Map<String, dynamic>> updateEventCost(
  String costId ,
  String eventId ,
  String categoryId,
  String budget,
  String description) async {
    final formattedBudget = budget.replaceAll(',', ''); 
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/updateEventCost');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'costId': costId,
      'eventId': eventId,
      'categoryId': categoryId,
      'budget': formattedBudget,
      'description': description,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

 Future<Map<String, dynamic>> updateEventBudgetCost(String eventId ,String budgetCost) async {
    final formattedBudget = budgetCost.replaceAll(',', ''); 
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/updateEventBudgetCost');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'eventId': eventId,
      'budgetCost': formattedBudget,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }


 Future<Map<String, dynamic>> deleteEventCost(String costId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/deleteEventCost?costId=$costId');
    final token = await TokenService.getToken();
    final response = await http.delete(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

  Future<Map<String, dynamic>> getAllTaskCost(String taskId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/cost/getAllTaskCost?taskId=$taskId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

   Future<Map<String, dynamic>> getOneTaskCost(String costId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/cost/getOneTaskCost?costId=$costId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }


   Future<Map<String, dynamic>> createTaskCost(
    String taskId,
    String eventId ,
    String categoryId, 
    String actual, 
    String description) async {
    final formattedActual = actual.replaceAll(',', ''); 
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/createTaskCost');
    final token = await TokenService.getToken();
    final response = await http.post(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'taskId': taskId,
      'eventId': eventId,
      'categoryId': categoryId,
      'actual': formattedActual,
      'description': description,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }


Future<Map<String, dynamic>> updateTaskCost(
  String costId,
  String eventId,
  String taskId,
  String categoryId,
  String actual,
  String description) async {
    final formattedActual = actual.replaceAll(',', ''); 
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/updateTaskCost');
    final token = await TokenService.getToken();
    final response = await http.put(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: <String, String>{
      'costId': costId,
      'eventId': eventId,
      'taskId': taskId,
      'categoryId': categoryId,
      'actual': formattedActual,
      'description': description,
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

 Future<Map<String, dynamic>> deleteTaskCost(String costId,String eventId) async {
    final url = Uri.parse('${ApiConfig.baseAPI}/cost/deleteTaskCost?costId=$costId&eventId=$eventId');
    final token = await TokenService.getToken();
    final response = await http.delete(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

 Future<Map<String, dynamic>> getTotalCost(String eventId) async {
      final url = Uri.parse('${ApiConfig.baseAPI}/cost/getTotalCost?eventId=$eventId');
      final token = await TokenService.getToken();
    final response = await http.get(url, headers: <String, String>{
      'ContentType': 'application/json',
      'Authorization': 'Bearer $token',
    }, 
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('gọi API thất bại!');
    }
  }

}
