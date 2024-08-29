import 'package:Eventify/data/api/taskApiManager.dart';

class TaskRepository {
  final TaskApiManager _taskApiManager = TaskApiManager();

  Future<Map<String, dynamic>> getAllTaskInEvents(String eventId) async {
    try {
      final Map<String, dynamic> getAllTaskInEventsMessage =
          await _taskApiManager.getAllTaskInEvents(eventId);
      return getAllTaskInEventsMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy danh sách công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> getSubTaskInEvents(
      String eventId, String parentTaskId) async {
    try {
      final Map<String, dynamic> getSubTaskInEventsMessage =
          await _taskApiManager.getSubTaskInEvents(eventId, parentTaskId);
      return getSubTaskInEventsMessage;
    } catch (e) {
      print("Lỗi hiển thị danh sách công việc phụ $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy danh sách công việc phụ: $e'};
    }
  }

  Future<Map<String, dynamic>> createTask(String name, String description,
      String startAt, String endAt, String eventId, String parentTaskId) async {
    try {
      final Map<String, dynamic> createTaskMessage = await _taskApiManager
          .createTask(name, description, startAt, endAt, eventId, parentTaskId);
      return createTaskMessage;
    } catch (e) {
      print("Lỗi tạo công việc: $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi tạo công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> getAllTaskStatus() async {
    try {
      final Map<String, dynamic> getAllTaskStatusMessage =
          await _taskApiManager.getAllTaskStatus();
      return getAllTaskStatusMessage;
    } catch (e) {
      print("Lỗi lấy quyền của user trong sự kiện $e");
      return {
        'EC': -1,
        'EM': 'Đã xảy ra lỗi lấy quyền của user trong sự kiện: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getOneTask(String taskId, String userId) async {
    try {
      final Map<String, dynamic> getOneTaskMessage =
          await _taskApiManager.getOneTask(taskId, userId);
      return getOneTaskMessage;
    } catch (e) {
      print("Lỗi hiển thị chi tiết công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy chi tiết công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> getOneSubTask(
      String taskId, String parentTaskId, String userId) async {
    try {
      final Map<String, dynamic> getOneSubTaskMessage =
          await _taskApiManager.getOneSubTask(taskId, parentTaskId, userId);
      return getOneSubTaskMessage;
    } catch (e) {
      print("Lỗi hiển thị chi tiết công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi lấy chi tiết công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> updateTask(String name, String description,
      String startAt, String endAt, String status, String taskId, String isShow) async {
    try {
      final Map<String, dynamic> updateTaskMessage = await _taskApiManager
          .updateTask(name, description, startAt, endAt, status, taskId,isShow);
      return updateTaskMessage;
    } catch (e) {
      print("Lỗi cập nhật công việc: $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi cập nhật công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteTask(String taskId) async {
    try {
      final Map<String, dynamic> deleteTaskMessage =
          await _taskApiManager.deleteTask(taskId);
      return deleteTaskMessage;
    } catch (e) {
      print("Lỗi xóa công việc $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi xóa công việc: $e'};
    }
  }

  Future<Map<String, dynamic>> getMemberInTask(String taskId) async {
    try {
      final Map<String, dynamic> getMemberInTaskMessage =
          await _taskApiManager.getMemberInTask(taskId);
      return getMemberInTaskMessage;
    } catch (e) {
      print("Lỗi hiển thị thành viên thực hiện công việc $e");
      return {
        'EC': -1,
        'EM': 'Đã xảy ra lỗi lấy thành viên thực hiện công việc: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getMemberInSubTask(
      String taskId, String parentTaskId) async {
    try {
      final Map<String, dynamic> getMemberInSubTaskMessage =
          await _taskApiManager.getMemberInSubTask(taskId, parentTaskId);
      return getMemberInSubTaskMessage;
    } catch (e) {
      print("Lỗi hiển thị thành viên thực hiện công việc phụ $e");
      return {
        'EC': -1,
        'EM': 'Đã xảy ra lỗi lấy thành viên thực hiện công việc phụ: $e'
      };
    }
  }

  Future<Map<String, dynamic>> addMemberToTask(
      String taskId, String userId) async {
    try {
      final Map<String, dynamic> addMemberToTaskMessage =
          await _taskApiManager.addMemberToTask(taskId, userId);
      return addMemberToTaskMessage;
    } catch (e) {
      print("Lỗi giao việc: $e");
      return {'EC': -1, 'EM': 'Đã xảy ra lỗi giao việc cho thành viên: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteMemberInTask(
      String taskId, String userId) async {
    try {
      final Map<String, dynamic> deleteMemberInTaskMessage =
          await _taskApiManager.deleteMemberInTask(taskId, userId);
      return deleteMemberInTaskMessage;
    } catch (e) {
      print("Lỗi xóa sự kiện $e");
      return {
        'EC': -1,
        'EM': 'Đã xảy ra lỗi xóa thành viên trong công việc: $e'
      };
    }
  }

  Future<Map<String, dynamic>> getMemberAssignSubTask(String taskId) async {
    try {
      final Map<String, dynamic> getMemberAssignSubTaskMessage =
          await _taskApiManager.getMemberAssignSubTask(taskId);
      return getMemberAssignSubTaskMessage;
    } catch (e) {
      print("Lỗi hiển thị thành viên thực hiện công việc $e");
      return {
        'EC': -1,
        'EM': 'Đã xảy ra lỗi lấy thành viên thực hiện công việc: $e'
      };
    }
  }
}
