import { message, Spin } from "antd";
import { useRouter } from "next/navigation";
import { LoadingOutlined } from "@ant-design/icons";
import { useDispatch, useSelector } from "react-redux";
import { logout, setHideSidebar, setLoadingLogout } from "../store/reducer";
import LogoImage from "../assets/image/Logo.png";
import Image from "next/image";
import {
  HomeOutlined,
  FormOutlined,
  LogoutOutlined,
  CalendarOutlined,
  ReconciliationOutlined,
  TeamOutlined,
  DollarOutlined,
} from "@ant-design/icons";
import "../assets/css/_header.scss";
import Link from "next/link";
import { useEffect, useState } from "react";
const SideBar = () => {
  //selector
  const { isHideSidebar, loadingLogout } = useSelector((state) => state.user);
  //dispatch
  const dispatch = useDispatch();
  //router
  const router = useRouter();
  //custom function
  const handleLogout = () => {
    dispatch(setLoadingLogout(true));
    setTimeout(() => {
      dispatch(logout());
      router.replace("/screens/home");
      message.success("Đăng xuất thành công");
      dispatch(setLoadingLogout(false));
    }, 1000);
  };
  //local state
  const [activeTab, setActiveTab] = useState(() => {
    return localStorage.getItem("activeTab") || "";
  });
  const [width, setWidth] = useState(window.innerWidth);
  const [height, setHeight] = useState(window.innerHeight);
  const items = [
    {
      label: !isHideSidebar ? "Dashboard" : "",
      key: "home",
      icon: <HomeOutlined />,
      href: "/screens/home",
    },
    {
      label: !isHideSidebar ? "Sự kiện" : "",
      key: "statistical",
      icon: <ReconciliationOutlined />,
      href: "/screens/home/event",
    },
    {
      label: !isHideSidebar ? "Người dùng" : "",
      key: "statistical",
      icon: <TeamOutlined />,
      href: "/screens/home/user",
    },
    {
      label: !isHideSidebar ? "Lịch sự kiện" : "",
      key: "statistical",
      icon: <CalendarOutlined />,
      href: "/screens/home/calendar",
    },
    {
      label: !isHideSidebar ? "Danh mục sự kiện" : "",
      key: "statistical",
      icon: <FormOutlined />,
      href: "/screens/home/data_analysis",
    },
    {
      label: !isHideSidebar ? "Danh mục chi phí" : "",
      key: "statistical",
      icon: <DollarOutlined />,
      href: "/screens/home/cost_category",
    },
  ];
  const updateScreen = () => {
    setWidth(window.innerWidth);
    setHeight(window.innerHeight);
  };
  //useEffect'
  useEffect(() => {
    localStorage.setItem("activeTab", activeTab);
  }, [activeTab]);
  useEffect(() => {
    window.addEventListener("resize", updateScreen);
    return () => window.removeEventListener("resize", updateScreen);
  }, []);
  useEffect(() => {
    if (width > 750) {
      dispatch(setHideSidebar(false));
    } else {
      dispatch(setHideSidebar(true));
    }
  }, [width, dispatch]);
  return (
    <>
      <Spin
        indicator={
          <LoadingOutlined
            style={{
              fontSize: 48,
            }}
          />
        }
        spinning={loadingLogout}
        fullscreen
        tip="Đang đăng xuất"
      />
      <div
        className={`navbar-container flex flex-col bg-[#182230] items-center justify-between p-5 gap-2 h-screen transition-all duration-300 ease-linear  ${
          isHideSidebar ? "w-[80px]" : ""
        }`}
      >
        <div className="flex flex-col items-center gap-3">
          <div className="navbar-logo flex items-center gap-4">
            <Image src={LogoImage} width={50} height={50} alt="logo" />
            {!isHideSidebar ? (
              <span className="font-bold text-[30px] text-white">Eventify</span>
            ) : null}
          </div>
          <div className="divider border-white border-[1px] w-full"></div>
          <div className="navbar-body flex flex-col gap-2">
            {items?.map((item, index) => {
              const isActive = index === parseInt(activeTab, 10);
              return (
                <>
                  <Link
                    href={item.href}
                    className={`navbar-item cursor-pointer text-[#98A2B3] whitespace-nowrap transition-all hover:bg-[#F38744] hover:text-white text-start  ${
                      isHideSidebar ? "!w-[57px]" : "w-[230px]"
                    } ${isActive ? "!bg-orange-bold-color text-orange-fade-color" : ""}`}
                    onClick={() => setActiveTab(index.toString())}
                  >
                    {item.icon} {item.label}
                  </Link>
                </>
              );
            })}
          </div>
        </div>
        <div
          className={`navbar-logout-button cursor-pointer duration-300 ease-linear text-[#98A2B3] text-center hover:bg-[#F38744] transition-all hover:text-white ${
            isHideSidebar ? "!w-[57px]" : "w-[230px]"
          }`}
          onClick={handleLogout}
        >
          {isHideSidebar ? (
            <LogoutOutlined />
          ) : (
            <>
              <LogoutOutlined /> Đăng xuất
            </>
          )}
        </div>
      </div>
    </>
  );
};
export default SideBar;
