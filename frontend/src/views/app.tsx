import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Spinner } from "../components/spinner";
import { Table } from "../components/table";
import { AppWithRepo, Dependency } from "../models";

type DepColumn = {
  field: keyof Dependency | "name";
};

const columns: DepColumn[] = [{ field: "name" }, { field: "version" }];

export function App({ id }: { id: string }): JSX.Element {
  const { data, error } = useSWR<AppWithRepo>(`/api/v1/apps/${id}`);

  if (!data) return <Spinner />;
  if (error) return <>{"error fetching app"}</>;

  const transformedData = Object.entries(data.repo.dependencies || {}).map(
    ([name, value]) => ({
      ...value,
      name,
    })
  );

  return (
    <>
      <Header title={data.repo.full_path} />
      <main>
        <Table rows={transformedData} columns={columns} />
      </main>
    </>
  );
}
