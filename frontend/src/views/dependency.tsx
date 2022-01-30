import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { AppWithRepo, Dependency, ProjectWithRepositoryHost } from "../models";

interface Row {
  id: number;
  full_path: string;
  version: string;
}

const nameCell = ({ row }: { row: Row }) => (
  <Link href={`/projects/${row.id}`} class="hover:text-indigo-500 hover:underline">
    {row.full_path}
  </Link>
);

const columns: Column<Row>[] = [
  { field: "name", renderCell: nameCell },
  { field: "version" },
  // { field: "known_vulnerability", headerName: "Known Vulnerability" },
];

export function DependencyView({
  language,
  name,
}: {
  language: string;
  name: string;
}): JSX.Element {
  const { data, error } = useSWR<Dependency, unknown>(
    `/api/v2/dependencies/${language}/${name}`
  );
  const { data: apps, error: appError } = useSWR<ProjectWithRepositoryHost[], unknown>(
    `/api/v2/projects`
  );

  if (!data || !data.versions || !apps) return <Spinner />;
  if (error || appError) return <>error fetching dependency</>;

  const transformedData = Object.entries(data.versions).flatMap(
    ([version, appIds]) =>
      appIds.map((id) => {
        const app = apps.find((app) => app.id === id);

        if (!app) throw "this is not possible...";

        return {
          id: app.id,
          full_path: app.repository.full_path,
          version,
        };
      })
  );

  return (
    <>
      <Header title={`${data.name} (${data.language})`} />
      <main>
        <Table rows={transformedData} columns={columns} />
      </main>
    </>
  );
}
