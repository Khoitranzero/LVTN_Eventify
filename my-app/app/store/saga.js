import { take } from "@redux-saga/core/effects";
import axios from "../actions/axiosConfig";
import {
  addBudgetCategoryFailed,
  addBudgetCategoryRequest,
  addBudgetCategorySuccess,
  addEventCategoryFailed,
  addEventCategoryRequest,
  addEventCategorySuccess,
  deleteBudgetCategoryRequest,
  deleteBudgetCategorySuccess,
  deleteEventCategoryFailed,
  deleteEventCategoryRequest,
  deleteEventCategorySuccess,
  getAllEventRequest,
  getAllEventSuccess,
  getBlockUserFailed,
  getBlockUserRequest,
  getBlockUserSuccess,
  getBudgetCategoryFailed,
  getBudgetCategoryRequest,
  getBudgetCategorySuccess,
  getEventCategoryFailed,
  getEventCategoryRequest,
  getEventCategorySuccess,
  getEventDetailFailed,
  getEventDetailRequest,
  getEventDetailSuccess,
  getEventInformationSuccess,
  getFilteredEventBackPreviousRequest,
  getFilteredEventBackPreviousSuccess,
  getFilteredEventByTimeRequest,
  getFilteredEventByTimeSuccess,
  getFilteredEventInFutureRequest,
  getFilteredEventInFutureSuccess,
  getFilteredUserByTimeRequest,
  getFilteredUserByTimeSuccess,
  getFinishedEventRequest,
  getFinishedEventSuccess,
  getMemberInEventSuccess,
  getTotalBudgetInEventSuccess,
  getUnBlockUserFailed,
  getUnBlockUserRequest,
  getUnBlockUserSuccess,
  getUserInfoRequest,
  getUserInfoSuccess,
  getUserListFailed,
  getUserListRequest,
  getUserListSuccess,
  logout,
  messageFailed,
  messageSuccess,
  messageWarning,
  setLoadingEvent,
  setLoadingUser,
  storeUserDataRequest,
  storeUserDataSuccess,
  updateBudgetCategoryRequest,
  updateBudgetCategorySuccess,
  updateEventCategoryFailed,
  updateEventCategoryRequest,
  updateEventCategorySuccess,
  updateEventInCalendarRequest,
  updateEventInCalendarSuccess,
  updateTaskDnDRequest,
  updateTaskDnDSuccess,
  updateUserPermissionRequest,
  updateUserPermissionSuccess,
} from "./reducer";
import {
  call,
  all,
  fork,
  put,
  takeLatest,
  takeLeading,
} from "redux-saga/effects";
import { userLogoutActions } from "../actions";
import { baseURL } from "../config/constant";
import Cookies from "js-cookie";
//Auth
function* handleLogout() {
  yield userLogoutActions();
  localStorage.removeItem("firebaseToken");
  Cookies.remove("firebaseToken");
  Cookies.remove("userInfo");
}
function* handleLogin(payload) {
  yield put(storeUserDataSuccess(payload));
  localStorage.setItem("firebaseToken", payload.token);
  Cookies.set("firebaseToken", payload.token, {
    expires: 365,
  });
  Cookies.set("userInfo", JSON.stringify(payload));
}
function* storeUserDataWatcher() {
  while (true) {
    const token = Boolean(Cookies.get("firebaseToken"));
    if (token) {
      const payload = JSON.parse(Cookies.get("userInfo"));
      yield call(handleLogin, payload);
    } else {
      const action = yield take(storeUserDataRequest);
      yield fork(handleLogin, action.payload);
    }
    yield take(logout);
    yield call(handleLogout);
  }
}
// function* storeUserDataWatcher() {
//   while (true) {
//     const isLoggedIn = Boolean(Cookies.get("firebaseToken"));
//     if (!isLoggedIn) {
//       const action = yield take(storeUserDataRequest);
//       yield fork(handleLogin, action.payload);
//     }
//     yield take(logout);
//     yield call(handleLogout);
//   }
// }
//Event
function* getAllEvent() {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/event/getAllEvent`
    );
    if (res && res.EC == 0) {
      yield put(getAllEventSuccess(res.DT));
    }
  } catch (error) {
    yield put(console.log("Error:", error));
  } finally {
    yield put(setLoadingEvent(false));
  }
}
function* getAllEventWatcher() {
  yield takeLeading(getAllEventRequest, getAllEvent);
}
function* getEventByTime(action) {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/filterEvent?time=${action.payload.time}&timeType=${action.payload.timeType}`
    );
    if (res) {
      yield put(getFilteredEventByTimeSuccess(res.DT));
    }
  } catch (error) {
    yield put(messageFailed(error.message));
  }
}
function* getEventByTimeWatcher() {
  yield takeLatest(getFilteredEventByTimeRequest, getEventByTime);
}
//update event
function* updateEventInCalendar(action) {
  try {
    const res = yield call(
      axios.put,
      `${baseURL}/api/v2/admin/event/update`,
      action.payload
    );
    if (res.EC == 0) {
      yield put(updateEventInCalendarSuccess(action.payload));
    }
  } catch (error) {
    console.log("Update event failed:", error);
  }
}
function* updateEventInCalendarWatcher() {
  yield takeLatest(updateEventInCalendarRequest, updateEventInCalendar);
}
//update task
function* updateTaskDnD(action) {
  try {
    const res = yield call(
      axios.put,
      `${baseURL}/api/v2/admin/task/update`,
      action.payload
    );
    if (res.EC == 0) {
      yield put(updateTaskDnDSuccess(action.payload));
    }
  } catch (error) {
    console.log("Update event failed:", error);
  }
}
function* updateTaskDnDWatcher() {
  yield takeLatest(updateTaskDnDRequest, updateTaskDnD);
}
//get finished event
function* getFinishedEvent() {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/event/finishedEvent`
    );
    if (res.EC == 0) {
      yield put(getFinishedEventSuccess(res.DT));
    }
  } catch (error) {}
}
function* getFinishedEventWatcher() {
  yield takeLatest(getFinishedEventRequest, getFinishedEvent);
}
//filter event in future
function* getEventInFuture(action) {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/event/filterInFuture?startAt=${action.payload.startAt}&endAt=${action.payload.endAt}&timeType=${action.payload.timeType}`
    );
    if (res && res.EC == 0) {
      yield put(getFilteredEventInFutureSuccess(res.DT));
    }
  } catch (error) {
    messageFailed(error.message);
  }
}
function* getEventInFutureWatcher() {
  yield takeLatest(getFilteredEventInFutureRequest, getEventInFuture);
}
//filter event back previous
function* getEventBackPrevious(action) {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/event/filterInFuture?startAt=${action.payload.startAt}&endAt=${action.payload.endAt}&timeType=${action.payload.timeType}`
    );
    if (res && res.EC == 0) {
      yield put(getFilteredEventBackPreviousSuccess(res.DT));
    }
  } catch (error) {
    messageFailed(error.message);
  }
}
function* getEventBackPreviousWatcher() {
  yield takeLatest(getFilteredEventBackPreviousRequest, getEventBackPrevious);
}
//Task
function* getListOfTaskByEventId(eventId) {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/task/getAllTaskInEvents?eventId=${eventId.payload}`
    );
    const resBudget = yield call(
      axios.get,
      `${baseURL}/api/v1/cost/getTotalCost?eventId=${eventId.payload}`
    );
    const resMemberInEvent = yield call(
      axios.get,
      `${baseURL}/api/v1/event/getMemberInEvents?eventId=${eventId.payload}`
    );
    const resEventInfo = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/event/detail?eventId=${eventId.payload}`
    );
    yield put(getEventDetailSuccess(res.DT));
    yield put(getTotalBudgetInEventSuccess(resBudget.DT));
    yield put(getMemberInEventSuccess(resMemberInEvent.DT));
    yield put(getEventInformationSuccess(resEventInfo.DT));
  } catch (error) {
    yield put(getEventDetailFailed(error));
  }
}
function* getListOfTaskByEventIdWatcher() {
  yield takeLatest(getEventDetailRequest, getListOfTaskByEventId);
}
//User
function* getListAllUser() {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/user/getAllUser`
    );
    yield put(getUserListSuccess(res.DT));
  } catch (error) {
    yield put(getUserListFailed(error));
  } finally {
    yield put(setLoadingUser(false));
  }
}
function* getListAllUserWatcher() {
  yield takeLatest(getUserListRequest, getListAllUser);
}
//Update user permission
function* updateUserPermission(action) {
  try {
    const res = yield call(
      axios.put,
      `${baseURL}/api/v2/admin/user/updatePermission?userId=${action.payload}`
    );
    if (res.EC == 0) {
      yield put(updateUserPermissionSuccess(action.payload));
    }
  } catch (error) {
    console.log("update user permission failed: ", error);
  } finally {
    yield put(setLoadingUser(false));
  }
}
function* updateUserPermissionWatcher() {
  yield takeLatest(updateUserPermissionRequest, updateUserPermission);
}
//Filter user by time
function* getUserByTime(action) {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/user/filterUser?time=${action.payload.time}&timeType=${action.payload.timeType}`
    );
    if (res) {
      yield put(getFilteredUserByTimeSuccess(res.DT));
    }
  } catch (error) {
    yield put(messageFailed(error.message));
  }
}
function* getUserByTimeWatcher() {
  yield takeLatest(getFilteredUserByTimeRequest, getUserByTime);
}
//Get user info
function* getUserInfo(action) {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/user/getUserInfo?userId=${action.payload}`
    );
    if (res && res.EC == 0) {
      yield put(getUserInfoSuccess(res.DT));
      yield put(messageSuccess(res.EM));
    }
  } catch (error) {
    yield put(messageFailed(error.message));
  }
}
function* getUserInfoWatcher() {
  yield takeLatest(getUserInfoRequest, getUserInfo);
}
//Block user
function* blockUser(action) {
  try {
    const res = yield call(
      axios.put,
      `${baseURL}/api/v2/admin/user/blockUser`,
      { email: action.payload }
    );
    if (res && res.EC == 0) {
      yield put(getBlockUserSuccess({ ...res, email: action.payload }));
    }
  } catch (error) {
    yield put(getBlockUserFailed(error.message));
  }
}
function* blockUserWatcher() {
  yield takeLatest(getBlockUserRequest, blockUser);
}
function* unBlockUser(action) {
  try {
    const res = yield call(
      axios.put,
      `${baseURL}/api/v2/admin/user/unBlockUser`,
      { email: action.payload }
    );
    if (res && res.EC == 0) {
      yield put(getUnBlockUserSuccess({ ...res, email: action.payload }));
    }
  } catch (error) {
    yield put(getUnBlockUserFailed(error.message));
  }
}
function* unBlockUserWatcher() {
  yield takeLatest(getUnBlockUserRequest, unBlockUser);
}
//Category
function* getEventCategory() {
  try {
    const res = yield call(axios.get, `${baseURL}/api/v2/admin/eventCategory`);
    if (res && res.EC == 0) {
      yield put(getEventCategorySuccess(res.DT));
    }
  } catch (error) {
    yield put(getEventCategoryFailed(error.message));
  }
}
function* getEventCategoryWatcher() {
  yield takeLatest(getEventCategoryRequest, getEventCategory);
}
function* createEventCategory(action) {
  try {
    console.log(action.payload);
    const res = yield call(
      axios.post,
      `${baseURL}/api/v2/admin/eventCategory`,
      {
        name: action.payload,
      }
    );
    if (res && res.EC == 0) {
      yield put(addEventCategorySuccess(res));
    } else if (res && res.EC == 1) {
      yield put(addEventCategoryFailed(res.EM));
    }
  } catch (error) {
    yield put(addEventCategoryFailed(error.message));
  }
}
function* createEventCategoryWatcher() {
  yield takeLatest(addEventCategoryRequest, createEventCategory);
}
function* deleteEventCategory(action) {
  try {
    const res = yield call(
      axios.delete,
      `${baseURL}/api/v2/admin/eventCategory`,
      {
        data: { categoryId: action.payload },
      }
    );
    if (res && res.EC == 0) {
      yield put(
        deleteEventCategorySuccess({ ...res, categoryId: action.payload })
      );
    }
  } catch (error) {
    yield put(deleteEventCategoryFailed(error.message));
  }
}
function* deleteEventCategoryWatcher() {
  yield takeLatest(deleteEventCategoryRequest, deleteEventCategory);
}
function* updateEventCategory(action) {
  try {
    const res = yield call(axios.put, `${baseURL}/api/v2/admin/eventCategory`, {
      categoryId: action.payload.categoryId,
      name: action.payload.name,
    });
    if (res && res.EC == 0) {
      yield put(
        updateEventCategorySuccess({ ...res, updatedData: action.payload })
      );
    }
  } catch (error) {
    yield put(updateEventCategoryFailed(error.message));
  }
}
function* updateEventCategoryWatcher() {
  yield takeLatest(updateEventCategoryRequest, updateEventCategory);
}
//Budget Category
//Get
function* getBudgetCategory() {
  try {
    const res = yield call(
      axios.get,
      `${baseURL}/api/v2/admin/cost/getAllCategory`
    );
    if (res && res.EC == 0) {
      yield put(getBudgetCategorySuccess(res.DT));
    }
  } catch (error) {
    yield put(getBudgetCategoryFailed(error.message));
  }
}
function* getBudgetCategoryWatcher() {
  yield takeLatest(getBudgetCategoryRequest, getBudgetCategory);
}
//Create
function* createBudgetCategory(action) {
  try {
    console.log(action.payload);
    const res = yield call(
      axios.post,
      `${baseURL}/api/v1/cost/createCategory`,
      {
        name: action.payload,
      }
    );
    if (res && res.EC == 0) {
      yield put(addBudgetCategorySuccess(res));
    } else if (res && res.EC == 1) {
      yield put(addBudgetCategoryFailed(res.EM));
    }
  } catch (error) {
    yield put(addBudgetCategoryFailed(error.message));
  }
}
function* createBudgetCategoryWatcher() {
  yield takeLatest(addBudgetCategoryRequest, createBudgetCategory);
}
//Delete
function* deleteBudgetCategory(action) {
  try {
    const res = yield call(axios.delete, `${baseURL}/api/v1/cost/category`, {
      data: { id: action.payload },
    });
    console.log(res);
    if (res && res.EC == 0) {
      if (
        res.EM !== "Không thể xóa danh mục này vì danh mục đang được sử dụng !!"
      ) {
        yield put(deleteBudgetCategorySuccess({ ...res, id: action.payload }));
        yield put(messageSuccess(res.EM));
      } else {
        yield put(messageWarning(res.EM));
      }
    } else if (res && res.EC == 1) {
      yield put(messageFailed(res.EM));
    }
  } catch (error) {
    yield put(messageFailed(error.message));
  }
}
function* deleteBudgetCategoryWatcher() {
  yield takeLatest(deleteBudgetCategoryRequest, deleteBudgetCategory);
}
//Update
function* updateBudgetCategory(action) {
  try {
    const res = yield call(axios.put, `${baseURL}/api/v1/cost/category`, {
      id: action.payload.id,
      name: action.payload.name,
    });
    if (res && res.EC == 0) {
      yield put(updateBudgetCategorySuccess(action.payload));
      yield put(messageSuccess(res.EM));
    } else {
      yield put(messageFailed(res.EM));
    }
  } catch (error) {
    yield put(messageFailed(error.message));
  }
}
function* updateBudgetCategoryWatcher() {
  yield takeLatest(updateBudgetCategoryRequest, updateBudgetCategory);
}
export default function* userSaga() {
  yield all([
    //auth
    fork(storeUserDataWatcher),
    //List event
    fork(getAllEventWatcher),
    //finished event
    fork(getFinishedEventWatcher),
    //Filter event
    fork(getEventByTimeWatcher),
    //Filter event in future
    fork(getEventInFutureWatcher),
    //Filter event back previous
    fork(getEventBackPreviousWatcher),
    //Filter user
    fork(getUserByTimeWatcher),
    //Task in event
    fork(getListOfTaskByEventIdWatcher),
    //List User
    fork(getListAllUserWatcher),
    //event category
    fork(getEventCategoryWatcher),
    fork(createEventCategoryWatcher),
    fork(deleteEventCategoryWatcher),
    fork(updateEventCategoryWatcher),
    //block user
    fork(blockUserWatcher),
    fork(unBlockUserWatcher),
    //budget category
    fork(getBudgetCategoryWatcher),
    fork(createBudgetCategoryWatcher),
    fork(deleteBudgetCategoryWatcher),
    fork(updateBudgetCategoryWatcher),
    //get user info
    fork(getUserInfoWatcher),
    //update user permission
    fork(updateUserPermissionWatcher),
    //update event in calendar
    fork(updateEventInCalendarWatcher),
    //update task DnD
    fork(updateTaskDnDWatcher),
  ]);
}
