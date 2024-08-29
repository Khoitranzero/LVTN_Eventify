import { ConfigProvider, DatePicker, Select } from "antd";
import React, { useState } from "react";
import dayjs from "dayjs";
import { formatDateTime } from "@/app/helper";

const FutureEventWithTime = (props) => {
  const [timeCollection, setTimeCollection] = useState([
    "7 ngày",
    "14 ngày",
    "21 ngày",
  ]);
  const [picker, setPicker] = useState("");
  const { futureDate, setFutureDate, setFutureDateType } = props;
  const handleChange = (value) => {
    buttonByTime(value);
    setPicker(value);
    setFutureDateType(value);
  };
  const handleTimeButtonClick = (time) => {
    let newStartAt, newEndAt;
    newStartAt = dayjs().startOf("day");

    switch (time) {
      case "7 ngày":
        newEndAt = dayjs().add(7, "day").endOf("day");
        break;
      case "14 ngày":
        newEndAt = dayjs().add(14, "day").endOf("day");
        break;
      case "21 ngày":
        newEndAt = dayjs().add(21, "day").endOf("day");
        break;
      case "1 tháng":
        newStartAt = dayjs().startOf("month").add(1, "month");
        newEndAt = dayjs().add(1, "month").endOf("month");
        break;
      case "3 tháng":
        newStartAt = dayjs().startOf("month").add(1, "month");
        newEndAt = dayjs().add(3, "month").endOf("month");
        break;
      case "6 tháng":
        newStartAt = dayjs().startOf("month").add(1, "month");
        newEndAt = dayjs().add(6, "month").endOf("month");
        break;
      default:
        newEndAt = dayjs().endOf("day");
    }

    setFutureDate({ startAt: newStartAt, endAt: newEndAt });
  };

  const buttonByTime = (picker) => {
    switch (picker) {
      case "month":
        setTimeCollection(["1 tháng", "3 tháng", "6 tháng"]);
        break;
      default:
        setTimeCollection(["7 ngày", "14 ngày", "21 ngày"]);
    }
  };
  return (
    <div className="future-event-header flex flex-col gap-2 md:flex-row w-full justify-between items-center ">
      <div className="label">
        <span className="font-bold text-[25px] whitespace-nowrap flex flex-wrap justify-center items-center">
          Sự kiện diễn ra{" "}
          <span className="text-[20px]">
            {`(${formatDateTime(futureDate.startAt)} - ${formatDateTime(
              futureDate.endAt
            )})`}
          </span>
        </span>
      </div>
      <div className="future-select-section flex gap-2">
        <div className="button-group flex gap-2">
          {timeCollection.map((time, index) => (
            <button
              key={index}
              className="time-button bg-orange-bold-color h-[32px] text-white px-2 rounded"
              onClick={() => handleTimeButtonClick(time)}
            >
              {time}
            </button>
          ))}
        </div>
        <div className="future-event-type">
          <Select
            defaultValue=""
            style={{ width: 120, height: 34 }}
            onChange={handleChange}
            options={[
              { value: "", label: "Ngày" },
              { value: "month", label: "Tháng" },
            ]}
          />
        </div>
      </div>
    </div>
  );
};

export default FutureEventWithTime;
