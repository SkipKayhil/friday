import { FunctionComponent, JSX } from "preact";

const Footer: FunctionComponent = ({ children }) =>
  children ? (
    <div class="px-4 py-3 bg-gray-50 text-right sm:px-6">{children}</div>
  ) : null;

const Card: FunctionComponent<{ footer?: JSX.Element }> = ({
  children,
  footer,
}) => (
  <div class="shadow overflow-hidden sm:rounded-md">
    <div class="px-4 py-5 sm:px-6 bg-white">{children}</div>
    <Footer>{footer}</Footer>
  </div>
);

export { Card };
