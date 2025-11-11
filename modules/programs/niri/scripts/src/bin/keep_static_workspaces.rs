use clap::Parser;
use niri_ipc::{Action, Event, Request, Response, WorkspaceReferenceArg, socket::Socket};
use uuid::Uuid;

use niri_scripts::SocketExt;

/// Keep a certain amount of workspaces on all monitors.
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// Minimal number of named workspaces to create on each monitor.
    count: u8,
}

fn try_main() -> anyhow::Result<()> {
    let args = Args::parse();
    let mut socket_events = Socket::connect()?;
    let mut socket_actions = Socket::connect()?;

    let reply = socket_events.send_anyhow(Request::EventStream)?;
    if matches!(reply, Ok(Response::Handled)) {
        let mut read_event = socket_events.read_events();
        while let Ok(event) = read_event() {
            if let Event::WorkspacesChanged { workspaces } = event {
                // Get focused monitor
                let output_focused = if let Response::FocusedOutput(output) =
                    socket_actions.send_anyhow(Request::FocusedOutput)??
                {
                    output.map(|o| o.name)
                } else {
                    unreachable!("returns always focused output response")
                };

                // Find workspace to rename
                let to_rename = if let Some(workspace) = workspaces
                    .into_iter()
                    .filter(|w| w.name.is_none() && w.idx <= args.count)
                    .min_by(|a, b| a.output.cmp(&b.output).then(a.id.cmp(&b.id)))
                {
                    workspace
                } else {
                    continue;
                };

                // HACK: Niri does not generate unnamed workspaces on unfocused monitors.
                // So, since new unnamed workspaces won't be added, the script will not be able to rename them.
                // Thus, we need to focus the monitor we'll be populating.

                // Focus monitor it is on
                if output_focused != to_rename.output
                    && let Some(ref output) = to_rename.output
                {
                    socket_actions.send_anyhow(Request::Action(Action::FocusMonitor {
                        output: output.clone(),
                    }))??;
                }

                // Rename
                socket_actions.send_anyhow(Request::Action(Action::SetWorkspaceName {
                    name: format!("_static_{}", Uuid::new_v4().simple()),
                    workspace: Some(WorkspaceReferenceArg::Id(to_rename.id)),
                }))??;

                // Focus back the previous monitor
                if output_focused != to_rename.output
                    && let Some(ref output) = output_focused
                {
                    socket_actions.send_anyhow(Request::Action(Action::FocusMonitor {
                        output: output.clone(),
                    }))??;
                }
            }
        }
    }

    Ok(())
}

fn main() {
    if let Err(e) = try_main() {
        eprintln!("Error: {e}");
        std::process::exit(1)
    }
}
