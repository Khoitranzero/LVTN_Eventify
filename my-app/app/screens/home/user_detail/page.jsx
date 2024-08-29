"use client";
import Loading from "@/app/component/UI/Loading";
import UserEventTable from "@/app/component/user/UserEvent.table";
import { getUserInfoRequest } from "@/app/store/reducer";
import { Breadcrumb, Divider } from "antd";
import { useSearchParams } from "next/navigation";
import React, { Suspense, useEffect } from "react";
import { useDispatch, useSelector } from "react-redux";
import { HomeOutlined } from "@ant-design/icons";
import Link from "next/link";
import UserInfoBody from "@/app/component/user/UserInfo";
const UserDetail = () => {
  const searchParams = useSearchParams();
  const userId = searchParams.get("userId");
  const { userInfo } = useSelector((state) => state.user);
  const dispatch = useDispatch();
  useEffect(() => {
    dispatch(getUserInfoRequest(userId));
  }, [userId]);
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
      title: "Chi tiết người dùng",
    },
  ];
  return (
    <div className="py-3 px-8">
      <Suspense fallback={<Loading />}>
        <Breadcrumb items={breadcrumbList} />
        <span className="font-bold text-[30px] whitespace-nowrap">
          Thông tin chi tiết
        </span>
        <Divider />
        <div className="text-lg font-bold mb-4">Thông tin</div>
        <UserInfoBody userInfo={userInfo} taskData={userInfo.UserTasks} />
        <Divider />
        <div className="text-lg font-bold mb-4">Sự kiện đã tham gia</div>
        <UserEventTable eventData={userInfo.UserEvents} />
      </Suspense>
    </div>
  );
};

export default UserDetail;
