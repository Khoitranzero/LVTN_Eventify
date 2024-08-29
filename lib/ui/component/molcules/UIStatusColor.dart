// import 'package:flutter/material.dart';

// Color getStatusColor(String status) {
//   switch (status) {
//     case 'Pending':
//       return Colors.orange;
//     case 'In Progress':
//       return Colors.blue;
//     case 'Completed':
//       return Colors.green;
//     case 'Cancelled':
//       return Colors.red;
//     default:
//       return Colors.grey;
//   }
// }
import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'Chờ xử lý':
      return Colors.orange;
    case 'Đang làm':
      return Colors.blue;
    case 'Hoàn thành':
      return Colors.green;
    case 'Đã hủy':
      return Colors.red;
    default:
      return Colors.grey;
  }
}