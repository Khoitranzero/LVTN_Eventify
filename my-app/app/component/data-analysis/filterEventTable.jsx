import { InfoCircleOutlined } from "@ant-design/icons";
import "../../assets/css/_ant_custom.scss";
import { useRouter } from "next/navigation";
import { formatDateTime, mapStatus, slugify } from "../../helper";
const FilterEventTable = (props) => {
  const { filteredData } = props;
  const router = useRouter();
  const showEventInfo = (eventId, eventName) => {
    const slugEventName = slugify(eventName);
    router.push(
      `/screens/home/event_detail?eventId=${eventId}&name=${slugEventName}`
    );
  };
  const theader = ["No.", "Tên sự kiện", "Trạng thái", "Ngày tạo", "Thao tác"];
  return (
    <>
      <div className="">
        <div className="my-2 max-h-[350px] overflow-auto">
          <table>
            <thead>
              <tr>
                {theader?.map((headerItem, index) => (
                  <th key={index}>{headerItem}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filteredData != "" ? (
                filteredData?.map((item, index) => {
                  return (
                    <>
                      <tr key={index}>
                        <td>{index + 1}</td>
                        <td>{item.name}</td>
                        <td>{mapStatus(item?.status)}</td>
                        <td>{formatDateTime(item.createdAt)}</td>
                        <td>
                          {/* <Popconfirm
                            placement="leftTop"
                            title={"Xác nhận xóa sự kiện"}
                            description={
                              "Bạn có chắc chắn muốn xóa sự kiện này ?"
                            }
                            onConfirm={() => handleDeleteUser(item.id)}
                            okText="Xác nhận"
                            cancelText="Hủy"
                          >
                            <span className="text-red-500">
                              <DeleteOutlined
                                onClick={() => {
                                  console.log("DELETE");
                                }}
                              />
                            </span>
                          </Popconfirm> */}
                          <InfoCircleOutlined
                            className="cursor-pointer ml-2"
                            onClick={() => {
                              showEventInfo(item.id, item.name);
                            }}
                          />
                        </td>
                      </tr>
                    </>
                  );
                })
              ) : (
                <tr>
                  <td>-</td>
                  <td>-</td>
                  <td>-</td>
                  <td>-</td>
                  <td>-</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );
};
export default FilterEventTable;
