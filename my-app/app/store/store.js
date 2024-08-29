const { configureStore, combineReducers } = require("@reduxjs/toolkit");
import createSagaMiddleware from "redux-saga";
import UserReducer from "./reducer";
import userSaga from "./saga";
const rootReducer = combineReducers({
  user: UserReducer,
});
const sagaMiddleware = createSagaMiddleware();
const store = configureStore({
  reducer: rootReducer,
  middleware: (getDefaultMiddleware) =>
    getDefaultMiddleware({ thunk: false }).concat(sagaMiddleware),
});
sagaMiddleware.run(userSaga);
export default store;