import { JSX } from "preact";
import { Router, Route } from "preact-router";
import { SWRConfig } from "swr";
import { Navbar } from "./components/navbar";
// import { Dashboard } from "./views/dashboard";
import { Dependencies } from "./views/dependencies";
import { DependencyView } from "./views/dependency";
import { NewRepo } from "./views/newRepo";
import { Projects } from "./views/projects";
import { Project } from "./views/project";

export function App(): JSX.Element {
  return (
    <SWRConfig
      value={{
        fetcher: (resource: string, init: RequestInit) =>
          fetch(resource, init).then((response) => response.json()),
      }}
    >
      <Navbar />
      <Router>
        <Route component={Projects} path="/" />
        <Route component={Projects} path="/projects" />
        <Route component={Project} path="/projects/:id" />
        <Route component={Dependencies} path="/dependencies" />
        <Route
          component={DependencyView}
          path="/dependencies/:language/:name"
        />
        <Route component={NewRepo} path="/repos/new" />
      </Router>
    </SWRConfig>
  );
}
