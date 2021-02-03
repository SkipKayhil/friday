import { useEffect, useState } from "preact/hooks";
import { Header } from "./components/header";
import { Table } from "./components/table";

const columns = [
  { field: "full_path", headerName: "Name" },
  { field: "repoable_type", headerName: "Type" },
];

export function App() {
  const [repos, setRepos] = useState([]);

  useEffect(() => {
    async function getRepos() {
      const response = await fetch("/api/v1/repos");
      const repos = await response.json();

      setRepos(repos);
    }

    getRepos();
  }, []);

  return (
    <>
      <Header />
      <div class="max-w-7xl mx-auto py-6">
        <h1 class="text-3xl font-bold leading-tight text-gray-900">
          dashboard
        </h1>
      </div>
      <main>
        <Table rows={repos} columns={columns} />
      </main>
    </>
  );
}
