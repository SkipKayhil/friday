import { Router, Route } from "preact-router";
import { Navbar } from "./components/navbar";
import { Dashboard } from "./views/dashboard";
import { Apps } from "./views/apps";
import { Libraries } from "./views/libraries";
import { App as AppView } from "./views/app";
import { Library as LibraryView } from "./views/library";

export function App() {
  return (
    <>
      <Navbar />
      <Router>
        <Route component={Dashboard} path="/" />
        <Route component={Apps} path="/apps" />
        <Route component={AppView} path="/apps/:id" />
        <Route component={Libraries} path="/libraries" />
        <Route component={LibraryView} path="/libraries/:id" />
      </Router>
    </>
  );
}
