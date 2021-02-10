import { Router } from "preact-router";
import { Navbar } from "./components/navbar";
import { Dashboard } from "./views/dashboard";
import { Apps } from "./views/apps";
import { Libraries } from "./views/libraries";

export function App() {
  return (
    <>
      <Navbar />
      <Router>
        <Dashboard path="/" />
        <Apps path="/apps" />
        <Libraries path="/libraries" />
      </Router>
    </>
  );
}
