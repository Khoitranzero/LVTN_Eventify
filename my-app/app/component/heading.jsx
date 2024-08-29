import { useDispatch, useSelector } from "react-redux";
import * as svg from "../assets/svg/index";
import { setHideSidebar } from "../store/reducer";
const Heading = () => {
  const { account, isHideSidebar } = useSelector((state) => state.user);
  const dispatch = useDispatch();
  //custom function
  const handleToggleButton = () => {
    dispatch(setHideSidebar(!isHideSidebar));
  };
  return (
    <>
      <div className="heading flex justify-between px-3 py-3 shadow-md sticky top-0 bg-white z-[999]">
        <button className="left w-4" onClick={() => handleToggleButton()}>
          {svg.toggleBar}
        </button>
        <div className="right">
          {account.fullName ? `Xin chào ${account.fullName}` : ""}
        </div>
      </div>
    </>
  );
};
export default Heading;
