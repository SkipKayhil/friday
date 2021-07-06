import { FunctionComponent } from "preact";

type Color = "red" | "orange" | "yellow" | "gray" | "green";

const classFor = (color?: Color) => {
  switch (color) {
    case "red":
      return "bg-red-100 text-red-800";
    case "orange":
      return "bg-orange-100 text-orange-800";
    case "yellow":
      return "bg-yellow-200 text-yellow-900";
    case "green":
      return "bg-green-100 text-green-800";
    default:
      return "bg-gray-200 text-gray-900";
  }
};

interface BadgeProps {
  color?: Color;
}

const Badge: FunctionComponent<BadgeProps> = ({ children, color }) => (
  <span
    class={`inline-block rounded-full font-semibold text-xs px-2 ${classFor(
      color
    )}`}
  >
    {children}
  </span>
);

export { Badge };
