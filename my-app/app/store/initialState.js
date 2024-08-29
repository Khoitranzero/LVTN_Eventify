import Cookies from "js-cookie";

const initialState = {
  isAuthenticated: Boolean(Cookies.get("userInfo")),
  account: {},
  status: "idle",
  error: "",
  //Event
  allEvent: [],
  listTaskEvent: [],
  memberInEvent: [],
  filteredEventByTime: [],
  filteredEventInFuture: [],
  filteredEventBackPrevious: [],
  eventInfo: {},
  finishedEvent: [],
  //Event category
  eventCategory: [],
  notifyMessageCreate: "",
  notifyMessageDelete: "",
  budgetCategory: [],
  budgetPricing: {},
  //User
  listAllUser: [],
  userInfo: {},
  filteredUserByTime: [],
  //UI
  isHideSidebar: false,
  loadingEvent: false,
  loadingUser: false,
  loadingLogin: false,
  loadingLogout: false,
};
export { initialState };
