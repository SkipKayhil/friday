import { JSX } from "preact";
import useSWR from "swr";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Table, Column } from "../components/table";
import { TimeAgo } from "../components/timeAgo";
import { RepoWithRepoable } from "../models";

const updatedCell = ({ row }: { row: RepoWithRepoable }) => (
  <TimeAgo date={new Date(row.updated_at)} />
);

const columns: Column<RepoWithRepoable>[] = [
  { field: "full_path", headerName: "Name" },
  { field: "repoable_type", headerName: "Type" },
  { field: "updated_at", renderCell: updatedCell, headerName: "Last Updated" },
];

const onRowClick = ({ row }: { row: RepoWithRepoable }) => {
  const type = row.repoable_type === "Library" ? "libraries" : "apps";
  const link = `/${type}/${row.repoable_id}`;

  route(link);
};

export function Dashboard(): JSX.Element {
  const { data } = useSWR<RepoWithRepoable[]>("/api/v1/repos");

  return (
    <>
      <Header title="dashboard" />
      <main>
        <Table rows={data || []} columns={columns} onRowClick={onRowClick} />
      </main>
    </>
  );
}
