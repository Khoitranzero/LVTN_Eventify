"use client";
import { formatDateTime, slugify } from "@/app/helper";
import React from "react";
import leader_icon from "../../assets/image/leader-icon.png";
import member_icon from "../../assets/image/membership-icon.png";
import deputy_icon from "../../assets/image/deputy-icon.png";
import { InfoCircleOutlined } from "@ant-design/icons";
import Image from "next/image";
import { useRouter } from "next/navigation";
const UserEventTable = (props) => {
  const { eventData } = props;
  const router = useRouter();
  const handleShowEventInfo = (eventId, eventName) => {
    const slugEventName = slugify(eventName);
    router.push(
      `/screens/home/event_detail?eventId=${eventId}&name=${slugEventName}`
    );
  };
  return (
    <div className="grid grid-cols-1 md:grid-cols-2 gap-2">
      {eventData?.map((item, index) => {
        return (
          <>
            <div className="event-item border-[1px] border-gray-500 rounded-lg p-2 flex justify-between gap-2">
              <div className="flex gap-2 items-center object-cover">
                <Image
                  src={
                    item.roleId === "Leader" || item.roleId === "Master"
                      ? leader_icon
                      : item.roleId === "Deputy"
                      ? deputy_icon
                      : member_icon
                  }
                  alt="icon"
                  width={70}
                  height={100}
                />
                <div className="event-item-info">
                  <p>Tên sự kiện: {item?.Event?.name}</p>
                  <p>Chức vụ: {item?.roleId}</p>
                  <p>Ngày tham gia: {formatDateTime(item?.createdAt)}</p>
                </div>
              </div>
              <div className="event-info-button flex items-center ml-10">
                <InfoCircleOutlined
                  twoToneColor={"#f57800"}
                  className="cursor-pointer text-[30px]"
                  onClick={() =>
                    handleShowEventInfo(item?.eventId, item?.Event?.name)
                  }
                />
              </div>
            </div>
          </>
        );
      })}
    </div>
  );
};

export default UserEventTable;
