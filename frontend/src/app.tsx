import { JSX } from "preact";
import { Router, Route } from "preact-router";
import { Navbar } from "./components/navbar";
// import { Dashboard } from "./views/dashboard";
import { Apps } from "./views/apps";
import { Dependencies } from "./views/dependencies";
import { DependencyView } from "./views/dependency";
import { App as AppView } from "./views/app";
import { NewRepo } from "./views/newRepo";

export function App(): JSX.Element {
  return (
    <>
      <Navbar />
      <Router>
        <Route component={Apps} path="/" />
        <Route component={Apps} path="/apps" />
        <Route component={AppView} path="/apps/:id" />
        <Route component={Dependencies} path="/dependencies" />
        <Route component={DependencyView} path="/dependencies/:language/:name" />
        <Route component={NewRepo} path="/repos/new" />
      </Router>
    </>
  );
}
