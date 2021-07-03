import { FunctionComponent, JSX } from "preact";
import { Label } from "./label";

interface TextFieldProps extends JSX.HTMLAttributes<HTMLInputElement> {
  id: string;
  label?: string;
  class?: string;
}

const TextField: FunctionComponent<TextFieldProps> = ({
  id,
  label,
  type,
  class: c,
  ...props
}) => (
  <div class={c}>
    {label ? <Label label={label} for={id} /> : null}
    <input
      id={id}
      type={type || "text"}
      class="mt-1 focus:ring-indigo-500 focus:border-indigo-500 block w-full shadow-sm sm:text-sm border-gray-300 rounded-md"
      {...props}
    />
  </div>
);

export { TextField };
