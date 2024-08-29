import { Divider, Select, Spin } from "antd";
import {
  ReloadOutlined,
  LoadingOutlined,
  IdcardOutlined,
  ProductOutlined,
  MailOutlined,
} from "@ant-design/icons";
import { useEffect, useState } from "react";
import { useDispatch, useSelector } from "react-redux";
import {
  getAllEventRequest,
  getEventCategoryRequest,
  getFilteredEventInFutureRequest,
  setLoadingEvent,
} from "../../store/reducer";
import "../../assets/css/_ant_custom.scss";
import { useRouter } from "next/navigation";
import { useDebounce } from "use-debounce";
import { formatDateTime, slugify } from "../../helper";
import NoData from "../UI/NoData";
import Image from "next/image";
import moment from "moment";
import FutureEventWithTime from "../data-analysis/futureEventWithTime";
const EventTable = (props) => {
  const { eventData } = props;
  const { loadingEvent } = useSelector((state) => state.user);
  const { eventCategory, filteredEventInFuture } = useSelector(
    (state) => state.user
  );
  const dispatch = useDispatch();
  const router = useRouter();
  //local state
  const [searchType, setSearchType] = useState("");
  const [search, setSearch] = useState("");
  const [debounce] = useDebounce(search, 500);
  const [filteredData, setFilteredData] = useState(eventData);
  const [futureDate, setFutureDate] = useState(moment());
  const [futureDateType, setFutureDateType] = useState("");
  const showEventInfo = (eventId, eventName) => {
    const slugEventName = slugify(eventName);
    router.push(
      `/screens/home/event_detail?eventId=${eventId}&name=${slugEventName}`
    );
  };
  const handleSearch = (event) => {
    const value = event.target.value;
    setSearch(value);
  };
  //custom function
  const convertFutureTime = (futureDate, dateType) => {
    let data;
    switch (dateType) {
      case "month":
        data = {
          startAt: formatDateTime(futureDate.startAt),
          endAt: formatDateTime(futureDate.endAt),
          timeType: "month",
        };
        dispatch(getFilteredEventInFutureRequest(data));
        break;
      case "year":
        data = {
          startAt: formatDateTime(futureDate.startAt),
          endAt: formatDateTime(futureDate.endAt),
          timeType: "year",
        };
        dispatch(getFilteredEventInFutureRequest(data));
        break;
      default:
        data = {
          startAt:
            formatDateTime(futureDate?.startAt) ||
            moment(futureDate?.startAt?.$d).format("YYYY-MM-DD"),
          endAt:
            formatDateTime(futureDate?.endAt) ||
            moment(futureDate?.endAt?.$d).format("YYYY-MM-DD"),
          timeType: "date",
        };
        dispatch(getFilteredEventInFutureRequest(data));
    }
  };
  //useEffect
  useEffect(() => {
    if (debounce) {
      const lowercasedFilter = debounce.toLowerCase();
      const filtered = eventData.filter((event) =>
        event.name.toLowerCase().includes(lowercasedFilter)
      );
      setFilteredData(filtered);
    } else {
      setFilteredData(eventData);
    }
  }, [debounce, eventData]);
  useEffect(() => {
    if (eventCategory.length == []) {
      dispatch(getEventCategoryRequest());
    }
  }, []);
  useEffect(() => {
    convertFutureTime(futureDate, futureDateType);
  }, [futureDate]);
  //select antd option
  const options = [
    { value: "", label: "Tất cả" },
    ...eventCategory.map((item) => ({
      value: item.id,
      label: item.name,
    })),
  ];
  const typeOptions = [
    {
      value: "search",
      label: "Tên",
    },
    {
      value: "category",
      label: "Danh mục",
    },
  ];
  //custom function
  const handleChangeCategory = (value) => {
    if (value === "") {
      setFilteredData(eventData);
    } else {
      const filtered = eventData.filter((event) =>
        event.categoryId.toLowerCase().includes(value.toLowerCase())
      );
      setFilteredData(filtered);
    }
  };
  const handleSearchType = (value) => {
    setSearchType(value);
  };
  const reloadEventTable = () => {
    dispatch(setLoadingEvent(true));
    setTimeout(() => {
      dispatch(getAllEventRequest());
    }, 1000);
  };
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
        spinning={loadingEvent}
        fullscreen
        tip="Đang tải dữ liệu"
      />
      <div className="border-[1px] border-[#D0D5DD] p-3 rounded-lg mt-2">
        <div className="flex justify-between items-center flex-col md:flex-row px-2 gap-2">
          <span className="font-bold text-[25px] whitespace-nowrap">
            Tất cả sự kiện
          </span>
          <div className="btns flex flex-col items-center md:flex-row gap-2">
            {searchType === "" ? (
              <></>
            ) : searchType === "category" ? (
              <Select
                defaultValue="Tất cả"
                placeholder="Lọc theo danh mục sự kiện"
                className="w-[300px] !h-[40px] !mr-[10px]"
                onChange={handleChangeCategory}
                options={options}
              />
            ) : (
              <input
                type="text"
                className="border-[1px] py-[7px] outline-0 rounded-lg px-2 border-primary transition-all duration-300 delay-100 "
                placeholder="Tìm kiếm sự kiện"
                value={search}
                onChange={handleSearch}
              />
            )}
            <div className="toolbar-btn">
              <Select
                defaultValue="Tìm kiếm theo"
                className="!mr-[10px] !h-[40px] w-[200px]"
                onChange={handleSearchType}
                options={typeOptions}
              />
              <button
                className="zbg-primary px-3 h-[40px] py-[7px] bg-orange-bold-color text-white font-bold text-[15px] rounded-lg hover:bg-orange-fade-color hover:border-[1px] hover:border-orange-bold-color transition-all duration-300 delay-100 hover:text-orange-bold-color"
                onClick={reloadEventTable}
              >
                <ReloadOutlined />
              </button>
            </div>
          </div>
        </div>
        <div className="my-2 flex flex-wrap gap-2 h-[610px] overflow-y-auto">
          {filteredData.length != 0 ? (
            filteredData?.map((item, index) => {
              return (
                <div
                  onClick={() => showEventInfo(item.id, item.name)}
                  className="event-item cursor-pointer p-2 rounded-lg w-full md:w-[49%] border-[1px] border-[#98A2B3] flex items-center gap-3 hover:shadow-lg  hover:bg-orange-fade-color hover:border-[1px] hover:border-orange-bold-color transition-all bg-white"
                  key={index}
                >
                  <Image
                    src={item.UserEvents[0]?.User?.avatarUrl}
                    alt={item.name}
                    width={50}
                    height={50}
                    className="rounded-full object-cover"
                  />
                  <div className="">
                    <span className="title text-xl text-black font-semibold">
                      {item?.name}
                    </span>
                    <div className="sub-title text-[14px] text-gray-600">
                      {item.description}
                    </div>
                    <div className="category-type">
                      {" "}
                      <ProductOutlined /> {item?.EventCategory?.name}
                    </div>
                    <div className="leader">
                      <IdcardOutlined /> {item?.UserEvents[0]?.User?.name}{" "}
                      <br />
                      <MailOutlined /> {item?.UserEvents[0]?.User?.email}
                    </div>
                  </div>
                </div>
              );
            })
          ) : (
            <NoData />
          )}
          <Divider />
        </div>
        <div className="flex justify-between items-center flex-col md:flex-row px-2 gap-2">
          <FutureEventWithTime
            futureDate={futureDate}
            setFutureDate={setFutureDate}
            setFutureDateType={setFutureDateType}
          />
        </div>
        <div className="filter-event-by-time flex flex-wrap gap-2 mt-2 min-h-[300px] overflow-y-auto">
          {filteredEventInFuture.length != 0 ? (
            filteredEventInFuture?.map((item, index) => {
              return (
                <div
                  onClick={() => showEventInfo(item.id, item.name)}
                  className="event-item cursor-pointer p-2 rounded-lg w-full md:w-[49%] border-[1px] border-[#98A2B3] flex items-center gap-3 hover:shadow-lg  hover:bg-orange-fade-color hover:border-[1px] hover:border-orange-bold-color transition-all bg-white"
                  key={index}
                >
                  <Image
                    src={item.UserEvents[0]?.User?.avatarUrl}
                    alt={item.name}
                    width={50}
                    height={50}
                    className="rounded-full object-cover"
                  />
                  <div className="">
                    <span className="title text-xl text-black font-semibold">
                      {item?.name}
                    </span>
                    <div className="sub-title text-[14px] text-gray-600">
                      {item.description}
                    </div>
                    <div className="leader">
                      <IdcardOutlined /> {item?.UserEvents[0]?.User?.name}{" "}
                      <br />
                      <MailOutlined /> {item?.UserEvents[0]?.User?.email}
                    </div>
                  </div>
                </div>
              );
            })
          ) : (
            <NoData />
          )}
        </div>
      </div>
    </>
  );
};
export default EventTable;
