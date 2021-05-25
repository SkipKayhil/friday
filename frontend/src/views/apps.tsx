import { FunctionComponent, JSX } from "preact";
import { useState } from "preact/hooks";
import useSWR from "swr";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Status } from "../components/status";
import { Table } from "../components/table";
import { TextField } from "../components/textField";
import { AppWithRepo } from "../models";

interface Row extends AppWithRepo {
  full_path: AppWithRepo["repo"]["full_path"];
}

interface AppColumns {
  field: keyof Row | "status";
  headerName: string;
  renderCell?({ row, column }: { row: Row; column: AppColumns }): JSX.Element;
}

const statusCell = ({ row }: { row: Row }) => {
  if (!row.repo.dependencies) {
    return <Status type="warning" />;
  }

  const vulnerable = Object.entries(row.repo.dependencies).some(
    ([, dep]) => dep?.known_vulnerability
  );

  return vulnerable ? <Status type="error" /> : "";
};

const columns: AppColumns[] = [
  { field: "status", renderCell: statusCell, headerName: "" },
  { field: "full_path", headerName: "Name" },
  { field: "updated_at", headerName: "Last Updated" },
];

const onRowClick = ({ row }: { row: Row }) => {
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
