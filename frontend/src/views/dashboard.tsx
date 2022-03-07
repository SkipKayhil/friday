import { JSX } from "preact";
import useSWR from "swr";
import { Header } from "../components/header";
import { Link } from "../components/link";
import { Table, Column } from "../components/table";
import { TimeAgo } from "../components/timeAgo";

export function Dashboard(): JSX.Element {
  return (
    <>
      <Header title="dashboard" />
      <main>
      </main>
    </>
  );
}
