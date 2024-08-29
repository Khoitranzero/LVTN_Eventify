import {
  InfoCircleOutlined,
  ArrowRightOutlined,
  ClockCircleOutlined,
  CarOutlined,
  StarOutlined,
} from "@ant-design/icons";
import "../../assets/css/_ant_custom.scss";
import { useRouter } from "next/navigation";
import {
  formatDateTime,
  mapStatus,
  mapStatusToColor,
  slugify,
} from "../../helper";
import moment from "moment";
import Link from "next/link";
const FilterFutureEventTable = (props) => {
  const { filteredData } = props;
  const router = useRouter();
  const showEventInfo = (eventId, eventName) => {
    const slugEventName = slugify(eventName);
    router.push(
      `/screens/home/event_detail?eventId=${eventId}&name=${slugEventName}`
    );
  };
  const theader = [
    "No.",
    "Tên sự kiện",
    "Trạng thái",
    "Ngày bắt đầu",
    "Ngày kết thúc",
    "Thao tác",
  ];
  console.log("filtered data: ", filteredData);
  return (
    // <>
    //   <div className="">
    //     <div className="my-2 max-h-[350px] overflow-auto">
    //       <table>
    //         <thead>
    //           <tr>
    //             {theader?.map((headerItem, index) => (
    //               <th key={index}>{headerItem}</th>
    //             ))}
    //           </tr>
    //         </thead>
    //         <tbody>
    //           {filteredData != "" ? (
    //             filteredData?.map((item, index) => {
    //               return (
    //                 <>
    //                   <tr key={index}>
    //                     <td>{index + 1}</td>
    //                     <td>{item.name}</td>
    //                     <td>{mapStatus(item.status)}</td>
    //                     <td>{formatDateTime(item.startAt)}</td>
    //                     <td>{formatDateTime(item.endAt)}</td>
    //                     <td>
    //                       {/* <Popconfirm
    //                         placement="leftTop"
    //                         title={"Xác nhận xóa sự kiện"}
    //                         description={
    //                           "Bạn có chắc chắn muốn xóa sự kiện này ?"
    //                         }
    //                         onConfirm={() => handleDeleteUser(item.id)}
    //                         okText="Xác nhận"
    //                         cancelText="Hủy"
    //                       >
    //                         <span className="text-red-500">
    //                           <DeleteOutlined
    //                             onClick={() => {
    //                               console.log("DELETE");
    //                             }}
    //                           />
    //                         </span>
    //                       </Popconfirm> */}
    //                       <InfoCircleOutlined
    //                         className="cursor-pointer ml-2"
    //                         onClick={() => {
    //                           showEventInfo(item.id, item.name);
    //                         }}
    //                       />
    //                     </td>
    //                   </tr>
    //                 </>
    //               );
    //             })
    //           ) : (
    //             <tr>
    //               <td>-</td>
    //               <td>-</td>
    //               <td>-</td>
    //               <td>-</td>
    //               <td>-</td>
    //               <td>-</td>
    //             </tr>
    //           )}
    //         </tbody>
    //       </table>
    //     </div>
    //   </div>
    // </>
    <>
      {filteredData?.map((item, index) => {
        return (
          <div
            className="event-item border-b-[1px] border-[#98A2B3] p-3 bg-white hover:bg-gray-100 w-full cursor-pointer"
            onClick={() => showEventInfo(item.id, item.name)}
            key={index}
          >
            <div className="title text-[18px]">{item?.name}</div>
            <div className="sub-title text-[14px] flex gap-3">
              <span className="py-1">
                <CarOutlined /> {item?.location}
              </span>
              |
              <span
                className={
                  mapStatusToColor(item?.status) + " px-2 py-1 rounded-md"
                }
              >
                <StarOutlined /> {mapStatus(item?.status)}
              </span>{" "}
              |
              <span className="py-1">
                {" "}
                <ClockCircleOutlined />{" "}
                {moment(item.startAt).format("YYYY-MM-DD")}{" "}
                <ArrowRightOutlined /> {moment(item.endAt).format("YYYY-MM-DD")}
              </span>
            </div>
          </div>
        );
      })}
    </>
  );
};
export default FilterFutureEventTable;
