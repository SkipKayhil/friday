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
  { field: "known_vulnerability" },
];

export function App({ id }: { id: string }): JSX.Element {
  const { data, error } = useSWR<AppWithRepo>(`/api/v1/apps/${id}`);

  if (!data) return <Spinner />;
  if (error) return <>{"error fetching app"}</>;

  // const transformedData = Object.entries(data.repo.dependencies || {})
  //   .map(([name, { known_vulnerability, ...value }]) => ({
  //     ...value,
  //     known_vulnerability: known_vulnerability ? "YES" : "",
  //     name,
  //   }))
  //   .sort((a, b) => {
  //     if (a.known_vulnerability === b.known_vulnerability) {
  //       return a.name.localeCompare(b.name);
  //     }

  //     return a.known_vulnerability === "YES" ? -1 : 1;
  //   });

  return (
    <>
      <Header title={data.repo.full_path} />
      <main>
        <Table rows={data.dependencies} columns={columns} />
      </main>
    </>
  );
}
