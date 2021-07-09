import { JSX } from "preact";
import { Link } from "./link";

const baseButtonClass = "px-3 py-2 rounded-md text-sm font-medium block";
const linkClass = `text-gray-600 hover:bg-gray-700 hover:text-white ${baseButtonClass}`;
const selectedClass = `bg-gray-900 text-white ${baseButtonClass}`;

export function Navbar(): JSX.Element {
  return (
    <nav class="flex items-center py-3 border-b-2 border-gray-300">
      <h2 class="font-bold">friday</h2>
      <ul class="flex items-center space-x-4 ml-10">
        <li>
          <Link href="/" class={linkClass} activeClass={selectedClass}>
            dashboard
          </Link>
        </li>
        {["apps", "dependencies"].map((text) => (
          <li key={text}>
            <Link
              href={`/${text}`}
              class={linkClass}
              activeClass={selectedClass}
            >
              {text}
            </Link>
          </li>
        ))}
      </ul>
      <Link
        href={`/repos/new`}
        class={`${linkClass} ml-auto`}
        activeClass={`${selectedClass} ml-auto`}
      >
        new
      </Link>
    </nav>
  );
}
