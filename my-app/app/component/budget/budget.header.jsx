import React from "react";

const BudgetHeader = (props) => {
  const { budgetInfo } = props;
  return (
    <div className=" grid grid-cols-1 md:grid-cols-3 md:gap-2 border-[#D0D5DD] border-[1px]">
      {budgetInfo.map((item) => {
        return (
          <div className="budget-item flex justify-between ">
            <div className="budget-title min-w-[85px] whitespace-nowrap px-2 py-3 bg-[#D0D5DD] text-black">
              {item.label}
            </div>
            <div className="budget-price px-2 py-3">{item.price}</div>
          </div>
        );
      })}
    </div>
  );
};

export default BudgetHeader;
