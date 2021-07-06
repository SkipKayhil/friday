import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { AppWithRepo, VersionedDependency } from "../models";

const nameCell = ({ row }: { row: VersionedDependency }) => (
  // TODO: need to use the App's language here
  <Link
    href={`/dependencies/ruby/${row.name}`}
    class="hover:text-indigo-500 hover:underline"
  >
    {row.name}
  </Link>
);

const statusCell = ({ row }: { row: VersionedDependency }) => (
  <>{row.vulnerability_status === "none" ? "" : row.vulnerability_status}</>
);
const columns: Column<VersionedDependency>[] = [
  { field: "name", renderCell: nameCell },
  { field: "version" },
  {
    field: "vulnerability_status",
    headerName: "Vulnerability Status",
    renderCell: statusCell,
  },
];

const criticalities = ["none", "low", "medium", "high", "critical"];

export function App({ id }: { id: string }): JSX.Element {
  const { data, error } = useSWR<AppWithRepo>(`/api/v1/apps/${id}`);

  if (!data) return <Spinner />;
  if (error) return <>error fetching app</>;

  const transformedData = data.dependencies.sort((a, b) => {
    if (a.vulnerability_status === b.vulnerability_status) {
      return a.name.localeCompare(b.name);
    }

    const aCriticality = criticalities.indexOf(a.vulnerability_status);
    const bCriticality = criticalities.indexOf(b.vulnerability_status);

    return bCriticality - aCriticality;
  });

  return (
    <>
      <Header title={data.repo.full_path} />
      <main>
        <Table rows={transformedData} columns={columns} />
      </main>
    </>
  );
}
