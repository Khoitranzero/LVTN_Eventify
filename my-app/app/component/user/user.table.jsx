"use client";
import { Popconfirm, Spin, Table } from "antd";
import React, { useEffect, useState } from "react";
import {
  PoweroffOutlined,
  ReloadOutlined,
  InfoCircleOutlined,
  FrownOutlined,
  SmileOutlined,
  LoadingOutlined,
  UsergroupAddOutlined,
} from "@ant-design/icons";
import { useDebounce } from "use-debounce";
import {
  getBlockUserRequest,
  getUnBlockUserRequest,
  getUserListRequest,
  setLoadingUser,
  updateUserPermissionRequest,
} from "@/app/store/reducer";
import { useDispatch, useSelector } from "react-redux";
import "../../assets/css/table_custom.scss";
import { useRouter } from "next/navigation";
function UserTable(props) {
  const { userData } = props;
  const { loadingUser } = useSelector((state) => state.user);
  const [filteredUser, setFilteredUser] = useState(userData);
  const [search, setSearch] = useState("");
  const router = useRouter();
  const [debounce] = useDebounce(search, 500);
  const dispatch = useDispatch();
  //Custom function
  const handleBlockUser = (email) => {
    dispatch(getBlockUserRequest(email));
  };
  const handleUnBlockUser = (email) => {
    dispatch(getUnBlockUserRequest(email));
  };
  const showUserInfo = (userId) => {
    router.push(`/screens/home/user_detail?userId=${userId}`);
  };
  const reloadEventTable = () => {
    dispatch(setLoadingUser(true));
    setTimeout(() => dispatch(getUserListRequest()), 1000);
  };
  const handleSearch = (event) => {
    const value = event.target.value;
    setSearch(value);
  };
  const handleUpdateUserPermission = (id) => {
    dispatch(setLoadingUser(true));
    setTimeout(() => dispatch(updateUserPermissionRequest(id)), 1000);
  };
  //useEffect
  useEffect(() => {
    if (debounce) {
      const lowercasedFilter = debounce.toLowerCase();
      const filtered = userData.filter(
        (user) =>
          user.name.toLowerCase().includes(lowercasedFilter) ||
          user.email.toLowerCase().includes(lowercasedFilter) ||
          user.phone.toLowerCase().includes(lowercasedFilter)
      );
      setFilteredUser(filtered);
    } else {
      setFilteredUser(userData);
    }
  }, [debounce, userData]);
  const theader = [
    "No.",
    "Họ và tên",
    "Email",
    "Số điện thoại",
    "Role",
    "Trạng thái",
    "Thao tác",
  ];
  return (
    <div className="">
      <Spin
        indicator={
          <LoadingOutlined
            style={{
              fontSize: 48,
            }}
          />
        }
        spinning={loadingUser}
        fullscreen
        tip="Đang tải dữ liệu"
      />
      <div className="flex justify-between items-center flex-col md:flex-row gap-2">
        <span className="font-bold text-[30px] whitespace-nowrap">
          Tất cả người dùng
        </span>
        {/* <div className="btns ">
          <button
            className="bg-primary px-3 mx-2 py-2 border-[1px] text-black font-bold text-[15px] rounded-lg hover:bg-white transition-all duration-300 delay-100 hover:text-primary"
            onClick={reloadEventTable}
          >
            <ReloadOutlined />
          </button>
          <button
            className="bg-primary px-2 py-2 border-primary border-[1px] text-black font-bold text-[15px] rounded-lg hover:bg-white transition-all duration-300 delay-100 hover:text-primary"
            onClick={showCreateModal}
          >
            Thêm sự kiện
          </button>
        </div> */}
        <div className="btns">
          <input
            type="text"
            className="border-[1px] py-[7px] rounded-lg px-2 transition-all duration-300 delay-100 outline-0"
            placeholder="Tìm kiếm người dùng"
            value={search}
            onChange={handleSearch}
          />
          <button
            className="bg-orange-bold-color px-3 mx-2 py-[7px] border-[1px] text-white font-bold text-[15px] rounded-lg hover:bg-orange-fade-color hover:border-[1px] hover:border-orange-bold-color transition-all duration-300 delay-100 hover:text-orange-bold-color"
            onClick={reloadEventTable}
          >
            <ReloadOutlined />
          </button>
        </div>
      </div>
      <div className="my-2 h-[350px] overflow-auto">
        <table>
          <thead>
            <tr>
              {theader?.map((headerItem, index) => (
                <th key={index}>{headerItem}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {filteredUser.length !== 0 ? (
              filteredUser?.map((item, index) => {
                return (
                  <>
                    <tr key={index}>
                      <td>{index + 1}</td>
                      <td>{item.name}</td>
                      <td>{item.email}</td>
                      <td>{item.phone}</td>
                      <td>{item.role}</td>
                      <td>
                        {item.activated ? (
                          <>
                            Đang hoạt động <SmileOutlined />
                          </>
                        ) : (
                          <>
                            Vô hiệu hóa <FrownOutlined />
                          </>
                        )}
                      </td>
                      <td>
                        <Popconfirm
                          placement="leftTop"
                          title={"Xác nhận vô hiệu hóa"}
                          description={
                            item.activated == false
                              ? "Bạn có chắc chắn muốn kích hoạt người dùng này ?"
                              : "Bạn có chắc chắn muốn vô hiệu hóa người dùng này ?"
                          }
                          onConfirm={() =>
                            item.activated
                              ? handleBlockUser(item.email)
                              : handleUnBlockUser(item.email)
                          }
                          okText="Xác nhận"
                          cancelText="Hủy"
                        >
                          <span
                            className={`cursor-pointer ${
                              item.activated ? "text-red-500" : "text-blue-400"
                            }`}
                          >
                            <PoweroffOutlined />
                          </span>
                        </Popconfirm>
                        <InfoCircleOutlined
                          twoToneColor={"#f57800"}
                          className="cursor-pointer ml-2"
                          onClick={() => {
                            showUserInfo(item.id);
                          }}
                        />
                        <Popconfirm
                          placement="leftTop"
                          title="Xác nhận cấp quyền"
                          description={
                            item.role !== "Admin"
                              ? "Bạn có chắc chắn muốn đưa người dùng này lên quản trị viên không "
                              : "Bạn có chắc chắn muốn xóa quyền quản trị của người dùng này hay không "
                          }
                          okText="Xác nhận"
                          cancelText="Hủy"
                          onConfirm={() => {
                            handleUpdateUserPermission(item.id);
                          }}
                          className="cursor-pointer ml-2"
                        >
                          <UsergroupAddOutlined />
                        </Popconfirm>
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
                <td>-</td>
                <td>-</td>
              </tr>
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default UserTable;
