import { Spin } from "antd";
import { useRouter } from "next/navigation";
import React, { useState } from "react";

const MemberInEvent = (props) => {
  const { memberInEvent } = props;
  const [loading, setLoading] = useState({});
  const router = useRouter();
  const handleImageLoad = (id) => {
    setLoading((prevLoading) => ({
      ...prevLoading,
      [id]: false,
    }));
  };
  const showUserInfo = (userId) => {
    router.push(`/screens/home/user_detail?userId=${userId}`);
  };
  return (
    <div className="flex gap-4 flex-wrap">
      {memberInEvent?.map((item) => {
        const isLoading = loading[item?.id] !== false;
        return (
          <div
            key={item?.id}
            className="memberItem flex flex-col items-center cursor-pointer"
            onClick={() => showUserInfo(item?.id)}
          >
            <div className="member-avatar rounded-full w-[50px] h-[50px] relative">
              {isLoading && (
                <div className="ml-2 absolute">
                  <Spin size="large" spinning={true} />
                </div>
              )}
              <img
                src={item?.avatarUrl}
                alt="avatar"
                className="w-[50px] h-[50px] rounded-full"
                onLoad={() => handleImageLoad(item?.id)}
                style={{ display: isLoading ? "none" : "block" }}
                title={item?.name}
              />
            </div>
            <div className="member-name font-semibold text-[15px]">
              {item?.name}
            </div>
            <div className="member-role">{item?.role}</div>
          </div>
        );
      })}
    </div>
  );
};

export default MemberInEvent;
