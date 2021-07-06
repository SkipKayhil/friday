import { FunctionComponent } from "preact";
import { useState } from "preact/hooks";
import useSWR from "swr";
import { Badge } from "../components/badge";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { TextField } from "../components/textField";
import { TimeAgo } from "../components/timeAgo";
import { AppWithRepo } from "../models";

const pathCell = ({ row }: { row: AppWithRepo }) => (
  <Link href={`/apps/${row.id}`} class="hover:text-indigo-500 hover:underline">
    {row.repo.full_path}
  </Link>
);

const statusCell = ({ row }: { row: AppWithRepo }) => {
  if (!row.repo.dependencies) {
    return <Badge type="warning">Parse Error</Badge>;
  }

  const vulnerable = Object.entries(row.repo.dependencies).some(
    ([, dep]) => dep?.known_vulnerability
  );

  return vulnerable ? <Badge type="error">Vulnerable</Badge> : null;
};

const updatedCell = ({ row }: { row: AppWithRepo }) => (
  <TimeAgo date={new Date(row.updated_at)} />
);

const columns: Column<AppWithRepo>[] = [
  { field: "name", renderCell: pathCell },
  { field: "dependencies", renderCell: statusCell, headerName: "status" },
  { field: "updated_at", renderCell: updatedCell, headerName: "Last Updated" },
];

const Apps: FunctionComponent = () => {
  const [search, setSearch] = useState("");
  const { data } = useSWR<AppWithRepo[]>("/api/v1/apps");

  if (!data) return <Spinner />;

  const transformedData = data
    .map((app) => ({
      ...app,
      name: app.repo.full_path,
    }))
    .filter((app) => app.name.includes(search));

  return (
    <>
      <Header title="apps">
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
};

export { Apps };
