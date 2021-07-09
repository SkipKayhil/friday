interface Repo {
  id: number;
  name: string;
  full_path: string;
  directory: string;
  ruby_version: string;
  host_id: number;
  created_at: string;
  updated_at: string;
}

interface App {
  id: number;
  dependencies: VersionedDependency[];
  created_at: string;
  updated_at: string;
}

interface Dependency {
  language: "ruby";
  name: string;
  versions?: Record<string, number[]>;
}

interface VersionedDependency extends Dependency {
  version: string;
  vulnerability_status: "none" | "low" | "medium" | "high" | "critical";
}

interface Library {
  id: number;
  created_at: string;
  updated_at: string;
}

interface Repoable {
  repo: Repo;
}

interface RepoApp extends Repo {
  repoable_type: "App";
  repoable_id: number;
  repoable: App;
}

interface RepoLibrary extends Repo {
  repoable_type: "Library";
  repoable_id: number;
  repoable: Library;
}

type RepoWithRepoable = RepoApp | RepoLibrary;

type AppWithRepo = App & Repoable;

export {
  Dependency,
  Repo,
  App,
  VersionedDependency,
  RepoWithRepoable,
  AppWithRepo,
};
