/**
 * @typedef {import("./ags/src/widget.ts").Window} Window
 */

const exampleWindow = Window({
    name: 'Example',
    child: ags.Widget.Label({
        label: 'Hello world'
    })
})

export default {
    closeWindowDelay: {
        'Example': 1000
    },
    notificationPopupTimeout: 5000,
    windows: [
        exampleWindow
    ]
}
