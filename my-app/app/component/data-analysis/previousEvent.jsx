import { DatePicker, Select } from "antd";
import React, { useState } from "react";
import dayjs from "dayjs";
import moment from "moment";
const PreviousEvent = (props) => {
  const { RangePicker } = DatePicker;
  const [timeCollection, setTimeCollection] = useState([
    "7 ngày trước",
    "12 ngày trước",
    "20 ngày trước",
  ]);
  const [picker, setPicker] = useState("");
  const { previoustDate, setPreviousDate, setPreviousDateType } = props;
  const handleChange = (value) => {
    buttonByTime(value);
    setPicker(value);
    setPreviousDateType(value);
  };
  // const handleDatePickerRangeChange = (value, picker) => {
  //   let startAt, endAt;
  //   switch (picker) {
  //     case "month":
  //       startAt = moment(value[0].$d).format("YYYY-MM-DD");
  //       endAt = moment(value[1].$d).format("YYYY-MM-DD");
  //   }
  //   // setPreviousDate({ startAt: value, endAt: newEndAt });
  //   console.log("Ngày bắt đầu:", value);
  //   console.log("Ngày kết thúc:", endAt);
  // };
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
    // setPreviousDate({ startAt, endAt });
  };
  const handleTimeButtonClick = (time) => {
    let newStartAt, newEndAt;
    newEndAt = dayjs().startOf("day");
    switch (time) {
      case "7 ngày trước":
        newStartAt = dayjs().subtract(7, "day").endOf("day");
        break;
      case "12 ngày trước":
        newStartAt = dayjs().subtract(12, "day").endOf("day");
        break;
      case "20 ngày trước":
        newStartAt = dayjs().subtract(20, "day").endOf("day");
        break;
      case "1 tháng":
        newStartAt = dayjs().subtract(1, "month").endOf("month");
        break;
      case "3 tháng":
        newStartAt = dayjs().subtract(3, "month").endOf("month");
        break;
      case "6 tháng":
        newStartAt = dayjs().subtract(6, "month").endOf("month");
        break;
      case "9 tháng":
        newStartAt = dayjs().subtract(9, "month").endOf("month");
        break;
      case "Quý sau":
        newStartAt = dayjs().subtract(1, "quarter").endOf("quarter");
        break;
      case "Quý tới":
        newStartAt = dayjs().subtract(2, "quarter").endOf("quarter");
        break;
      case "Quý cuối":
        newStartAt = dayjs().subtract(3, "quarter").endOf("quarter");
        break;
      case "1 năm trước":
        newStartAt = dayjs().subtract(1, "year").endOf("year");
        break;
      case "3 năm trước":
        newStartAt = dayjs().subtract(3, "year").endOf("year");
        break;
      case "5 năm trước":
        newStartAt = dayjs().subtract(5, "year").endOf("year");
        break;
      default:
        newEndAt = dayjs().startOf("day");
        newStartAt = dayjs().endOf("day");
    }

    setPreviousDate({ startAt: newStartAt, endAt: newEndAt });
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
        setTimeCollection(["1 năm trước", "3 năm trước", "5 năm trước"]);
        break;
      default:
        setTimeCollection(["7 ngày trước", "12 ngày trước", "20 ngày trước"]);
    }
  };
  return (
    <div className="future-event-header flex flex-col gap-2 md:flex-row justify-between items-center ">
      <div className="label">
        <span className="font-bold text-[30px] whitespace-nowrap">
          Sự kiện trước đó
        </span>
      </div>
      <div className="future-select-section flex gap-2">
        <div className="button-group flex gap-2">
          {timeCollection.map((time, index) => (
            <button
              key={index}
              className="time-button bg-green-400 h-[34px] text-black px-2 rounded"
              onClick={() => handleTimeButtonClick(time)}
            >
              {time}
            </button>
          ))}
        </div>
        <div className="time-picker hidden">
          <DatePicker
            value={dayjs(previoustDate)}
            defaultValue={dayjs(previoustDate)}
            picker={picker != "" ? picker : "date"}
            onChange={(date) => setPreviousDate(date)}
            allowClear={false}
          />
        </div>
        <div className="time-picker-range">
          <RangePicker
            picker={picker != "" ? picker : "date"}
            onChange={(value) => handleDatePickerRangeChange(value, picker)}
            allowClear={false}
          />
        </div>
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

export default PreviousEvent;
