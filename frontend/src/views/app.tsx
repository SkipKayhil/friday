import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table } from "../components/table";
import { AppWithRepo, Dependency } from "../models";

type DepColumn = {
  field: keyof Dependency | "name";
};

const columns: DepColumn[] = [
  { field: "name" },
  { field: "version" },
  { field: "vulnerability_status" },
];

const criticalities = ['none', 'low', 'medium', 'high', 'critical'];

export function App({ id }: { id: string }): JSX.Element {
  const { data, error } = useSWR<AppWithRepo>(`/api/v1/apps/${id}`);

  if (!data) return <Spinner />;
  if (error) return <>{"error fetching app"}</>;

  const transformedData = data.dependencies
    .map(({ vulnerability_status, ...rest }) => ({
      ...rest,
      vulnerability_status: vulnerability_status === 'none' ? '' : vulnerability_status,
    }))
    .sort((a, b) => {
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
