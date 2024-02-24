import { App, Gtk, Widget } from "prelude";
import { treatClassNames } from "ts/utils/widget";
import { type Binding } from "types/service";

export interface ModuleConfig {
  vertical: boolean;
  class?: string;
}

export interface ModuleProps {
  child: Gtk.Widget;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any -- We don't care about how the binding is set up, we just care about the return
  tooltip?: "string" | Binding<any, any, string>;
  window?: string;
  className?: string | string[];
}

export function Module(props: ModuleProps): Gtk.Widget {
  const classNames = ["panel-button", ...treatClassNames(props.className)];
  return Widget.Button({
    child: props.child,
    classNames,
    tooltipMarkup: props.tooltip,
    setup: (self) => {
      if (props.window) {
        let open = false;

        self.hook(App, (_, window: string, visible: boolean) => {
          if (window !== props.window) {
            return;
          }

          if (visible) {
            open = true;
            self.toggleClassName("active");
          }

          if (open && !visible) {
            open = false;
            self.toggleClassName("active", false);
          }
        });
      }
    },
    onClicked: () => {
      if (props.window) {
        App.toggleWindow(props.window);
      }
    },
  });
}
