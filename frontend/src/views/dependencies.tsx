import { JSX } from "preact";
import { useState } from "preact/hooks";
import useSWR from "swr";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { TextField } from "../components/textField";
import { Dependency } from "../models";

const nameCell = ({ row }: { row: Dependency }) => (
  <Link
    href={`/dependencies/${row.language}/${row.name}`}
    class="hover:text-indigo-500 hover:underline"
  >
    {row.name}
  </Link>
);

const columns: Column<Dependency>[] = [
  { field: "language" },
  { field: "name", renderCell: nameCell },
];

export function Dependencies(): JSX.Element {
  const [search, setSearch] = useState("");
  const { data } = useSWR<Dependency[]>("/api/v1/dependencies");

  if (!data) return <Spinner />;

  const transformedData = data.filter((dependency) =>
    dependency.name.includes(search)
  );

  return (
    <>
      <Header title="dependencies">
        <TextField
          id="search"
          class="ml-auto"
          placeholder="search"
          value={search}
          onInput={(e) => setSearch((e.target as HTMLInputElement).value)}
        />
      </Header>
      <main>
        <Table rows={transformedData} columns={columns} />
      </main>
    </>
  );
}
