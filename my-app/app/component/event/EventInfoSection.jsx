import { formatDateTime, mapStatus } from "@/app/helper";
import React from "react";

const EventInfoSection = (props) => {
  const { eventInfo } = props;
  return (
    <div>
      <div className="event-information">
        <p>
          <strong>Tên sự kiện: </strong>
          {eventInfo.name}
        </p>
        <p>
          <strong>Loại sự kiện: </strong>
          {eventInfo?.EventCategory?.name}
        </p>
        <p>
          <strong>Trạng thái: </strong>
          {mapStatus(eventInfo.status)}
        </p>
        <p>
          <strong>Mô tả: </strong>
          {eventInfo.description}
        </p>
        <p>
          <strong>Ngày bắt đầu: </strong>
          {formatDateTime(eventInfo.startAt)}
        </p>
        <p>
          <strong>Ngày kết thúc: </strong>
          {formatDateTime(eventInfo.endAt)}
        </p>
        <p>
          <strong>Địa điểm: </strong>
          {eventInfo.location}
        </p>
      </div>
    </div>
  );
};

export default EventInfoSection;
