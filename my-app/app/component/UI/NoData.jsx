import { Empty, Typography } from "antd";
import React from "react";

const NoData = () => {
  return (
    <div className="flex w-full items-center justify-center">
      <Empty
        description={<Typography.Text>Không có dữ liệu.</Typography.Text>}
      />
    </div>
  );
};

export default NoData;
