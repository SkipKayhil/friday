import { FunctionComponent, ComponentChildren } from "preact";
import { useState } from "preact/hooks";
import useSWR from "swr";
import { route } from "preact-router";
import { Badge } from "../components/badge";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { TextField } from "../components/textField";
import { TimeAgo } from "../components/timeAgo";
import { AppWithRepo } from "../models";

interface AppRow extends AppWithRepo {
  full_path: AppWithRepo["repo"]["full_path"];
}

const statusCell = ({ row }: { row: AppRow }) => {
  if (!row.repo.dependencies) {
    return <Badge type="warning">Parse Error</Badge>;
  }

  const vulnerable = Object.entries(row.repo.dependencies).some(
    ([, dep]) => dep?.known_vulnerability
  );

  return vulnerable ? <Badge type="error">Vulnerable</Badge> : null;
};

const updatedCell = ({ row }: { row: AppRow }) => (
  <TimeAgo date={new Date(row.updated_at)} />
);

const columns: Column<AppRow>[] = [
  { field: "full_path", headerName: "Name" },
  { field: "dependencies", renderCell: statusCell, headerName: "status" },
  { field: "updated_at", renderCell: updatedCell, headerName: "Last Updated" },
];

const onRowClick = ({ row }: { row: AppRow }) => {
  route(`/apps/${row.id}`);
};

const Apps: FunctionComponent = () => {
  const [search, setSearch] = useState("");
  const { data } = useSWR<AppWithRepo[]>("/api/v1/apps");

  if (!data) return <Spinner />;

  const transformedData = data
    .map((app) => ({
      ...app,
      full_path: app.repo.full_path,
    }))
    .filter((app) => app.full_path.includes(search));

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
        <Table
          rows={transformedData}
          columns={columns}
          onRowClick={onRowClick}
        />
      </main>
    </>
  );
};

export { Apps };
