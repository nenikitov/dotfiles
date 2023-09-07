interface ClientDesktopInfo {
  name: string | null;
  description: string | null;
  icon: string;
}

interface Client {
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

interface Workspace {
  id: number;
  name: string;
  active: boolean;
  clients: Client[];
}

interface Monitor {
  id: number;
  name: string;
  active: boolean;
  position: [number, number];
  size: [number, number];
  scale: number;
  workspaces: Workspace[];
}