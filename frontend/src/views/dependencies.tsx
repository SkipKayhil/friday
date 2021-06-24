import { JSX } from "preact";
import useSWR from "swr";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { Dependency } from "../models";

const columns: Column<Dependency>[] = [
  { field: "language" },
  { field: "name" },
];

const onRowClick = ({ row }: { row: Dependency }) => {
  route(`/dependencies/${row.language}/${row.name}`);
};

export function Dependencies(): JSX.Element {
  const { data } = useSWR<Dependency[]>("/api/v1/dependencies");

  if (!data) return <Spinner />;

  return (
    <>
      <Header title="dependencies" />
      <main>
        <Table rows={data} columns={columns} onRowClick={onRowClick} />
      </main>
    </>
  );
}
