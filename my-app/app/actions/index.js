// import axios from "../config/axios";
import axios from "./axiosConfig";
import { baseURL } from "../config/constant";
import { message } from "antd";
//auth
export const userLoginActions = async (data) => {
  const valueLogin = data.username;
  const password = data.password;
  const res = await axios.post(`${baseURL}/api/v2/admin/login`, {
    valueLogin,
    password,
  });
  return res;
};
export const userLogoutActions = async () => {
  const res = await axios.post(`${baseURL}/api/v2/admin/logout`);
  return res;
};
//Event
export const getAllEvent = async () => {
  const res = await axios.get(`${baseURL}/api/v2/admin/event/getAllEvent`);
  if (res && res.EC == 0) {
    message.success(res.EM);
  } else {
    message.error(res.EM);
  }
  return res;
};
