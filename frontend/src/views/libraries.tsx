import { JSX } from "preact";
import useSWR from "swr";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table } from "../components/table";
import { LibraryWithRepo } from "../models";

interface Row extends LibraryWithRepo {
  full_path: LibraryWithRepo["repo"]["full_path"];
}

interface LibraryColumns {
  field: keyof Row;
  headerName: string;
}

const columns: LibraryColumns[] = [
  { field: "full_path", headerName: "Name" },
  { field: "updated_at", headerName: "Last Updated" },
];

const onRowClick = ({ row }: { row: Row }) => {
  route(`/libraries/${row.id}`);
};

export function Libraries(): JSX.Element {
  const { data } = useSWR<LibraryWithRepo[]>("/api/v1/libraries");

  if (!data) return <Spinner />;

  const transformedData = data.map((lib) => ({
    ...lib,
    full_path: lib.repo.full_path,
  }));

  return (
    <>
      <Header title="libraries" />
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
