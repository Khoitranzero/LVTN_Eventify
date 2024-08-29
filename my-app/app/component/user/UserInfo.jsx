import { mapStatus, mapStatusToColor } from "@/app/helper";
import { Divider } from "antd";
import Image from "next/image";
import React from "react";

const UserInfoBody = (props) => {
  const { userInfo, taskData } = props;
  const countTasksByStatus = (tasks) => {
    return tasks?.reduce((acc, curr) => {
      const status = curr.Task.status;
      if (acc[status]) {
        acc[status]++;
      } else {
        acc[status] = 1;
      }
      return acc;
    }, {});
  };
  const taskCounts = countTasksByStatus(taskData);
  console.log(taskData?.Task?.T);
  return (
    <>
      <div className="flex items-center">
        <div className="left flex items-center gap-3">
          <div className="user-info-avatar">
            <Image
              src={userInfo.avatarUrl}
              alt={userInfo.name}
              width={100}
              height={100}
              className="rounded-lg "
            />
          </div>
          <div className="user-information">
            <p>
              <strong>Tên người dùng: </strong>
              {userInfo.name}
            </p>
            <p>
              <strong>Email: </strong>
              {userInfo.email}
            </p>
            <p>
              <strong>Số điện thoại: </strong>
              {userInfo.phone}
            </p>
            <p>
              <strong>Trạng thái tài khoản: </strong>
              {userInfo.activated ? "Đang hoạt động" : "Vô hiệu hóa"}
            </p>
          </div>
        </div>
      </div>
      <Divider />
      <div className="text-lg font-bold mb-4">Nhiệm vụ</div>
      <div className="task-analysis flex gap-2 flex-wrap">
        {Object?.entries(taskCounts || {})?.map(([status, count]) => (
          <div
            className={`task-item border-[1px] rounded-lg border-gray-400 p-2 ${mapStatusToColor(
              status
            )}`}
            key={status}
          >
            <div className="text-lg font-bold">{count}</div>
            <div className="text-md">{mapStatus(status)}</div>
          </div>
        ))}
      </div>
    </>
  );
};

export default UserInfoBody;
