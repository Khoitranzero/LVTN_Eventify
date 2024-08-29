import 'package:Eventify/data/api/costApiManager.dart';

class CostRepository {
  final CostApiManager _costApiManager = CostApiManager();
 
Future<Map<String, dynamic>> createCategory(String name) async {
  try {
    final Map<String, dynamic> createCategoryMessage = await _costApiManager.createCategory(name);
    return createCategoryMessage;
  } catch (e) {
    print("Lỗi tạo danh mục: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi tạo danh mục: $e'};
  }
}

  Future<Map<String, dynamic>> getAllEventCost(String eventId) async {
    try {
      final Map<String, dynamic> getAllEventCostMessage = await _costApiManager.getAllEventCost(eventId);
      return getAllEventCostMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách chi phí $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị danh sách chi phí: $e'};
    }
  }

  Future<Map<String, dynamic>> getAllCategory() async {
    try {
      final Map<String, dynamic> getAllCategoryMessage = await _costApiManager.getAllCategory();
      return getAllCategoryMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách danh mục $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị danh sách danh mục : $e'};
    }
  }
 
Future<Map<String, dynamic>> createBudgetCost(
  String eventId, 
  String categoryId, 
  String budgetAmount, 
  String description) async {
  try {
    final Map<String, dynamic> createBudgetCostMessage 
    = await _costApiManager.createBudgetCost(eventId,categoryId,budgetAmount,description);
    return createBudgetCostMessage;
  } catch (e) {
    print("Lỗi tạo chi phí dự kiến: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi tạo  chi phí dự kiến: $e'};
  }
}

  Future<Map<String, dynamic>> getOneBudgetCost(String costId) async {
    try {
      final Map<String, dynamic> getOneBudgetCostMessage = await _costApiManager.getOneBudgetCost(costId);
      return getOneBudgetCostMessage;
    } catch (e) {
      print("Lỗi hiển thị chi tiết chi phí $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy chi tiết chi phí: $e'};
    }
  }

 Future<Map<String, dynamic>> updateEventCost(
  String costId,
  String eventId,
  String categoryId,
  String budget,
  String description) async {
  try {
    final Map<String, dynamic> updateEventCostMessage 
    = await _costApiManager.updateEventCost(costId,eventId,categoryId, budget, description);
    return updateEventCostMessage;
  } catch (e) {
    print("Lỗi cập nhật chi phí: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi cập nhật chi phí: $e'};
  }
}

 Future<Map<String, dynamic>> updateEventBudgetCost(String eventId ,String budgetCost) async {
  try {
    final Map<String, dynamic> updateEventBudgetCostMessage = await _costApiManager.updateEventBudgetCost(eventId,budgetCost);
    return updateEventBudgetCostMessage;
  } catch (e) {
    print("Lỗi cập nhật chi phí: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi cập nhật chi phí: $e'};
  }
}

Future<Map<String, dynamic>> deleteEventCost(String costId) async {
    try {
      final Map<String, dynamic> deleteEventCostMessage = await _costApiManager.deleteEventCost(costId);
      return deleteEventCostMessage;
    } catch (e) {
      print("Lỗi xóa chi phí sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa chi phí sự kiện: $e'};
    }
  }

    Future<Map<String, dynamic>> getAllTaskCost(String taskId) async {
    try {
      final Map<String, dynamic> getAllTaskCostMessage = await _costApiManager.getAllTaskCost(taskId);
      return getAllTaskCostMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách chi phí công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị danh sách chi phí công việc: $e'};
    }
  }


  Future<Map<String, dynamic>> getOneTaskCost(String costId) async {
    try {
      final Map<String, dynamic> getOneTaskCostMessage = await _costApiManager.getOneTaskCost(costId);
      return getOneTaskCostMessage;
    } catch (e) {
      print("Lỗi hiển thị chi tiết chi phí công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy chi tiết chi phí công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> createTaskCost(
    String taskId, 
    String eventId,
    String categoryId, 
    String actual, 
    String description) async {
  try {
    final Map<String, dynamic> createTaskCostMessage 
    = await _costApiManager.createTaskCost(taskId,eventId,categoryId,actual,description);
    return createTaskCostMessage;
  } catch (e) {
    print("Lỗi tạo chi phí công việc: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi tạo  chi phí công việc: $e'};
  }
}

Future<Map<String, dynamic>> updateTaskCost(
  String costId,
  String eventId,
  String taskId ,
  String categoryId,
  String actual,
  String description
  ) async {
  try {
    final Map<String, dynamic> updateTaskCostMessage = await _costApiManager.updateTaskCost(
      costId,
      eventId,
      taskId,
      categoryId,
       actual, 
       description
       );
    return updateTaskCostMessage;
  } catch (e) {
    print("Lỗi cập nhật công việc: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi cập nhật công việc: $e'};
  }
}

Future<Map<String, dynamic>> deleteTaskCost(String costId,String eventId) async {
    try {
      final Map<String, dynamic> deleteTaskCostMessage = await _costApiManager.deleteTaskCost(costId,eventId);
      return deleteTaskCostMessage;
    } catch (e) {
      print("Lỗi xóa chi phí công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa chi phí công việc: $e'};
    }
  }


  Future<Map<String, dynamic>> getTotalCost(String eventId) async {
    try {
      final Map<String, dynamic> getTotalCostMessage = await _costApiManager.getTotalCost(eventId);
      return getTotalCostMessage;
    } catch (e) {
      print("Lỗi lấy chi phí sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy chi phí sự kiện: $e'};
    }
  }
}