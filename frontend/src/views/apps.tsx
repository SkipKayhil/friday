import { JSX } from "preact";
import useSWR from "swr";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table } from "../components/table";
import { AppWithRepo } from "../models";

interface Row extends AppWithRepo {
  full_path: AppWithRepo["repo"]["full_path"];
}

interface AppColumns {
  field: keyof Row;
  headerName: string;
}

const columns: AppColumns[] = [
  { field: "full_path", headerName: "Name" },
  { field: "updated_at", headerName: "Last Updated" },
];

const onRowClick = ({ row }: { row: Row }) => {
  route(`/apps/${row.id}`);
};

export function Apps(): JSX.Element {
  const { data } = useSWR<AppWithRepo[]>("/api/v1/apps");

  if (!data) return <Spinner />;

  const transformedData = data.map((app) => ({
    ...app,
    full_path: app.repo.full_path,
  }));

  return (
    <>
      <Header title="apps" />
      <main>
        <Table
          rows={transformedData}
          columns={columns}
          onRowClick={onRowClick}
        />
      </main>
    </>
  );
}
