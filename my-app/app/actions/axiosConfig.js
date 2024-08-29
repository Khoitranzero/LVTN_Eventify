// import axios from "axios";
// import { toast } from "react-toastify";

// // Set config defaults when creating the instance
// const instance = axios.create({
//     baseURL: 'http://localhost:8080'
//   });
//   instance.defaults.withCredentials=true;
//   // Alter defaults after instance has been created
//   // instance.defaults.headers.common['Authorization'] = `Bearer ${localStorage.getItem("firebaseToken")}`;
//   instance.interceptors.request.use(
//     (config) => {
//         // Get the token from localStorage
//         const token = localStorage.getItem("firebaseToken");
//         if (token) {
//             config.headers['Authorization'] = `Bearer ${token}`;
//         }
//         return config;
//     },
//     (error) => {
//         // Do something with request error
//         return Promise.reject(error);
//     }
// );
// // Add a request interceptor
// instance.interceptors.request.use(function (config) {
//     // Do something before request is sent
//     return config;
//   }, function (error) {
//     // Do something with request error
//     return Promise.reject(error);
//   });

// // Add a response interceptor
// instance.interceptors.response.use(function (response) {
//     // Any status code that lie within the range of 2xx cause this function to trigger
//     // Do something with response data
//     return response.data;
//   }, function (error) {
//     // Any status codes that falls outside the range of 2xx cause this function to trigger
//     // Do something with response error
//     const status = error&& error.response && error.response.status || 500;
//     switch(status) {
//       case 401 :
//         {toast.error('Unauthorized  the user . Please login ');
//         //window.location.href = '/login';
//         //return Promise.reject(error);
//         return error.response.data;
//     }
//         case 403 :
//         {toast.error('You don permisstion to acccess this resource ');
//         //window.location.href = '/login';
//         return Promise.reject(error);
//         //return error.response.data;
//   }
//         case 400 :

//         //window.location.href = '/login';
//       {  return Promise.reject(error);}

//         case 404 :

//         //window.location.href = '/login';
//        { return Promise.reject(error);}
//         case 409 :

//         //window.location.href = '/login';
//         {return Promise.reject(error);}
//         case 422 :

//         //window.location.href = '/login';
//        { return Promise.reject(error);}
//        default:
//         {return Promise.reject(error);}
//     }
//   });

//   export default instance;
import { message } from "antd";
import axios from "axios";

// Create an instance of axios
const instance = axios.create({
  baseURL: "http://localhost:8080",
  withCredentials: true,
});

// Add a request interceptor
instance.interceptors.request.use(
  (config) => {
    // Get the token from localStorage
    const token = localStorage.getItem("firebaseToken");
    if (token) {
      config.headers["Authorization"] = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    // Do something with request error
    return Promise.reject(error);
  }
);

// Add a response interceptor
instance.interceptors.response.use(
  (response) => {
    // Any status code that lies within the range of 2xx causes this function to trigger
    // Do something with response data
    return response.data;
  },
  (error) => {
    // Any status codes that fall outside the range of 2xx cause this function to trigger
    // Do something with response error
    const status = (error && error.response && error.response.status) || 500;
    switch (status) {
      case 401:
        message.error("Bạn chưa đăng nhập, vui lòng đăng nhập lại!!!");
        // Optionally redirect to login page
        // window.location.href = '/login';
        return error.response.data;
      case 403:
        message.error("Bạn không có quyền để truy cập tài nguyên này");
        return Promise.reject(error);
      case 400:
      case 404:
      case 409:
      case 422:
        return Promise.reject(error);
      default:
        return Promise.reject(error);
    }
  }
);

export default instance;
