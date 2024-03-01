import { Gtk, Widget, Service, Utils } from "prelude";
import { Audio, type Stream } from "types/service/audio";

export interface VolumeConfig {
  format: (() => string) | false;
  icon: boolean;
  formatTooltip: (speaker: Stream) => string;
}

const configDefault: VolumeConfig = {
  format: false,
  icon: false,
  formatTooltip: function (): string {
    return "";
  },
};

const icons: [number, string][] = [
  [1.01, "audio-volume-overamplified-symbolic"],
  [0.67, "audio-volume-high-symbolic"],
  [0.33, "audio-volume-medium-symbolic"],
  [0.1, "audio-volume-low-symbolic"],
  [0.0, "audio-volume-muted-symbolic"],
];

export function Volume(configPartial: Partial<VolumeConfig>): (monitor: number) => Gtk.Widget {
  return (_) => {
    const config = Object.assign({}, configDefault, configPartial);

    return Widget.Box({
      className: "volume",
      children: [
        Widget.Icon({
          setup: (self) => {
            self.hook(Service.Audio, (self) => {
              const speaker = Service.Audio.speaker;
              self.icon = speaker.stream?.is_muted
                ? "audio-volume-muted-symbolic"
                : icons.find(([volume]) => volume <= speaker.volume)?.[1] ?? "";
            });
          },
        }),
        Widget.Label({}),
      ],
      visible: Service.Audio.bind("speakers").as((s) => s.length > 0),
      setup: (self) => {
        self.hook(
          Service.Audio.speaker,
          (self) => (self.tooltip_markup = config.formatTooltip(Service.Audio.speaker))
        );
      },
    });
  };
}
