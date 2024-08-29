import axios from "axios";
// import { toast } from "react-toastify";

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
        // toast.error("Unauthorized user. Please login.");
        // Optionally redirect to login page
        // window.location.href = '/login';
        return error.response.data;
      case 403:
        // toast.error("You do not have permission to access this resource.");
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
