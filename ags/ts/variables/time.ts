import { GLib, Variable } from "prelude";
import { seconds } from "ts/utils/time";

function getTime() {
  return GLib.DateTime.new_now_local();
}

export const time = Variable(getTime(), {
  poll: [seconds(1), () => getTime()],
});
