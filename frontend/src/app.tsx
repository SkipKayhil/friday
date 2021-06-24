import { JSX } from "preact";
import { Router, Route } from "preact-router";
import { Navbar } from "./components/navbar";
import { Dashboard } from "./views/dashboard";
import { Apps } from "./views/apps";
import { Dependencies } from "./views/dependencies";
import { Dependency } from "./views/dependency";
import { Libraries } from "./views/libraries";
import { App as AppView } from "./views/app";
import { Library } from "./views/library";
import { NewRepo } from "./views/newRepo";

export function App(): JSX.Element {
  return (
    <>
      <Navbar />
      <Router>
        <Route component={Dashboard} path="/" />
        <Route component={Apps} path="/apps" />
        <Route component={AppView} path="/apps/:id" />
        <Route component={Dependencies} path="/dependencies" />
        <Route component={Dependency} path="/dependencies/:language/:name" />
        <Route component={Libraries} path="/libraries" />
        <Route component={Library} path="/libraries/:id" />
        <Route component={NewRepo} path="/repos/new" />
      </Router>
    </>
  );
}
