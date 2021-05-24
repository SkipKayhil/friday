import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table } from "../components/table";
import { LibraryWithRepo } from "../models";

interface LibraryColumns {
  field: keyof LibraryWithRepo["dependents"][number];
  headerName?: string;
}

const columns: LibraryColumns[] = [
  { field: "full_path", headerName: "Name" },
  { field: "version" },
  { field: "known_vulnerability", headerName: "Known Vulnerability" },
];

export function Library({ id }: { id: string }): JSX.Element {
  const { data, error } = useSWR<LibraryWithRepo>(`/api/v1/libraries/${id}`);

  if (!data) return <Spinner />;
  if (error) return <>{"error fetching library"}</>;

  const transformedData = data.dependents.map((dependent) => ({
    ...dependent,
    known_vulnerability: dependent.known_vulnerability ? "YES" : "",
  }));

  return (
    <>
      <Header title={data.repo.full_path} />
      <main>
        <Table rows={transformedData} columns={columns} />
      </main>
    </>
  );
}
