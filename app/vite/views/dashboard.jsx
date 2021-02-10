import { useEffect, useState } from "preact/hooks";
import { Header } from "../components/header";
import { Table } from "../components/table";

const columns = [
  { field: "full_path", headerName: "Name" },
  { field: "repoable_type", headerName: "Type" },
];

export function Dashboard() {
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
      <Header title="dashboard" />
      <main>
        <Table rows={repos} columns={columns} />
      </main>
    </>
  );
}
