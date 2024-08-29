import { ConfigProvider, DatePicker, Select } from "antd";
import React, { useState } from "react";
import dayjs from "dayjs";

const FutureEvent = (props) => {
  // const [timeCollection, setTimeCollection] = useState([
  //   "7 ngày tới",
  //   "14 ngày tới",
  //   "21 ngày tới",
  // ]);
  const [picker, setPicker] = useState("");
  const { RangePicker } = DatePicker;
  const { futureDate, setFutureDate, setFutureDateType } = props;
  const handleChange = (value) => {
    // buttonByTime(value);
    setPicker(value);
    setFutureDateType(value);
  };
  const handleDatePickerRangeChange = (range, picker) => {
    const [startMoment, endMoment] = range;
    let startAt, endAt;
    switch (picker) {
      case "month":
        startAt = startMoment.startOf("day").format("YYYY-MM");
        endAt = endMoment.endOf("day").format("YYYY-MM");
        break;
      case "quarter":
        startAt = startMoment.startOf("quarter").format("YYYY-[Q]Q");
        endAt = endMoment.endOf("quarter").format("YYYY-[Q]Q");
        break;
      case "year":
        startAt = startMoment.startOf("year").format("YYYY");
        endAt = endMoment.endOf("year").format("YYYY");
        break;
      default:
        startAt = startMoment.startOf("day").format("YYYY-MM-DD");
        endAt = endMoment.endOf("day").format("YYYY-MM-DD");
    }
    setFutureDate({ startAt, endAt });
  };
  const handleTimeButtonClick = (time) => {
    let newStartAt, newEndAt;
    newStartAt = dayjs().startOf("day"); // Ngày hôm nay

    switch (time) {
      case "7 ngày tới":
        newEndAt = dayjs().add(7, "day").endOf("day");
        break;
      case "14 ngày tới":
        newEndAt = dayjs().add(14, "day").endOf("day");
        break;
      case "21 ngày tới":
        newEndAt = dayjs().add(21, "day").endOf("day");
        break;
      case "1 tháng":
        newEndAt = dayjs().add(1, "month").endOf("month");
        break;
      case "3 tháng":
        newEndAt = dayjs().add(3, "month").endOf("month");
        break;
      case "6 tháng":
        newEndAt = dayjs().add(6, "month").endOf("month");
        break;
      case "9 tháng":
        newEndAt = dayjs().add(9, "month").endOf("month");
        break;
      case "Quý sau":
        newEndAt = dayjs().add(1, "quarter").endOf("quarter");
        break;
      case "Quý tới":
        newEndAt = dayjs().add(2, "quarter").endOf("quarter");
        break;
      case "Quý cuối":
        newEndAt = dayjs().add(3, "quarter").endOf("quarter");
        break;
      case "1 năm sau":
        newEndAt = dayjs().add(1, "year").endOf("year");
        break;
      case "3 năm sau":
        newEndAt = dayjs().add(3, "year").endOf("year");
        break;
      case "5 năm sau":
        newEndAt = dayjs().add(5, "year").endOf("year");
        break;
      default:
        newEndAt = dayjs().endOf("day");
    }

    setFutureDate({ startAt: newStartAt, endAt: newEndAt });
  };

  const buttonByTime = (picker) => {
    switch (picker) {
      case "month":
        setTimeCollection(["1 tháng", "3 tháng", "6 tháng", "9 tháng"]);
        break;
      case "quarter":
        setTimeCollection(["Quý sau", "Quý tới", "Quý cuối"]);
        break;
      case "year":
        setTimeCollection(["1 năm sau", "3 năm sau", "5 năm sau"]);
        break;
      default:
        setTimeCollection(["7 ngày tới", "14 ngày tới", "21 ngày tới"]);
    }
  };
  return (
    <div className="future-event-header flex flex-col gap-2 md:flex-row justify-between items-center ">
      <div className="label">
        <span className="font-bold text-[25px] whitespace-nowrap">
          Tìm kiếm sự kiện
        </span>
      </div>
      <div className="future-select-section flex gap-2">
        {/* <div className="button-group flex gap-2">
          {timeCollection.map((time, index) => (
            <button
              key={index}
              className="time-button bg-green-400 h-[34px] text-black px-2 rounded"
              onClick={() => handleTimeButtonClick(time)}
            >
              {time}
            </button>
          ))}
        </div> */}
        {/* <div className="time-picker hidden">
          <DatePicker
            value={dayjs(futureDate)}
            defaultValue={dayjs(futureDate)}
            picker={picker != "" ? picker : "date"}
            onChange={(date) => setFutureDate(date)}
            allowClear={false}
          />
        </div> */}
        <RangePicker
          placeholder={["Bắt đầu", "Kết thúc"]}
          picker={picker != "" ? picker : "date"}
          onChange={(value) => handleDatePickerRangeChange(value, picker)}
          allowClear={false}
        />
        <div className="future-event-type">
          <Select
            defaultValue=""
            style={{ width: 120, height: 34 }}
            onChange={handleChange}
            options={[
              { value: "", label: "Ngày" },
              { value: "month", label: "Tháng" },
              { value: "quarter", label: "Quý" },
              { value: "year", label: "Năm" },
            ]}
          />
        </div>
      </div>
    </div>
  );
};

export default FutureEvent;
