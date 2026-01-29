import app from "ags/gtk4/app"
import { For, This, createBinding, onCleanup } from "ags"

import { Bar } from "./Bar.tsx"

export function Windows() {
  const monitors = createBinding(app, "monitors");

  return <For each={monitors}>
      {(monitor) => <This this={app}>
        <Bar
          visible
          gdkmonitor={monitor}
          $={(self) => onCleanup(() => self.destroy())}
        />
      </This>}
    </For>
}
