"use client";
import { useEffect, useState } from "react";
import { Provider, useSelector } from "react-redux";
import store from "../../store/store";
import SideBar from "@/app/component/sideBar";
import Heading from "@/app/component/heading";
import { ConfigProvider } from "antd";
import viVN from "antd/lib/locale/vi_VN";
import dayjs from "dayjs";
import "dayjs/locale/vi";
import { Skeleton } from "antd";
dayjs.locale('vi');
const AuthenticatedLayout = ({ children }) => {
  const [isMounted, setIsMounted] = useState(false);
  const isAuthenticated = useSelector((state) => state.user.isAuthenticated);

  useEffect(() => {
    setIsMounted(true);
  }, []);

  if (!isMounted) {
    return <Skeleton active />;
  }
  return (
    <>
      {isAuthenticated ? (
        <div className="flex h-screen">
          <div className="bg-gray-800 text-white">
            <SideBar />
          </div>
          <div className="flex-1 overflow-auto w-screen">
            <Heading />
            {children}
          </div>
        </div>
      ) : (
        children
      )}
    </>
  );
};

const Layout = ({ children }) => {
  return (
    <Provider store={store}>
      <ConfigProvider locale={viVN}>
        <AuthenticatedLayout>{children}</AuthenticatedLayout>
      </ConfigProvider>
    </Provider>
  );
};

export default Layout;
