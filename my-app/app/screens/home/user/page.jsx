"use client";
import EventByTimeHeader from "@/app/component/data-analysis/eventByTime.header";
import Loading from "@/app/component/UI/Loading";
import FilterUserTable from "@/app/component/user/filterUserTable";
import {
  getFilteredUserByTimeRequest,
  getUserListRequest,
} from "@/app/store/reducer";
import moment from "moment";
import Link from "next/link";
import { HomeOutlined } from "@ant-design/icons";
import { useRouter } from "next/navigation";
import React, { Suspense, useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { Breadcrumb, Divider } from "antd";
import { axisClasses, BarChart } from "@mui/x-charts";
import NoData from "@/app/component/UI/NoData";
import UserTable from "@/app/component/user/user.table";

const page = () => {
  //dispathc
  const dispatch = useDispatch();
  //selector
  const { isAuthenticated, filteredUserByTime, listAllUser } = useSelector(
    (state) => state.user
  );
  //router
  const router = useRouter();
  //local state
  const [selectedDateUser, setSelectedDateUser] = useState(
    moment().format("YYYY-MM")
  );
  const [dateType, setDateType] = useState("month");
  //breadcrumb
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
      title: "Danh mục người dùng",
    },
  ];
  //custom function
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
  //custom array
  const groupedData = Object.entries(
    filteredUserByTime?.reduce((acc, item) => {
      const date = item.createdAt.split("T")[0];
      if (!acc[date]) {
        acc[date] = [];
      }
      acc[date].push(item);
      return acc;
    }, {})
  ).map(([dayGroup, data]) => ({ dayGroup, data }));
  const dataset = groupedData?.map((item, index) => ({
    name: `${item.dayGroup}`,
    value: item.data?.length,
  }));
  const fomartListUser = listAllUser?.map((user) => ({
    ...user,
    role: user.role ? user.role : "Member",
  }));
  //useEffect
  useEffect(() => {
    convertTimeForUser(selectedDateUser, dateType);
  }, [selectedDateUser]);
  useEffect(() => {
    const handleFetchData = async () => {
      if (isAuthenticated && listAllUser.length === 0) {
        dispatch(getUserListRequest());
      }
    };
    handleFetchData();
  }, [isAuthenticated]);
  //chart setting
  const chartSetting = {
    series: [
      {
        dataKey: "value",
      },
    ],
    yAxis: [
      {
        label: "Số lượng đăng ký",
      },
    ],
    height: 300,
    sx: {
      [`& .${axisClasses.directionY} .${axisClasses.label}`]: {
        transform: "translateX(-5px)",
        transition: "background-color 0.3s ease",
      },
    },
  };
  //console
  return (
    <div className="p-3">
      {isAuthenticated ? (
        <Suspense fallback={<Loading />}>
          <div className="user-analysis-by-time px-4 py-3">
            <Breadcrumb items={breadcrumbList} />
            <EventByTimeHeader
              selectedDate={selectedDateUser}
              setSelectedDate={setSelectedDateUser}
              setDateType={setDateType}
              title="Danh sách người dùng đăng ký"
            />
          </div>
          {/* <FilterUserTable filteredData={filteredUserByTime} /> */}
          <div className="border-[1px] border-[#D0D5DD] p-2 rounded-lg">
            <BarChart
              dataset={dataset}
              xAxis={[
                {
                  label: "Thời gian",
                  scaleType: "band",
                  dataKey: "name",
                  hideTooltip: true,
                },
              ]}
              hideTooltip={true}
              barLabel="value"
              slotProps={{
                noDataOverlay: {
                  message: "Không có dữ liệu, vui lòng chọn lại thời gian!!!",
                },
              }}
              {...chartSetting}
            />
          </div>

          <Divider />
          <UserTable userData={fomartListUser} />
        </Suspense>
      ) : (
        router.replace("/screens/login")
      )}
    </div>
  );
};

export default page;
