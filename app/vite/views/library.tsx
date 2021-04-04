import useSWR from "swr";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table } from "../components/table";
import { LibraryWithRepo } from "../models";

const columns = [
  { field: "full_path", headerName: "Name" },
  { field: "version" },
];

export function Library({ id }) {
  const { data, error } = useSWR<LibraryWithRepo>(`/api/v1/libraries/${id}`);

  if (!data) return <Spinner />;
  if (error) return "error fetching library";

  return (
    <>
      <Header title={data.repo.full_path} />
      <main>
        <Table rows={data.dependents} columns={columns} />
      </main>
    </>
  );
}
