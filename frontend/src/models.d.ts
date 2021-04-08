interface Dependency {
  version: string;
}

interface Repo {
  id: number;
  name: string;
  full_path: string;
  directory: string;
  ruby_version: string;
  dependencies?: Record<string, Dependency | undefined>;
  host_id: number;
  created_at: string;
  updated_at: string;
}

interface App {
  id: number;
  created_at: string;
  updated_at: string;
}

interface Dependent {
  id: number;
  full_path: string;
  version: string;
}

interface Library {
  id: number;
  created_at: string;
  updated_at: string;
  dependents: Dependent[];
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

type LibraryWithRepo = Library & Repoable;

export {
  Dependency,
  Repo,
  App,
  Library,
  RepoWithRepoable,
  AppWithRepo,
  LibraryWithRepo,
};
