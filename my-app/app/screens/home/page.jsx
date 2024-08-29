"use client";
import React, { Suspense, useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useRouter } from "next/navigation";
import {
  getAllEventRequest,
  getFilteredEventByTimeRequest,
  getFilteredEventInFutureRequest,
  getFinishedEventRequest,
  getUserListRequest,
  updateEventInCalendarRequest,
} from "@/app/store/reducer";
import { HomeOutlined } from "@ant-design/icons";
import {
  formatDateTime,
  formatFullTime,
  formatMonthTime,
  getRandomColor,
  slugify,
} from "@/app/helper";
import EventTable from "@/app/component/event/event.table";
import UserTable from "@/app/component/user/user.table";
import { Breadcrumb, Divider } from "antd";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import viLocale from "@fullcalendar/core/locales/vi";
import interactionPlugin from "@fullcalendar/interaction";
import Loading from "@/app/component/UI/Loading";
import * as svg from "../../assets/svg/index";
import Link from "next/link";
import { axisClasses, BarChart } from "@mui/x-charts";
import moment from "moment";
import EventByTimeHeader from "@/app/component/data-analysis/eventByTime.header";
import FutureEvent from "@/app/component/data-analysis/futureEvent";
import FilterFutureEventTable from "@/app/component/data-analysis/filterFutureEventTable";
import NoData from "@/app/component/UI/NoData";
function Page() {
  const router = useRouter();
  const {
    account,
    status,
    isAuthenticated,
    allEvent,
    listAllUser,
    finishedEvent,
    filteredEventByTime,
    filteredEventInFuture,
  } = useSelector((state) => state.user);
  const dispatch = useDispatch();
  //define
  const convertEvents = (events) => {
    return events?.map((event) => ({
      id: event.id,
      title: event.name,
      start: event.startAt,
      end: event.endAt || event.startAt,
      description: event.description,
    }));
  };
  //local state
  const [selectedDate, setSelectedDate] = useState(moment());
  const [dateType, setDateType] = useState("");
  const [futureDate, setFutureDate] = useState(moment());
  const [futureDateType, setFutureDateType] = useState("");

  //custom array
  const analysisGroup = [
    {
      numberData: allEvent.length,
      subtitle: "Tổng số sự kiện",
      icon: svg.calendarPlusIcon,
    },
    {
      numberData: listAllUser.length,
      subtitle: "Tổng số người dùng",
      icon: svg.userPlusIcon,
    },
    {
      numberData: finishedEvent.length,
      subtitle: "Sự kiện đã hoàn thành",
      icon: svg.calendarCheckIcon,
    },
  ];
  //Custom function
  const formattedEvents = allEvent.map((event) => ({
    ...event,
    startAt: formatDateTime(event.startAt),
    endAt: formatDateTime(event.endAt),
  }));
  const fomartListUser = listAllUser?.map((user) => ({
    ...user,
    role: user.role ? user.role : "Member",
  }));
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
        convert = moment(selectedDate.$d).format("YYYY-MM");
        data = {
          time: convert,
          timeType: "month",
        };
        dispatch(getFilteredEventByTimeRequest(data));
    }
  };
  const convertFutureTime = (futureDate, dateType) => {
    let data;
    switch (dateType) {
      case "month":
        data = {
          startAt: futureDate.startAt,
          endAt: futureDate.endAt,
          timeType: "month",
        };
        dispatch(getFilteredEventInFutureRequest(data));
        break;
      case "quarter":
        data = {
          startAt: futureDate.startAt,
          endAt: futureDate.endAt,
          timeType: "quarter",
        };
        dispatch(getFilteredEventInFutureRequest(data));
        break;
      case "year":
        data = {
          startAt: futureDate.startAt,
          endAt: futureDate.endAt,
          timeType: "year",
        };
        dispatch(getFilteredEventInFutureRequest(data));
        break;
      default:
        data = {
          startAt:
            futureDate?.startAt ||
            moment(futureDate?.startAt?.$d).format("YYYY-MM-DD"),
          endAt:
            futureDate?.endAt ||
            moment(futureDate?.endAt?.$d).format("YYYY-MM-DD"),
          timeType: "date",
        };
        dispatch(getFilteredEventInFutureRequest(data));
    }
  };
  //useEffect
  useEffect(() => {
    const handleFetchData = async () => {
      if (
        isAuthenticated &&
        allEvent.length === 0 &&
        listAllUser.length === 0
      ) {
        dispatch(getAllEventRequest());
        dispatch(getUserListRequest());
      }
    };
    handleFetchData();
  }, [isAuthenticated]);
  useEffect(() => {
    if (allEvent == 0) {
      dispatch(getAllEventRequest());
      dispatch(getUserListRequest());
      dispatch(getFinishedEventRequest());
    }
  }, [allEvent.length, listAllUser.length, finishedEvent.length]);
  useEffect(() => {
    convertTimeForEvent(selectedDate, dateType);
  }, [selectedDate]);
  useEffect(() => {
    convertFutureTime(futureDate, futureDateType);
  }, [futureDate]);
  //custom breadcrumb
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
      title: "Dashboard",
    },
  ];
  //filter
  const eventCountByMonth = Array(12).fill(0);

  filteredEventByTime?.forEach((event) => {
    const month = new Date(event.createdAt).getMonth();
    eventCountByMonth[month]++;
  });

  // Tạo dữ liệu cho biểu đồ
  const eventCategory = eventCountByMonth
    .map((count, index) => ({
      name: `${index + 1}`,
      eventCount: count,
    }))
    .filter((item) => item.eventCount > 0);
  const valueFormatter = (value) => `${value} sự kiện`;
  //chart setting
  const chartSetting = {
    series: [
      {
        dataKey: "eventCount",
        valueFormatter,
      },
    ],
    yAxis: [
      {
        label: "Số lượng",
      },
    ],
    height: 300,
    sx: {
      [`& .${axisClasses.directionY} .${axisClasses.label}`]: {
        transform: "translateX(-10px)",
        transition: "background-color 0.3s ease",
      },
    },
  };
  return (
    <div>
      {isAuthenticated ? (
        <>
          <div className=" w-full p-3 h-full">
            <Suspense fallback={<Loading />}>
              <Breadcrumb items={breadcrumbList} />
              <h1 className="text-[30px] font-bold">Dashboard</h1>
              <Divider />
              {/* Analysis item */}
              <div className="analysis-group grid md:grid-cols-3 sm:grid-cols-1 gap-2 grid-cols-1">
                {analysisGroup?.map((item, index) => {
                  return (
                    <>
                      <div className="analysis-item hover:bg-slate-100 bg-white flex justify-between items-center border-[1px] border-[#98A2B3] rounded-lg px-[20px] py-6 ">
                        <div className="left">
                          <div className="title font-bold text-[28px]">
                            {item.numberData}
                          </div>
                          <div className="sub-title">{item.subtitle}</div>
                        </div>
                        <div className="right w-12 h-12 p-4 bg-green-100 rounded-full">
                          <span>{item.icon}</span>
                        </div>
                      </div>
                    </>
                  );
                })}
              </div>
              <Divider />
              <div className="chart-section border-[1px] border-[#98A2B3] p-3 rounded-lg bg-white">
                <EventByTimeHeader
                  selectedDate={selectedDate}
                  setSelectedDate={setSelectedDate}
                  setDateType={setDateType}
                  title="Sự kiện tạo ra"
                />

                <BarChart
                  dataset={eventCategory}
                  xAxis={[
                    {
                      label: "Tháng",
                      scaleType: "band",
                      dataKey: "name",
                      hideTooltip: true,
                    },
                  ]}
                  slotProps={{
                    noDataOverlay: {
                      message:
                        "Không có dữ liệu, vui lòng chọn lại thời gian!!!",
                    },
                  }}
                  hideTooltip={true}
                  barLabel="value"
                  {...chartSetting}
                />
              </div>
              <Divider />
              <div className="schedule-event border-[1px] border-[#98A2B3] p-3 rounded-lg bg-white">
                <FutureEvent
                  futureDate={futureDate}
                  setFutureDate={setFutureDate}
                  setFutureDateType={setFutureDateType}
                />
                {filteredEventInFuture?.length != 0 ? (
                  <FilterFutureEventTable
                    filteredData={filteredEventInFuture}
                  />
                ) : (
                  <div className="h-[300px] flex items-center justify-center">
                    <NoData />
                  </div>
                )}
              </div>
            </Suspense>
            {/* <EventTable eventData={formattedEvents} /> */}
            {/* <Divider /> */}
            {/* <FullCalendar
              plugins={[dayGridPlugin, timeGridPlugin, interactionPlugin]}
              initialView="dayGridMonth"
              events={convertEvents(allEvent)}
              headerToolbar={{
                start: "today",
                center: "title",
                end: "prev,next",
              }}
              locale={viLocale}
              eventContent={({ event }) => (
                <div>
                  <strong>{event.title}</strong>
                  <p>{event.extendedProps.description}</p>
                </div>
              )}
              height={600}
              editable={true}
              eventResizableFromStart={true}
              eventDrop={handleEventDrop}
              eventClick={handleEventClick}
              eventResize={handleEventResize}
              eventDidMount={handleEventDidMount}
              eventColor="#f57800"
            /> */}
            {/* 
            <br />
            <UserTable userData={fomartListUser} /> */}
          </div>
        </>
      ) : (
        router.replace("/screens/login")
      )}
    </div>
  );
}

export default Page;
