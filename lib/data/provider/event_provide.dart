import 'package:flutter/material.dart';

enum EventState { none, invalid, valid }

enum TaskState { none, invalid, valid }

class EventProvider with ChangeNotifier {
  String _eventId = '';
  String _eventName = '';
  String _taskId = '';
  String _taskName = '';
  String _userId = '';
  String _fullName = '';
  String _role = '';

  Map<String, String> _errors = {};
  EventState _eventState = EventState.none;
  TaskState _taskState = TaskState.none;

  String get eventId => _eventId;
  set eventId(String value) {
    _eventId = value;
    notifyListeners();
  }

  String get eventName => _eventName;
  set eventName(String value) {
    _eventName = value;
    notifyListeners();
  }

  String get taskId => _taskId;
  set taskId(String value) {
    _taskId = value;
    notifyListeners();
  }

    String get taskName => _taskName;
  set taskName(String value) {
    _taskName = value;
    notifyListeners();
  }

  String get userId => _userId;
  set userId(String value) {
    _userId = value;
    notifyListeners();
  }

  String get fullName => _fullName;
  set fullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  String get role => _role;
  set role(String value) {
    _role = value;
    notifyListeners();
  }

 
  // Hàm getter để lấy thông báo lỗi của một trường cụ thể
  String? getError(String field) {
    return _errors[field];
  }

  // Cập nhật thông báo lỗi cho một trường cụ thể
  void setError(String field, String errorMessage) {
    _errors[field] = errorMessage;
    notifyListeners(); // Thông báo rằng dữ liệu đã thay đổi
  }

  // Hàm xóa thông báo lỗi của một trường cụ thể
  void clearError(String field) {
    _errors.remove(field);
    notifyListeners();
  }
  void clearAllError() {
    _errors.clear();
    notifyListeners();
  }
  void setEventState(EventState newState) {
    _eventState = newState;
    notifyListeners();
  }

   void setTaskState(TaskState newState) {
    _taskState = newState;
    notifyListeners();
  }
void clearEventState() {
    _eventState = EventState.none;
    notifyListeners();
  }
  void clearTaskState() {
    _taskState = TaskState.none;
    notifyListeners();
  }

  Map<String, String> get errors => _errors;

  EventState get eventState => _eventState;

  TaskState get taskState => _taskState;

}
