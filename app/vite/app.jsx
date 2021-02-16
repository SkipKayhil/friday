import { Router } from "preact-router";
import { Navbar } from "./components/navbar";
import { Dashboard } from "./views/dashboard";
import { Apps } from "./views/apps";
import { Libraries } from "./views/libraries";
import { App as AppView } from "./views/app";

export function App() {
  return (
    <>
      <Navbar />
      <Router>
        <Dashboard path="/" />
        <Apps path="/apps" />
        <AppView path="/apps/:id" />
        <Libraries path="/libraries" />
      </Router>
    </>
  );
}
