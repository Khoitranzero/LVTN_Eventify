"use client";
import React, { useState } from "react";
import * as svg from "../../constants/svg.js";
import { DatePicker, Select } from "antd";
import "./style/data_analysis.scss";
import dayjs from "dayjs";
const EventByTimeHeader = (props) => {
  const { selectedDate, setSelectedDate, dateType, setDateType, title } = props;
  const [picker, setPicker] = useState("month");
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
        type = "tháng";
    }
    return type;
  };
  return (
    <div className="event-by-time-header flex flex-col gap-2 md:flex-row justify-between items-center ">
      <div className="label">
        <span className="font-bold text-[25px] whitespace-nowrap">{title}</span>
      </div>
      <div className="date-picker-select-section flex gap-2">
        <div className="time-picker h-[34px]">
          <DatePicker
            value={dayjs(selectedDate)}
            defaultValue={dayjs(selectedDate)}
            placeholder={"Chọn " + datePickerPlaceholder(picker)}
            picker={picker != "" ? picker : "month"}
            onChange={(date) => setSelectedDate(date)}
            allowClear={false}
          />
        </div>
        <div className="date-picker-type">
          <Select
            defaultValue="month"
            style={{ width: 120, height: 34 }}
            onChange={handleChange}
            options={[
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

export default EventByTimeHeader;
