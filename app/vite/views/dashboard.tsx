import useSWR from "swr";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Table } from "../components/table";
import { RepoWithRepoable } from "../models";

const columns = [
  { field: "full_path", headerName: "Name" },
  { field: "repoable_type", headerName: "Type" },
  { field: "updated_at", headerName: "Last Updated" },
];

const onRowClick = ({ row }) => {
  const type = row.repoable_type === "Library" ? "libraries" : "apps";
  const link = `/${type}/${row.repoable_id}`;

  route(link);
};

export function Dashboard() {
  const { data } = useSWR<RepoWithRepoable>("/api/v1/repos");

  return (
    <>
      <Header title="dashboard" />
      <main>
        <Table rows={data || []} columns={columns} onRowClick={onRowClick} />
      </main>
    </>
  );
}
