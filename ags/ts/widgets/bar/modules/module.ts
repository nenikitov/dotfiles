import { App, Gtk, Service, Widget } from "prelude";
import { treatClassNames } from "ts/utils/widget";
import { Connectable, type Binding } from "types/service";
import { type Button } from "types/widgets/button";

export interface ModuleConfig {
  vertical: boolean;
  class?: string;
}

export interface ModuleProps {
  child: Gtk.Widget;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any -- We don't care about how the binding is set up, we just care about the return
  tooltip?: string | Binding<any, any, string> | [Connectable, () => string];
  window?: string;
  className?: string | string[];
}

export function Module(props: ModuleProps): Gtk.Widget {
  const classNames = ["panel-button", ...treatClassNames(props.className)];
  return Widget.Button({
    child: props.child,
    classNames,
    tooltipMarkup: props.tooltip && !Array.isArray(props.tooltip) ? props.tooltip : null,
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

      if (props.tooltip && Array.isArray(props.tooltip)) {
        const [service, callback] = props.tooltip;
        self.hook(service, (self) => {
          self.tooltip_markup = callback();
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
