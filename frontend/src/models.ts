type Language = "ruby" | "java";
type PackageManager = "bundler" | "gradle" | "maven";

interface ActiveRecord {
  id: number;
  created_at: string;
  updated_at: string;
}

interface Host extends ActiveRecord {
  domain: string;
}

interface Project extends ActiveRecord {
  name?: string;
  directory?: string;
  package_manager: PackageManager;
  language: Language;
  language_version: string;
  repository_id: number;
  dependencies: VersionedDependency[];
}

interface Repository extends ActiveRecord {
  full_path: string;
  host_id: number;
}

interface Dependency {
  language: "ruby";
  name: string;
  versions?: Record<string, number[]>;
}

interface VersionedDependency {
  name: string;
  version: string;
  vulnerability_status: "none" | "low" | "medium" | "high" | "critical";
}

interface RepositoryWithHost extends Repository {
  host: Host;
}

interface ProjectWithRepositoryHost extends Project {
  repository: RepositoryWithHost;
}

export type {
  Dependency,
  Project,
  ProjectWithRepositoryHost,
  Repository,
  VersionedDependency,
};
