import { FunctionComponent } from "preact";
import { Label } from "./label";

const Select: FunctionComponent<{ label?: string }> = ({ label }) => (
  <div>{label ? <Label label={label} /> : null}</div>
);

export { Select };
