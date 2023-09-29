import React from "react";

type Props = {
  variant?: "orange" | "green" | "red" | "blue" | "yellow";
};

const Circle = ({ variant }: Props) => {
  const bgColor = `bg-${variant}-500`;

  return <div className={`${bgColor} w-14 h-14 p-2 rounded-full`}></div>;
};

export default Circle;
