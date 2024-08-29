// import { Button, Popconfirm, Select, Table } from "antd";
// import {
//   ReloadOutlined,
//   InfoCircleOutlined,
//   SearchOutlined,
// } from "@ant-design/icons";
// import { useEffect, useState } from "react";
// import CreateUser from "./user/user.create";
// import { useDispatch, useSelector } from "react-redux";
// import {
//   getAllEventRequest,
//   getEventCategoryRequest,
//   getEventDetailRequest,
// } from "../store/reducer";
// import "../assets/css/_ant_custom.scss";
// import { useRouter } from "next/navigation";
// import { useDebounce } from "use-debounce";
// import { slugify } from "../helper";
// const EventTable = (props) => {
//   const { eventData } = props;
//   const { eventCategory } = useSelector((state) => state.user);
//   const dispatch = useDispatch();
//   const router = useRouter();
//   const [openCreateModal, setOpenCreateModal] = useState(false);
//   const [search, setSearch] = useState("");
//   const [debounce] = useDebounce(search, 500);
//   const [filteredData, setFilteredData] = useState(eventData);
//   const showEventInfo = (eventId, eventName) => {
//     const slugEventName = slugify(eventName);
//     router.push(
//       `/screens/home/event_detail?eventId=${eventId}&name=${slugEventName}`
//     );
//   };
//   const handleSearch = (event) => {
//     const value = event.target.value;
//     setSearch(value);
//   };
//   useEffect(() => {
//     if (debounce) {
//       const lowercasedFilter = debounce.toLowerCase();
//       const filtered = eventData.filter((event) =>
//         event.name.toLowerCase().includes(lowercasedFilter)
//       );
//       setFilteredData(filtered);
//     } else {
//       setFilteredData(eventData);
//     }
//   }, [debounce, eventData]);
//   useEffect(() => {
//     if (eventCategory.length == []) {
//       dispatch(getEventCategoryRequest());
//     }
//   }, []);
//   const options = [
//     { value: "", label: "Tất cả" },
//     ...eventCategory.map((item) => ({
//       value: item.id,
//       label: item.name,
//     })),
//   ];
//   const handleChangeCategory = (value) => {
//     if (value === "") {
//       setFilteredData(eventData);
//     } else {
//       const filtered = eventData.filter((event) =>
//         event.categoryId.toLowerCase().includes(value.toLowerCase())
//       );
//       setFilteredData(filtered);
//     }
//   };
//   const columns = [
//     {
//       title: "Loại sự kiện",
//       dataIndex: "EventCategory",
//       key: "EventCategory",
//       render: (text, record) => record.EventCategory.name,
//     },
//     {
//       title: "Tên sự kiện",
//       dataIndex: "name",
//     },
//     {
//       title: "Mô tả",
//       dataIndex: "description",
//     },
//     {
//       title: "Trạng thái",
//       dataIndex: "status",
//     },
//     {
//       title: "Ngày bắt đầu",
//       dataIndex: "startAt",
//     },
//     {
//       title: "Ngày kết thúc",
//       dataIndex: "endAt",
//     },
//     {
//       title: "Thao tác",
//       align: "center",

//       render: (text, record, index) => {
//         return (
//           <div className="whitespace-nowrap">
//             {/* <EditTwoTone
//               twoToneColor="#f57800"
//               className="cursor-pointer px-5"
//               onClick={() => {
//                 setIsUpdateModalOpen(true);
//                 setDataUpdate(record);
//               }}
//             /> */}
//             <InfoCircleOutlined
//               className="cursor-pointer text-blue-600 text-[20px]"
//               onClick={() => {
//                 showEventInfo(record.id, record.name);
//               }}
//             />
//             {/* <Popconfirm
//               placement="leftTop"
//               title={"Xác nhận xóa sự kiện"}
//               description={"Bạn có chắc chắn muốn xóa sự kiện này ?"}
//               onConfirm={() => handleDeleteUser(record)}
//               okText="Xác nhận"
//               cancelText="Hủy"
//             >
//               <span style={{ cursor: "pointer" }}>
//                 <DeleteTwoTone twoToneColor="#ff4d4f" />
//               </span>
//             </Popconfirm> */}
//           </div>
//         );
//       },
//     },
//   ];
//   const showCreateModal = () => {
//     setOpenCreateModal(true);
//   };
//   const reloadEventTable = () => {
//     dispatch(getAllEventRequest());
//   };
//   const header = () => {
//     return (
//       <div className="flex justify-between items-center">
//         <span className="font-bold text-[30px] whitespace-nowrap">
//           Tất cả sự kiện
//         </span>
//         <div className="btns ">
//           <Select
//             defaultValue="Tất cả"
//             placeholder="Lọc theo danh mục sự kiện"
//             className="w-[300px] !h-[40px] !mr-[10px]"
//             onChange={handleChangeCategory}
//             options={options}
//           />
//           <input
//             type="text"
//             className="border-[1px] py-[7px] rounded-lg px-2 border-primary transition-all duration-300 delay-100 "
//             placeholder="Tìm kiếm sự kiện"
//             value={search}
//             onChange={handleSearch}
//           />
//           <button
//             className="bg-primary px-3 mx-2 py-[7px] border-[1px] text-black font-bold text-[15px] rounded-lg hover:bg-white hover:border-[1px] hover:border-primary transition-all duration-300 delay-100 hover:text-primary"
//             onClick={reloadEventTable}
//           >
//             <ReloadOutlined />
//           </button>
//         </div>
//       </div>
//     );
//   };
//   return (
//     <>
//       <CreateUser
//         openCreateModal={openCreateModal}
//         setOpenCreateModal={setOpenCreateModal}
//       />
//       <Table
//         dataSource={filteredData}
//         columns={columns}
//         title={header}
//         rowKey={"id"}
//         bordered
//         pagination={false}
//       />
//     </>
//   );
// };
// export default EventTable;
