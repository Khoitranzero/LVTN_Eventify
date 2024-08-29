"use client";
import FullCalendar from "@fullcalendar/react";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import viLocale from "@fullcalendar/core/locales/vi";
import multiMonthPlugin from "@fullcalendar/multimonth";
import interactionPlugin from "@fullcalendar/interaction";
import React, { Suspense, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import Loading from "@/app/component/UI/Loading";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { HomeOutlined } from "@ant-design/icons";
import { Breadcrumb, Divider } from "antd";
import {
  getAllEventRequest,
  updateEventInCalendarRequest,
} from "@/app/store/reducer";
import { slugify } from "@/app/helper";
const page = () => {
  //local state
  //dispatch
  const dispatch = useDispatch();
  //selector
  const { isAuthenticated, allEvent } = useSelector((state) => state.user);
  //router
  const router = useRouter();
  // custom array
  const convertEvents = (events) => {
    return events?.map((event) => ({
      id: event.id,
      title: event.name,
      start: event.startAt,
      end: event.endAt || event.startAt,
      description: event.description,
      backgroundColor: "#EF6820",
      borderColor: "#EF6820",
    }));
  };
  // breadcrumb list
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
      title: "Lịch sự kiện",
    },
  ];
  //custom function
  const handleEventDrop = (info) => {
    const updatedEvent = {
      eventId: info.event.id,
      startAt: info.event.startStr,
      endAt: info.event.endStr,
    };
    setTimeout(() => dispatch(updateEventInCalendarRequest(updatedEvent)), 100);
  };
  const handleEventResize = (info) => {
    const updatedEvent = {
      eventId: info.event.id,
      startAt: info.event.startStr,
      endAt: info.event.endStr,
    };
    setTimeout(() => dispatch(updateEventInCalendarRequest(updatedEvent)), 100);
  };
  const handleEventClick = (info) => {
    const slugEventName = slugify(info.event.title);
    router.push(
      `/screens/home/event_detail?eventId=${info.event.id}&name=${slugEventName}`
    );
  };
  const handleEventDidMount = (info) => {
    const resizerDiv = document.createElement("div");
    resizerDiv.classList.add("fc-event-resizer");
    resizerDiv.classList.add("fc-event-resizer-end");
    const eventMainDiv = info.el.querySelector(".fc-event-main");
    if (eventMainDiv) {
      eventMainDiv.parentNode.insertBefore(
        resizerDiv,
        eventMainDiv.nextSibling
      );
    }
  };
  //useEffect
  useEffect(() => {
    const handleFetchData = async () => {
      if (isAuthenticated && allEvent.length === 0) {
        dispatch(getAllEventRequest());
      }
    };
    handleFetchData();
  }, [isAuthenticated]);
  return (
    <div>
      {isAuthenticated ? (
        <div className=" w-full p-3 h-full">
          <Suspense fallback={<Loading />}>
            <Breadcrumb items={breadcrumbList} />
            <h1 className="text-[30px] font-bold">Lịch sự kiện</h1>
            <Divider />
            <FullCalendar
              plugins={[
                dayGridPlugin,
                multiMonthPlugin,
                timeGridPlugin,
                interactionPlugin,
              ]}
              initialView="multiMonthYear"
              multiMonthMaxColumns={2}
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
              height={800}
              editable={true}
              eventDrop={handleEventDrop}
              eventClick={handleEventClick}
              eventResize={handleEventResize}
              eventDidMount={handleEventDidMount}
            />
          </Suspense>
        </div>
      ) : (
        router.replace("/screens/login")
      )}
    </div>
  );
};

export default page;
