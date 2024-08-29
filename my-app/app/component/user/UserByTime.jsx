"use client";
import React, { useState } from "react";
import { DatePicker, Select } from "antd";
import "./style/data_analysis.scss";
import dayjs from "dayjs";
const UserByTime = (props) => {
  const { selectedDate, setSelectedDate, setDateType, title } = props;
  const [picker, setPicker] = useState("");
  const handleChange = (value) => {
    setPicker(value);
    setDateType(value);
  };
  const datePickerPlaceholder = (picker) => {
    let type = "";
    switch (picker) {
      case "month":
        type = "tháng";
        break;
      case "quarter":
        type = "quý";
        break;
      case "year":
        type = "năm";
        break;
      default:
        type = "ngày";
    }
    return type;
  };
  return (
    <div className="event-by-time-header flex flex-col gap-2 md:flex-row justify-between items-center ">
      <div className="label">
        <span className="font-bold text-[30px] whitespace-nowrap">Người dùng</span>
      </div>
      <div className="date-picker-select-section flex gap-2">
        <div className="time-picker h-[34px]">
          <DatePicker
            value={dayjs(selectedDate)}
            defaultValue={dayjs(selectedDate)}
            placeholder={"Chọn " + datePickerPlaceholder(picker)}
            picker={picker != "" ? picker : "date"}
            onChange={(date) => setSelectedDate(date)}
            allowClear={false}
          />
        </div>
        <div className="date-picker-type">
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

export default UserByTime;
