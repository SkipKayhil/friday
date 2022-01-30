import { JSX } from "preact";
import useSWR from "swr";
import { Badge } from "../components/badge";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { ProjectWithRepositoryHost, VersionedDependency } from "../models";

const criticalityColors: Record<
  string,
  "gray" | "yellow" | "orange" | "red"
> = {
  low: "gray",
  medium: "yellow",
  high: "orange",
  critical: "red",
};

const criticalities = ["none", ...Object.keys(criticalityColors)];

const nameCell = (language: string) => ({ row }: { row: VersionedDependency }) => (
  <Link
    href={`/dependencies/${language}/${row.name}`}
    class="hover:text-indigo-500 hover:underline"
  >
    {row.name}
  </Link>
);

const statusCell = ({ row }: { row: VersionedDependency }) =>
  row.vulnerability_status === "none" ? null : (
    <Badge color={criticalityColors[row.vulnerability_status]}>
      {row.vulnerability_status}
    </Badge>
  );

const columns = (language: string): Column<VersionedDependency>[] => [
  { field: "name", renderCell: nameCell(language) },
  { field: "version" },
  {
    field: "vulnerability_status",
    headerName: "Vulnerability Status",
    renderCell: statusCell,
  },
];

export function Project({ id }: { id: string }): JSX.Element {
  const { data, error } = useSWR<ProjectWithRepositoryHost, unknown>(
    `/api/v2/projects/${id}`
  );

  if (!data) return <Spinner />;
  if (error) return <>error fetching app</>;

  const transformedData = data.dependencies
    ? data.dependencies.sort((a, b) => {
        if (a.vulnerability_status === b.vulnerability_status) {
          return a.name.localeCompare(b.name);
        }

        const aCriticality = criticalities.indexOf(a.vulnerability_status);
        const bCriticality = criticalities.indexOf(b.vulnerability_status);

        return bCriticality - aCriticality;
      })
    : [];

  return (
    <>
      <Header title={data.repository.full_path} />
      <main>
        <Table rows={transformedData} columns={columns(data.language)} />
      </main>
    </>
  );
}
