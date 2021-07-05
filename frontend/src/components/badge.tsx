import { FunctionComponent } from "preact";

type Type = "error" | "warning";

const colorFor = (type?: Type) => {
  switch (type) {
    case "error":
      return "bg-red-100 text-red-800";
    case "warning":
      return "bg-yellow-200 text-yellow-900";
    default:
      return "bg-green-100 text-green-800";
  }
};

interface BadgeProps {
  type?: Type;
}

const Badge: FunctionComponent<BadgeProps> = ({ children, type }) => (
  <span
    class={`inline-block rounded-full font-semibold text-xs px-2 ${colorFor(
      type
    )}`}
  >
    {children}
  </span>
);

export { Badge };
