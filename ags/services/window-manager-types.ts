interface Focusable {
  focus: () => void;
}

interface ClientDesktopInfo {
  name: string | null;
  description: string | null;
  icon: string;
}

interface Client extends Focusable {
  id: string;
  pid: number;
  title: string;
  active: boolean;
  position: [number, number];
  size: [number, number];
  hidden: boolean;
  floating: boolean;
  pinned: boolean;
  fullscreen: boolean;
  desktopInfo?: ClientDesktopInfo;
}

interface WorkspaceInfo {
  name: string;
  icon: string;
}

interface Workspace extends Focusable {
  id: number;
  index: number;
  display: WorkspaceInfo;
  active: boolean;
  clients: Client[];
}

interface Monitor extends Focusable {
  id: number;
  name: string;
  active: boolean;
  position: [number, number];
  size: [number, number];
  scale: number;
  workspaces: Workspace[];
}

interface WindowManagerConfig {
  defaultWorkspaces: {
    [monitorName: string]: WorkspaceInfo[];
    default: WorkspaceInfo[];
  };
  workspacesPerMonitor: number;
}
