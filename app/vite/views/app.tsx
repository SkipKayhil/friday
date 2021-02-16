import { useEffect, useState } from "preact/hooks";
import { Header } from "../components/header";
import { AppWithRepo } from "../models";

export function App({ id }) {
  const [app, setApp] = useState<AppWithRepo>(undefined);

  useEffect(() => {
    async function getApp() {
      const response = await fetch(`/api/v1/apps/${id}`);
      const app: AppWithRepo = await response.json();

      setApp(app);
    }

    getApp();
  }, [id]);

  if (!app) return "loading";

  return (
    <>
      <Header title={app.repo.full_path} />
    </>
  );
}
