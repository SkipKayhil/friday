import { FunctionComponent } from "preact";

const rtf = new Intl.RelativeTimeFormat("en", { numeric: "auto" });
const dtf = new Intl.DateTimeFormat("default", {
  day: "numeric",
  month: "short",
  year: "numeric",
  hour: "numeric",
  minute: "2-digit",
  timeZoneName: "short",
});

type Unit = {
  label: Intl.RelativeTimeFormatUnit;
  toSeconds: number;
};

const units: Unit[] = [
  { label: "year", toSeconds: 31536000 },
  { label: "month", toSeconds: 2592000 },
  { label: "day", toSeconds: 86400 },
  { label: "hour", toSeconds: 3600 },
  { label: "minute", toSeconds: 60 },
];

const second: Unit = { label: "second", toSeconds: 1 };

const TimeAgo: FunctionComponent<{ date: Date }> = ({ date }) => {
  const secondsSince = Math.floor((Date.now() - date.getTime()) / 1000);
  const unit = units.find((unit) => unit.toSeconds < secondsSince) || second;
  const roundedValue = Math.floor(secondsSince / unit.toSeconds);

  return (
    <span title={dtf.format(date)}>
      {rtf.format(-1 * roundedValue, unit.label)}
    </span>
  );
};

export { TimeAgo };
