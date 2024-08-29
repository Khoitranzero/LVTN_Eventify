import { InfoCircleOutlined } from "@ant-design/icons";
import "../../assets/css/_ant_custom.scss";
import { useRouter } from "next/navigation";
import { formatDateTime } from "../../helper";
const FilterUserTable = (props) => {
  const { filteredData } = props;
  const router = useRouter();
  const showUserInfo = (userId) => {
    router.push(`/screens/home/user_detail?userId=${userId}`);
  };
  const theader = [
    "No.",
    "Tên người dùng",
    "Email",
    "Số điện thoại",
    "Ngày tạo",
    "Thao tác",
  ];
  console.log("danh sách người dùng: ", filteredData);
  return (
    <>
      <div className="">
        <div className="my-2 flex flex-col gap-3 px-3">
          {filteredData?.map((item, index) => {
            return (
              <div
                onClick={() => showUserInfo(item.id)}
                className="event-item cursor-pointer flex gap-3 p-2 rounded-lg w-full  border-[1px] border-[#98A2B3] hover:bg-orange-fade-color hover:border-[1px] hover:border-orange-bold-color transition-all bg-white"
                key={index}
              >
                <div className="left">
                  <img
                    src={item.avatarUrl}
                    className="w-[50px] h-[50px] rounded-full"
                    alt=""
                  />
                </div>
                <div className="right">
                  <span className="title text-xl text-black font-semibold">
                    {item?.name}
                  </span>
                  <div className="sub-title text-[14px] text-gray-600">
                    Email: {item.email}
                  </div>
                </div>
                {/* <div className="category-type">
                {" "}
                <ProductOutlined /> {item?.EventCategory?.name}
              </div>
              <div className="leader">
                <IdcardOutlined /> {item?.UserEvents[0]?.User?.name} -{" "}
                {item?.UserEvents[0]?.User?.email} -{" "}
                {item?.UserEvents[0]?.roleId}
              </div> */}
              </div>
            );
          })}
        </div>
      </div>
    </>
  );
};
export default FilterUserTable;
