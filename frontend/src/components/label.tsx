import { FunctionComponent } from "preact";

interface LabelProps extends JSX.HTMLAttributes<HTMLLabelElement> {
  label: string;
}

const Label: FunctionComponent<LabelProps> = ({ label, ...props }) => (
  <label class="block text-sm font-medium text-gray-700" {...props}>
    {label}
  </label>
);

export { Label };
