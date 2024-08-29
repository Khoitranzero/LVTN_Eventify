import moment from "moment";

export const formatDateTime = (dateTime) => {
  const date = new Date(dateTime);
  const daysOfWeek = [
    "Chủ Nhật",
    "Thứ 2",
    "Thứ 3",
    "Thứ 4",
    "Thứ 5",
    "Thứ 6",
    "Thứ 7",
  ];
  const dayOfWeek = daysOfWeek[date.getDay()];
  const hours = date.getHours().toString().padStart(2, "0");
  const minutes = date.getMinutes().toString().padStart(2, "0");
  const day = date.getDate().toString().padStart(2, "0");
  const month = (date.getMonth() + 1).toString().padStart(2, "0");
  const year = date.getFullYear();
  if (isNaN(day) || isNaN(month) || isNaN(year)) {
    return "";
  }
  return `${day}-${month}-${year}`;
};
const statusMapping = {
  Pending: "Đang chờ xử lý",
  "In Progress": "Đang tiến hành",
  Completed: "Hoàn thành",
  Cancelled: "Đã hủy",
  Paused: "Tạm dừng",
  Ended: "Kết thúc",
  Postponed: "Hoãn lại",
};
// const statusMapping = {
//   "Chờ xử lý": "Đang chờ xử lý",
//   "Đang làm": "Đang tiến hành",
//   "Hoàn thành": "Hoàn thành",
//   "Đã hủy": "Đã hủy",
//   Paused: "Tạm dừng",
//   Ended: "Kết thúc",
//   Postponed: "Hoãn lại",
// };

export const mapStatus = (status) => {
  return statusMapping[status] || "Trạng thái không xác định";
};

export const getCurrentDate = () => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0");
  const day = String(now.getDate()).padStart(2, "0");
  return `${year}-${month}-${day}`;
};
export const slugify = (text) => {
  return text
    .toString()
    .toLowerCase()
    .replace(/\s+/g, "-")
    .replace(/[^\w\-]+/g, "")
    .replace(/\-\-+/g, "-")
    .replace(/^-+/, "")
    .replace(/-+$/, "");
};
export const removeHyphens = (text) => {
  return text.replace(/-/g, " ");
};
export const formatCurrency = (amount) => {
  return amount?.toLocaleString("vi-VN", {
    style: "currency",
    currency: "VND",
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  });
};
const statusColorMapping = {
  Pending: "bg-yellow-200",
  "In Progress": "bg-blue-200",
  Completed: "bg-green-200",
  Cancelled: "bg-red-200",
  Paused: "bg-purple-200",
  Ended: "bg-gray-200",
  Postponed: "bg-gray-200",
};

export const mapStatusToColor = (status) => {
  return statusColorMapping[status] || "bg-gray-200";
};
export const getRandomColor = () => {
  const letters = "0123456789ABCDEF";
  let color = "#";
  for (let i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
};
export const formatFullTime = (time) => {
  return moment(time).format("YYYY-MM-DD HH:mm:ss");
};
export const formatMonthTime = (time) => {
  const currentYear = moment().year();
  const month = moment(time).format("MM");
  return `${currentYear}-${month}`;
};
