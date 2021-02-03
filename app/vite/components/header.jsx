const baseButtonClass = "px-3 py-2 rounded-md text-sm font-medium block";
const linkClass = `text-gray-600 hover:bg-gray-700 hover:text-white ${baseButtonClass}`;
const selectedClass = `bg-gray-900 text-white ${baseButtonClass}`;

export function Header() {
  return (
    <nav class="flex items-center py-3 border-b-2 border-gray-300">
      <h2 class="font-bold">dep</h2>
      <ul class="flex items-center space-x-4 ml-10">
        <li>
          <a href="#" class={selectedClass}>
            dashboard
          </a>
        </li>
        {["apps", "libraries"].map((text) => (
          <li>
            <a href="#" class={linkClass}>
              {text}
            </a>
          </li>
        ))}
      </ul>
    </nav>
  );
}
