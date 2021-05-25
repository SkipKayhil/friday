import { FunctionComponent } from "preact";

type Type = "error" | "warning";

const colorFor = (type?: Type) => {
  switch (type) {
    case "error":
      return "bg-red-500";
    case "warning":
      return "bg-yellow-500";
    default:
      return "bg-green-500";
  }
};

interface StatusProps {
  type?: Type;
}

const Status: FunctionComponent<StatusProps> = ({ type }) => (
  <span class={`inline-block rounded-full w-3 h-3 ${colorFor(type)}`} />
);

export { Status };
