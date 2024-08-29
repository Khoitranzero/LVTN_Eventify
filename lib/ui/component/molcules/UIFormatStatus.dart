String formatStatus(String status) {
  // switch (status.toLowerCase()) {
     switch (status) {
    case 'Pending':
      return 'Chờ xử lý';
    case 'In Progress':
      return 'Đang làm';
    case 'Completed':
      return 'Hoàn thành';
    case 'Cancelled':
      return 'Đã hủy';
    case 'Chờ xử lý':
      return 'Pending';
    case 'Đang làm':
      return 'In Progress';
    case 'Hoàn thành':
      return 'Completed';
    case 'Đã hủy':
      return 'Cancelled';
    default:
      return 'default';
  }
}