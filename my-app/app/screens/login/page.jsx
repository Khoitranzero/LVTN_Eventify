"use client";
import { Form, Input, Spin, message } from "antd";
import LogoImage from "../../assets/image/Logo.png";
import Image from "next/image";
import { userLoginActions } from "../../actions";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import { logout, storeUserDataRequest } from "../../store/reducer";
import { LoadingOutlined } from "@ant-design/icons";
import "./login_style.scss";
import Cookies from "js-cookie";
const Login = () => {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const dispatch = useDispatch();
  const { isAuthenticated } = useSelector((state) => state.user);
  const onFinish = async (values) => {
    setLoading(true);
    try {
      const res = await userLoginActions(values);
      if (res && res.EC === 0) {
        dispatch(storeUserDataRequest(res.DT));
      } else {
        message.error(
          "Tài khoản hoặc mật khẩu chưa đúng, vui lòng kiểm tra lại"
        );
      }
    } catch (error) {
      console.log(error);
    } finally {
      setLoading(false);
    }
  };
  useEffect(() => {
    const isRemember = Boolean(Cookies.get("firebaseToken"));
    if (typeof window !== "undefined" && !isRemember) {
      dispatch(logout());
    }
  }, []);
  if (isAuthenticated) {
    router.replace("/screens/home");
  }
  return (
    <>
      <div className="bg-white">
        <Spin
          indicator={
            <LoadingOutlined
              style={{
                fontSize: 48,
              }}
            />
          }
          spinning={loading}
          size="large"
          tip="Đang đăng nhập"
        >
          <div className="login-container w-full flex items-center justify-center h-screen bg-login-background bg-no-repeat bg-center">
            <div className="login-form">
              <div className="login-logo flex justify-center items-center flex-col">
                <Image src={LogoImage} width={100} height={100} alt="logo" />
                <div className="logo-title text-orange-bold-color text-lg font-bold">
                  Eventify Admin
                </div>
              </div>
              <Form name="login-form" onFinish={onFinish} autoComplete="off">
                <span className="px-3 font-semibold uppercase">
                  Tên đăng nhập
                </span>
                <Form.Item
                  name="username"
                  className="w-[500px]"
                  rules={[
                    {
                      required: true,
                      message: "Nhập tên đăng nhập của bạn",
                    },
                  ]}
                >
                  <Input
                    autoComplete="none"
                    placeholder="Tên đăng nhập"
                    className="!py-3 !mt-2 hover:!border-gray-300 focus:!border-gray-300 focus:!shadow-none"
                  />
                </Form.Item>
                <span className="px-3 font-semibold uppercase">Mật khẩu</span>
                <Form.Item
                  name="password"
                  rules={[
                    {
                      required: true,
                      message: "Nhập mật khẩu của bạn",
                    },
                  ]}
                >
                  <Input.Password
                    placeholder="Mật khẩu"
                    autoComplete="new-pasword"
                    className="!py-3 !mt-2 hover:!border-gray-300 focus:!border-gray-300 focus:!shadow-none !border-gray-300 !shadow-none"
                  />
                </Form.Item>
                <Form.Item>
                  <button
                    className="login-btn w-full py-3 bg-orange-bold-color hover:bg-orange-fade-color transition-all hover:text-orange-bold-color rounded-lg text-white font-semibold"
                    type="submit"
                  >
                    Đăng nhập
                  </button>
                </Form.Item>
              </Form>
            </div>
          </div>
        </Spin>
      </div>
    </>
  );
};
export default Login;
