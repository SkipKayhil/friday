import { useEffect, useState } from "preact/hooks";

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
      <h1>Dep</h1>
      <table>
        <thead>
          <tr>
            <th>Name</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {repos.map((repo) => (
            <tr>
              <td>
                <a href={repo.full_path}>{repo.full_path}</a>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </>
  );
}
