"use client";
import BudgetCategoryAnalysis from "@/app/component/BudgetCategoryAnalysis";
import DataAnalysis from "@/app/component/DataAnalysis";
import Loading from "@/app/component/UI/Loading";
import { Breadcrumb, Divider } from "antd";
import Link from "next/link";
import { HomeOutlined } from "@ant-design/icons";
import { useRouter } from "next/navigation";
import React, { Suspense, useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import EventByTimeHeader from "@/app/component/data-analysis/eventByTime.header";
import moment from "moment";
import {
  getAllEventRequest,
  getFilteredEventBackPreviousRequest,
  getFilteredEventByTimeRequest,
  getFilteredEventInFutureRequest,
  getFilteredUserByTimeRequest,
  getFinishedEventRequest,
  getUserListRequest,
} from "@/app/store/reducer";
import FilterEventTable from "@/app/component/data-analysis/filterEventTable";
import FilterUserTable from "@/app/component/user/filterUserTable";
import FutureEvent from "@/app/component/data-analysis/futureEvent";
import FilterFutureEventTable from "@/app/component/data-analysis/filterFutureEventTable";
import PreviousEvent from "@/app/component/data-analysis/previousEvent";
import * as svg from "../../../assets/svg/index";
import { axisClasses, BarChart } from "@mui/x-charts";
import { getRandomColor } from "@/app/helper";
function page() {
  const {
    isAuthenticated,
    filteredEventByTime,
    filteredUserByTime,
    filteredEventInFuture,
    filteredEventBackPrevious,
    allEvent,
    listAllUser,
    finishedEvent,
    eventCategory,
  } = useSelector((state) => state.user);
  //define
  const router = useRouter();
  const dispatch = useDispatch();
  const [selectedDate, setSelectedDate] = useState(moment());
  const [selectedDateUser, setSelectedDateUser] = useState(moment());
  const [futureDate, setFutureDate] = useState(moment());
  // const [previousDate, setPreviousDate] = useState(moment());
  // const [previousDateType, setPreviousDateType] = useState("");
  const [dateType, setDateType] = useState("");
  const [futureDateType, setFutureDateType] = useState("");
  const breadcrumbList = [
    {
      title: (
        <>
          <Link href={"/screens/home"}>
            <HomeOutlined />
          </Link>
        </>
      ),
    },
    {
      title: "Danh mục sự kiện",
    },
  ];
  const convertTimeForEvent = (selectedDate, dateType) => {
    let convert;
    let data;
    switch (dateType) {
      case "month":
        convert = moment(selectedDate.$d).format("YYYY-MM");
        data = {
          time: convert,
          timeType: dateType,
        };
        dispatch(getFilteredEventByTimeRequest(data));
        break;
      case "quarter":
        convert = moment(selectedDate.$d).format("YYYY-[Q]Q");
        data = {
          time: convert,
          timeType: dateType,
        };
        dispatch(getFilteredEventByTimeRequest(data));
        break;
      case "year":
        convert = moment(selectedDate.$d).format("YYYY");
        data = {
          time: convert,
          timeType: dateType,
        };
        dispatch(getFilteredEventByTimeRequest(data));
        break;
      default:
        convert = moment(selectedDate.$d).format("YYYY-MM-DD");
        data = {
          time: convert,
          timeType: "date",
        };
        dispatch(getFilteredEventByTimeRequest(data));
    }
  };
  const convertTimeForUser = (selectedDate, dateType) => {
    let convert;
    let data;
    switch (dateType) {
      case "month":
        convert = moment(selectedDate.$d).format("YYYY-MM");
        data = {
          time: convert,
          timeType: dateType,
        };
        dispatch(getFilteredUserByTimeRequest(data));
        break;
      case "quarter":
        convert = moment(selectedDate.$d).format("YYYY-[Q]Q");
        data = {
          time: convert,
          timeType: dateType,
        };
        dispatch(getFilteredUserByTimeRequest(data));
        break;
      case "year":
        convert = moment(selectedDate.$d).format("YYYY");
        data = {
          time: convert,
          timeType: dateType,
        };
        dispatch(getFilteredUserByTimeRequest(data));
        break;
      default:
        convert = moment(selectedDate.$d).format("YYYY-MM-DD");
        data = {
          time: convert,
          timeType: "date",
        };
        dispatch(getFilteredUserByTimeRequest(data));
    }
  };
  // useEffect(() => {
  //   convertTimeForEvent(selectedDate, dateType);
  // }, [selectedDate]);
  // useEffect(() => {
  //   convertTimeForUser(selectedDateUser, dateType);
  // }, [selectedDateUser]);
  // useEffect(() => {
  //   if (allEvent == 0) {
  //     dispatch(getAllEventRequest());
  //     dispatch(getUserListRequest());
  //     dispatch(getFinishedEventRequest());
  //   }
  // }, [allEvent.length, listAllUser.length, finishedEvent.length]);
  return (
    <div>
      {isAuthenticated ? (
        <div className="data-analysis-container">
          <div className="data-analysis-body py-3 px-4">
            <Suspense fallback={<Loading />}>
              <Breadcrumb items={breadcrumbList} />
              <DataAnalysis />
            </Suspense>
          </div>
        </div>
      ) : (
        router.replace("/screens/login")
      )}
    </div>
  );
}

export default page;
