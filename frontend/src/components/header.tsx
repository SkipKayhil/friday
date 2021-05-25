import { FunctionComponent } from "preact";

const Header: FunctionComponent<{ title: string }> = ({ children, title }) => (
  <div class="max-w-7xl mx-auto py-6 flex">
    <h1 class="text-3xl font-bold leading-tight text-gray-900">{title}</h1>
    {children}
  </div>
);

export { Header };
