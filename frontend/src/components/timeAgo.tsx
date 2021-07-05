import { FunctionComponent } from "preact";

const units = [
  { label: "year", toSeconds: 31536000, singular: "last year" },
  { label: "month", toSeconds: 2592000, singular: "last month" },
  { label: "day", toSeconds: 86400, singular: "yesterday" },
  { label: "hour", toSeconds: 3600, singular: "1 hour ago" },
  { label: "minute", toSeconds: 60, singular: "1 minute ago" },
];

const second = { label: "second", toSeconds: 1, singular: "1 second ago" };

const TimeAgo: FunctionComponent<{ date: Date }> = ({ date }) => {
  const secondsSince = Math.floor((Date.now() - date.getTime()) / 1000);
  const unit = units.find((unit) => unit.toSeconds < secondsSince) || second;
  const roundedValue = Math.floor(secondsSince / unit.toSeconds);

  return (
    <>
      {roundedValue === 1
        ? unit.singular
        : `${roundedValue} ${unit.label}s ago`}
    </>
  );
};

export { TimeAgo };
