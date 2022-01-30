import { useState } from "preact/hooks";
import useSWR from "swr";
import { Badge } from "../components/badge";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { TextField } from "../components/textField";
import { TimeAgo } from "../components/timeAgo";
import { ProjectWithRepositoryHost } from "../models";

const pathCell = ({ row }: { row: ProjectWithRepositoryHost }) => (
  <Link
    href={`/projects/${row.id}`}
    class="hover:text-indigo-500 hover:underline"
  >
    {row.repository.full_path}
  </Link>
);

const statusCell = ({ row }: { row: ProjectWithRepositoryHost }) => {
  if (!row.dependencies) {
    return <Badge color="yellow">Parse Error</Badge>;
  }

  const vulnerable = row.dependencies.some(
    (dep) => dep.vulnerability_status !== "none"
  );

  return vulnerable ? <Badge color="red">Vulnerable</Badge> : null;
};

const updatedCell = ({ row }: { row: ProjectWithRepositoryHost }) => (
  <TimeAgo date={new Date(row.updated_at)} />
);

const columns: Column<ProjectWithRepositoryHost>[] = [
  { field: "name", renderCell: pathCell },
  { field: "package_manager", headerName: "Package Manager" },
  { field: "language_version", headerName: "Language Version" },
  { field: "dependencies", renderCell: statusCell, headerName: "status" },
  { field: "updated_at", renderCell: updatedCell, headerName: "Last Updated" },
];

const Projects = (): JSX.Element => {
  const [search, setSearch] = useState("");
  const { data } = useSWR<ProjectWithRepositoryHost[]>("/api/v2/projects");

  if (!data) return <Spinner />;

  const transformedData = data
    .map((project) => ({
      ...project,
      name: project.repository.full_path,
    }))
    .filter((project) => project.name.includes(search));

  return (
    <>
      <Header title="projects">
        <TextField
          id="search"
          class="ml-auto"
          placeholder="search"
          value={search}
          onInput={(e) => setSearch((e.target as HTMLInputElement).value)}
        />
      </Header>
      <main>
        <Table rows={transformedData} columns={columns} />
      </main>
    </>
  );
};

export { Projects };
