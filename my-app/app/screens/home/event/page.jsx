"use client";
import EventTable from "@/app/component/event/event.table";
import Loading from "@/app/component/UI/Loading";
import { getAllEventRequest } from "@/app/store/reducer";
import { Breadcrumb } from "antd";
import Link from "next/link";
import { useRouter } from "next/navigation";
import React, { Suspense, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { HomeOutlined } from "@ant-design/icons";
import { formatDateTime } from "@/app/helper";
const page = () => {
  // local state

  // dispatch
  const dispatch = useDispatch();
  // selector
  const { isAuthenticated, allEvent } = useSelector((state) => state.user);
  //router
  const router = useRouter();
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
      title: "Tất cả sự kiện",
    },
  ];
  //   Custom array
  const formattedEvents = allEvent?.map((event) => ({
    ...event,
    startAt: formatDateTime(event.startAt),
    endAt: formatDateTime(event.endAt),
  }));
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
        <div className="w-full p-3 h-full">
          <Suspense fallback={<Loading />}>
            <Breadcrumb items={breadcrumbList} />
            <EventTable eventData={formattedEvents} />
          </Suspense>
        </div>
      ) : (
        router.replace("/screens/login")
      )}
    </div>
  );
};

export default page;
