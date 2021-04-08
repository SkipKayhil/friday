import { JSX } from "preact";

export function Header({ title }: { title: string }): JSX.Element {
  return (
    <div class="max-w-7xl mx-auto py-6">
      <h1 class="text-3xl font-bold leading-tight text-gray-900">{title}</h1>
    </div>
  );
}
