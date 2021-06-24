import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table, Column } from "../components/table";
import { AppWithRepo, Dependency } from "../models";

const columns: Column<{
  full_path: string;
  version: string;
}>[] = [
  { field: "full_path", headerName: "Full Path" },
  { field: "version" },
  // { field: "known_vulnerability", headerName: "Known Vulnerability" },
];

export function Dependency({
  language,
  name,
}: {
  language: string;
  name: string;
}): JSX.Element {
  const { data, error } = useSWR<Dependency>(
    `/api/v1/dependencies/${language}/${name}`
  );
  // TODO: pull the list of Apps without a second request
  const { data: apps, error: appError } = useSWR<AppWithRepo[]>(`/api/v1/apps`);

  if (!data || !data.versions || !apps) return <Spinner />;
  if (error) return <>error fetching dependency</>;

  const transformedData = Object.entries(data.versions).flatMap(
    ([version, appIds]) =>
      appIds.map((id) => {
        const app = apps.find((app) => app.id === id);

        if (!app) throw "this is not possible...";

        return {
          full_path: app.repo.full_path,
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
