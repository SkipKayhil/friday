import useSWR from "swr";
import { Header } from "../components/header";
import { AppWithRepo } from "../models";

export function App({ id }) {
  const { data, error } = useSWR<AppWithRepo>(`/api/v1/apps/${id}`);

  if (!data) return "loading";
  if (error) return "error fetching app";

  return (
    <>
      <Header title={data.repo.full_path} />
    </>
  );
}
