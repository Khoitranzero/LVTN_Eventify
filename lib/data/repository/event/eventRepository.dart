import 'package:Eventify/data/api/eventApiManager.dart';

class EventRepository {
  final EventApiManager _eventApiManager = EventApiManager();



  Future<Map<String, dynamic>> getUserRoleInEvent(String eventId,String userId) async {
    try {
      final Map<String, dynamic> getUserRoleInEventMessage = await _eventApiManager.getUserRoleInEvent(eventId,userId);
      return getUserRoleInEventMessage;
    } catch (e) {
      print("Lỗi lấy quyền của user trong sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy quyền của user trong sự kiện: $e'};
    }
  }

  Future<Map<String, dynamic>> getAllEventStatus() async {
    try {
      final Map<String, dynamic> getAllEventStatusMessage = await _eventApiManager.getAllEventStatus();
      return getAllEventStatusMessage;
    } catch (e) {
      print("Lỗi lấy quyền của user trong sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy quyền của user trong sự kiện: $e'};
    }
  }

Future<Map<String, dynamic>> getUserEvents(String userId) async {
    try {
      final Map<String, dynamic> getUserEventsMessage = await _eventApiManager.getUserEvents(userId);
      return getUserEventsMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy danh sách sự kiện: $e'};
    }
  }

  Future<Map<String, dynamic>> getAllEventCategory() async {
    try {
      final Map<String, dynamic> getAllEventCategoryMessage = await _eventApiManager.getAllEventCategory();
      return getAllEventCategoryMessage;
    } catch (e) {
      print("Lỗi lấy danh mục sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy danh mục sự kiện: $e'};
    }
  }

Future<Map<String, dynamic>> createEvent(
  String eventId,
  String name,
  String location,
  String description,
  String startAt,
  String endAt,
  String categoryId, 
  String userId) async {
  try {
    final Map<String, dynamic> createEventMessage 
    = await _eventApiManager.createEvent(eventId,name,location,description,startAt,endAt,categoryId,userId);
    return createEventMessage;
  } catch (e) {
    print("Lỗi tạo sự kiện: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi tạo sự kiện: $e'};
  }
}
  Future<Map<String, dynamic>> getOneEvent(String eventId) async {
    try {
      final Map<String, dynamic> getOneEventMessage = await _eventApiManager.getOneEvent(eventId);
      return getOneEventMessage;
    } catch (e) {
      print("Lỗi hiển thị chi tiết sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy chi tiết sự kiện: $e'};
    }
  }

 Future<Map<String, dynamic>> updateEvent( 
  String categoryId,
 String name,
 String location, 
 String description, 
 String startAt, 
 String endAt,
 String status, 
 String eventId) async {
  try {
    final Map<String, dynamic> updateEventMessage = await _eventApiManager.updateEvent(
      categoryId, 
      name,
      location, 
      description, 
      startAt, 
      endAt,
      status, 
      eventId);
    return updateEventMessage;
  } catch (e) {
    print("Lỗi cập nhật sự kiện: $e");
    return {'EC': -1, 'EM': 'Đã xảy ra lỗi cập nhật sự kiện: $e'};
  }
}

Future<Map<String, dynamic>> deleteEvent(String eventId) async {
    try {
      final Map<String, dynamic> deleteEventMessage = await _eventApiManager.deleteEvent(eventId);
      return deleteEventMessage;
    } catch (e) {
      print("Lỗi xóa sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa sự kiện: $e'};
    }
  }

   Future<Map<String, dynamic>> getMemberInEvents(String eventId) async {
    try {
      final Map<String, dynamic> getMemberInEventsMessage = await _eventApiManager.getMemberInEvents(eventId);
      return getMemberInEventsMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách thành viên trong sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi hiển thị danh sách thành viên trong sự kiện: $e'};
    }
  }

  Future<Map<String, dynamic>> getMemberAssign(String eventId, String taskId) async {
    try {
      final Map<String, dynamic> getMemberAssignMessage = await _eventApiManager.getMemberAssign(eventId,taskId);
      return getMemberAssignMessage;
    } catch (e) {
      print("Lỗi lấy danh sách thành viên để giao việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy danh sách thành viên để giao việc: $e'};
    }
  }

  Future<Map<String, dynamic>> addUserToEvent(String eventId,String userId, String role) async {
  try {
    final Map<String, dynamic> addUserToEventMessage = await _eventApiManager.addUserToEvent(eventId,userId,role);
    return addUserToEventMessage;
  } catch (e) {
    print("Lỗi thêm thành viên vào sự kiện: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi thêm thành viên vào sự kiện: $e'};
  }
}

  Future<Map<String, dynamic>> updateUserRole(String eventId,String userId, String role) async {
  try {
    final Map<String, dynamic> updateUserRoleMessage = await _eventApiManager.updateUserRole(eventId,userId,role);
    return updateUserRoleMessage;
  } catch (e) {
    print("Lỗi phân quyền cho thành viên: $e");
     return {'EC': -1, 'EM': 'Đã xảy ra lỗi phân quyền cho thành viên: $e'};
  }
}

Future<Map<String, dynamic>> deleteUserInEvent(String eventId,String userId) async {
    try {
      final Map<String, dynamic> deleteUserInEventMessage = await _eventApiManager.deleteUserInEvent(eventId,userId);
      return deleteUserInEventMessage;
    } catch (e) {
      print("Lỗi xóa thành viên khỏi sự kiện $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa thành viên trong sự kiện: $e'};
    }
  }
}