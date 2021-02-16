import { useEffect, useState } from "preact/hooks";
import { route } from "preact-router";
import { Header } from "../components/header";
import { Table } from "../components/table";

const columns = [
  { field: "full_path", headerName: "Name" },
  { field: "repoable_type", headerName: "Type" },
  { field: "updated_at", headerName: "Last Updated" },
];

const onRowClick = ({ row }) => {
  const type = row.repoable_type === "Library" ? "libraries" : "apps";
  const link = `/${type}/${row.repoable_id}`;

  route(link);
};

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
        <Table rows={repos} columns={columns} onRowClick={onRowClick} />
      </main>
    </>
  );
}
