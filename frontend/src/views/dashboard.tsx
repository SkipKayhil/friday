import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Table, Column } from "../components/table";
import { TimeAgo } from "../components/timeAgo";
import { RepoWithRepoable } from "../models";

const nameCell = ({ row }: { row: RepoWithRepoable }) => (
  <Link
    href={`/${row.repoable_type === "App" ? "apps" : "libraries"}/${
      row.repoable_id
    }`}
    class="hover:text-indigo-500 hover:underline"
  >
    {row.full_path}
  </Link>
);

const updatedCell = ({ row }: { row: RepoWithRepoable }) => (
  <TimeAgo date={new Date(row.updated_at)} />
);

const columns: Column<RepoWithRepoable>[] = [
  { field: "name", renderCell: nameCell },
  { field: "repoable_type", headerName: "Type" },
  { field: "updated_at", renderCell: updatedCell, headerName: "Last Updated" },
];

export function Dashboard(): JSX.Element {
  const { data } = useSWR<RepoWithRepoable[]>("/api/v1/repos");

  return (
    <>
      <Header title="dashboard" />
      <main>
        <Table rows={data || []} columns={columns} />
      </main>
    </>
  );
}
