import { message } from "antd";

const { createSlice } = require("@reduxjs/toolkit");
const { initialState } = require("./initialState");

const UserReducer = createSlice({
  name: "user",
  initialState: initialState,
  reducers: {
    //auth
    storeUserDataRequest: (state, action) => {
      state.status = "loading";
    },
    storeUserDataSuccess: (state, action) => {
      state.status = "success";
      state.account = action.payload;
      state.isAuthenticated = true;
    },
    storeUserDataFailed: (state, action) => {
      state.status = "failure";
      state.error = action.payload;
    },
    logout: (state) => {
      state.isAuthenticated = false;
      state.account = undefined;
    },
    //Event
    getAllEventRequest: (state, action) => {
      state.status = "loading";
    },
    getAllEventSuccess: (state, action) => {
      state.allEvent = action.payload;
      state.status = "success";
    },
    getAllEventFailed: (state, action) => {
      state.error = action.payload;
    },
    //get finished event
    getFinishedEventRequest: (state, action) => {},
    getFinishedEventSuccess: (state, action) => {
      state.finishedEvent = action.payload;
    },
    //filter event by createdAt
    getFilteredEventByTimeRequest: (state, action) => {},
    getFilteredEventByTimeSuccess: (state, action) => {
      state.filteredEventByTime = action.payload;
    },
    //filter event in future
    getFilteredEventInFutureRequest: (state, action) => {},
    getFilteredEventInFutureSuccess: (state, action) => {
      state.filteredEventInFuture = action.payload;
    },
    //filter event back previous
    getFilteredEventBackPreviousRequest: (state, action) => {},
    getFilteredEventBackPreviousSuccess: (state, action) => {
      state.filteredEventBackPrevious = action.payload;
    },
    //Event Detail
    getEventInformationSuccess: (state, action) => {
      state.eventInfo = action.payload;
    },
    getEventDetailRequest: (state, action) => {},
    getEventDetailSuccess: (state, action) => {
      state.listTaskEvent = action.payload;
    },
    getEventDetailFailed: (state, action) => {
      state.error = action.payload;
    },
    getMemberInEventSuccess: (state, action) => {
      state.memberInEvent = action.payload;
    },
    //User
    getUserListRequest: (state) => {},
    getUserListSuccess: (state, action) => {
      state.listAllUser = action.payload;
    },
    getUserListFailed: (state, action) => {
      state.error = action.payload;
    },
    getBlockUserRequest: (state, action) => {},
    getBlockUserSuccess: (state, action) => {
      const userEmailToBlock = action.payload.email;
      const index = state.listAllUser.findIndex(
        (item) => item.email === userEmailToBlock
      );

      if (index !== -1) {
        state.listAllUser[index].activated = false;
        message.success(action.payload.EM);
      }
    },
    getBlockUserFailed: (state, action) => {
      message.error(action.payload);
    },
    getUnBlockUserRequest: (state, action) => {},
    getUnBlockUserSuccess: (state, action) => {
      const userEmailToBlock = action.payload.email;
      const index = state.listAllUser.findIndex(
        (item) => item.email === userEmailToBlock
      );

      if (index !== -1) {
        state.listAllUser[index].activated = true;
        message.success(action.payload.EM);
      }
    },
    getUnBlockUserFailed: (state, action) => {
      message.error(action.payload);
    },
    //get user info
    getUserInfoRequest: (state, action) => {},
    getUserInfoSuccess: (state, action) => {
      state.userInfo = action.payload;
    },
    //Filter user by time
    getFilteredUserByTimeRequest: (state, action) => {},
    getFilteredUserByTimeSuccess: (state, action) => {
      state.filteredUserByTime = action.payload;
    },
    //Update user permission
    updateUserPermissionRequest: (state, action) => {},
    updateUserPermissionSuccess: (state, action) => {
      const index = state.listAllUser.findIndex(
        (user) => user.id === action.payload
      );
      if (index !== -1) {
        state.listAllUser[index] = {
          ...state.listAllUser[index],
          role: state.listAllUser[index].role == "Admin" ? "" : "Admin",
        };
      }
    },
    //Event category
    //GET
    getEventCategoryRequest: (state, action) => {},
    getEventCategorySuccess: (state, action) => {
      state.eventCategory = action.payload;
    },
    getEventCategoryFailed: (state, action) => {
      console.log(action.payload);
    },
    //Create
    addEventCategoryRequest: (state, action) => {},
    addEventCategorySuccess: (state, action) => {
      state.eventCategory.push({
        ...action.payload.DT,
        eventCount: 0,
      });
      state.notifyMessageCreate = action.payload.EM;
      message.success(action.payload.EM);
    },
    addEventCategoryFailed: (state, action) => {
      message.error(action.payload);
    },
    //Delete
    deleteEventCategoryRequest: (state, action) => {},
    deleteEventCategorySuccess: (state, action) => {
      const categoryIdToDelete = action.payload.categoryId;
      const indexToDelete = state.eventCategory.findIndex(
        (category) => category.id === categoryIdToDelete
      );
      if (indexToDelete !== -1) {
        state.eventCategory.splice(indexToDelete, 1);
      }
      state.notifyMessageDelete = action.payload.EM;
      message.success(action.payload.EM);
    },
    deleteEventCategoryFailed: (state, action) => {
      console.log(action.payload);
    },
    //Update
    updateEventCategoryRequest: (state, action) => {},
    updateEventCategorySuccess: (state, action) => {
      const categoryIdToUpdate = action.payload.updatedData.categoryId;
      const indexToUpdate = state.eventCategory.findIndex(
        (category) => category.id === categoryIdToUpdate
      );
      if (indexToUpdate !== -1) {
        state.eventCategory.splice(indexToUpdate, 1, {
          id: categoryIdToUpdate,
          name: action.payload.updatedData.name,
          eventCount: action.payload.updatedData.eventCount,
        });
        message.success(action.payload.EM);
      }
    },
    updateEventCategoryFailed: (state, action) => {
      console.log(action.payload);
    },
    //Budget category
    //Get
    getBudgetCategoryRequest: (state, action) => {},
    getBudgetCategorySuccess: (state, action) => {
      state.budgetCategory = action.payload;
    },
    getBudgetCategoryFailed: (state, action) => {
      console.log(action.payload);
    },
    //Create
    addBudgetCategoryRequest: (state, action) => {},
    addBudgetCategorySuccess: (state, action) => {
      state.budgetCategory.push(action.payload.DT);
      state.notifyMessageCreate = action.payload.EM;
      message.success(action.payload.EM);
    },
    addBudgetCategoryFailed: (state, action) => {
      message.error(action.payload);
    },
    //Delete
    deleteBudgetCategoryRequest: (state, action) => {},
    deleteBudgetCategorySuccess: (state, action) => {
      const indexToDelete = state.budgetCategory.findIndex(
        (category) => category.id === action.payload.id
      );
      if (indexToDelete !== -1) {
        state.budgetCategory.splice(indexToDelete, 1);
      }
    },
    //Update
    updateBudgetCategoryRequest: (state, action) => {},
    updateBudgetCategorySuccess: (state, action) => {
      const budgetIdToUpdate = action.payload.id;
      const indexToUpdate = state.budgetCategory.findIndex(
        (category) => category.id == budgetIdToUpdate
      );
      if (indexToUpdate !== -1) {
        state.budgetCategory.splice(indexToUpdate, 1, action.payload);
      }
    },
    //Event budget
    getTotalBudgetInEventSuccess: (state, action) => {
      state.budgetPricing = action.payload;
    },
    //update event
    updateEventInCalendarRequest: (state, action) => {},
    updateEventInCalendarSuccess: (state, action) => {
      const { eventId, startAt, endAt } = action.payload;
      const indexToUpdate = state.allEvent.findIndex(
        (event) => event.id === eventId
      );
      if (indexToUpdate !== -1) {
        state.allEvent[indexToUpdate] = {
          ...state.allEvent[indexToUpdate],
          startAt,
          endAt,
        };
      }
    },
    //update task
    updateTaskDnDRequest: (state, action) => {},
    updateTaskDnDSuccess: (state, action) => {
      const { id, startAt, endAt } = action.payload;
      const indexToUpdate = state.listTaskEvent.findIndex(
        (task) => task.id === id
      );

      if (indexToUpdate !== -1) {
        // Tạo một bản sao của task hiện tại
        const updatedTask = { ...state.listTaskEvent[indexToUpdate] };

        // Chỉ cập nhật startAt nếu nó tồn tại trong payload
        if (startAt) {
          updatedTask.startAt = startAt;
        }

        // Chỉ cập nhật endAt nếu nó tồn tại trong payload
        if (endAt) {
          updatedTask.endAt = endAt;
        }

        // Cập nhật task trong state
        state.listTaskEvent[indexToUpdate] = updatedTask;
      }
    },
    //UI
    setHideSidebar: (state, action) => {
      state.isHideSidebar = action.payload;
    },
    setLoadingEvent: (state, action) => {
      state.loadingEvent = action.payload;
    },
    setLoadingUser: (state, action) => {
      state.loadingUser = action.payload;
    },
    setLoadingLogout: (state, action) => {
      state.loadingLogout = action.payload;
    },
    setLoadingLogin: (state, action) => {
      state.loadingLogin = action.payload;
    },
    messageSuccess: (state, action) => {
      message.success(action.payload);
    },
    messageFailed: (state, action) => {
      message.error(action.payload);
    },
    messageWarning: (state, action) => {
      message.warning(action.payload);
    },
  },
});
export const {
  //auth
  storeUserDataRequest,
  storeUserDataSuccess,
  storeUserDataFailed,
  logout,
  //event
  getAllEventFailed,
  getAllEventRequest,
  getAllEventSuccess,
  getMemberInEventSuccess,
  getEventInformationSuccess,
  getFinishedEventRequest,
  getFinishedEventSuccess,
  //update event
  updateEventInCalendarRequest,
  updateEventInCalendarSuccess,
  //update task drag and drop
  updateTaskDnDRequest,
  updateTaskDnDSuccess,
  //filter event
  getFilteredEventByTimeRequest,
  getFilteredEventByTimeSuccess,
  //filter event in future
  getFilteredEventInFutureRequest,
  getFilteredEventInFutureSuccess,
  //filter event back previous
  getFilteredEventBackPreviousRequest,
  getFilteredEventBackPreviousSuccess,
  //filter user
  getFilteredUserByTimeRequest,
  getFilteredUserByTimeSuccess,
  //task
  getEventDetailRequest,
  getEventDetailSuccess,
  getEventDetailFailed,
  //user
  getUserListRequest,
  getUserListSuccess,
  getUserListFailed,
  getBlockUserRequest,
  getBlockUserSuccess,
  getBlockUserFailed,
  getUnBlockUserRequest,
  getUnBlockUserSuccess,
  getUnBlockUserFailed,
  //Update user permission
  updateUserPermissionRequest,
  updateUserPermissionSuccess,
  //Get user info
  getUserInfoRequest,
  getUserInfoSuccess,
  //Category
  getEventCategoryRequest,
  getEventCategorySuccess,
  getEventCategoryFailed,
  addEventCategoryRequest,
  addEventCategorySuccess,
  addEventCategoryFailed,
  deleteEventCategoryRequest,
  deleteEventCategorySuccess,
  deleteEventCategoryFailed,
  updateEventCategoryRequest,
  updateEventCategorySuccess,
  updateEventCategoryFailed,
  //Budget category
  getBudgetCategoryRequest,
  getBudgetCategorySuccess,
  getBudgetCategoryFailed,
  getTotalBudgetInEventSuccess,
  //create
  addBudgetCategoryRequest,
  addBudgetCategorySuccess,
  addBudgetCategoryFailed,
  //Delete
  deleteBudgetCategoryRequest,
  deleteBudgetCategorySuccess,
  //Update
  updateBudgetCategoryRequest,
  updateBudgetCategorySuccess,
  //UI
  setHideSidebar,
  setLoadingEvent,
  setLoadingUser,
  messageSuccess,
  messageFailed,
  messageWarning,
  setLoadingLogin,
  setLoadingLogout,
} = UserReducer.actions;
export default UserReducer.reducer;
