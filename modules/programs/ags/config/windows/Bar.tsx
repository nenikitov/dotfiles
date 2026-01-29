import Astal from "gi://Astal?version=4.0"
import app from "ags/gtk4/app"

export function Bar(props) {
  return (
    <window
      visible
      namespace="bar"
      name={`bar-${props.gdkmonitor.connector}`}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      layer={Astal.Layer.TOP}
      anchor={Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT}
      application={app}
      $={props.$}
      gdkmonitor={props.gdkmonitor}
    >
      <label label="Hello" />
    </window>
  )
}
