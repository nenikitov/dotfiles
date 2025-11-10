use clap::Parser;
use niri_ipc::{Action, Event, Request, Response, WorkspaceReferenceArg, socket::Socket};
use std::{
    collections::BTreeSet,
    sync::{Arc, Condvar, Mutex},
};

use niri_scripts::SocketExt;

/// Keep a certain amount of workspaces on all monitors.
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// Minimal number of named workspaces to create on each monitor.
    count: u8,
}

#[derive(Debug, Eq, Hash, PartialOrd, PartialEq)]
struct WorkspaceToRename {
    id: u64,
    index: u8,
    output: String,
}

impl Ord for WorkspaceToRename {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.output
            .cmp(&other.output)
            .then(self.index.cmp(&other.index))
    }
}

fn try_main() -> anyhow::Result<()> {
    let args = Args::parse();
    let mut socket_events = Socket::connect()?;

    let rename_queue = Arc::new(Mutex::new(BTreeSet::<WorkspaceToRename>::new()));
    let rename_queue_not_empty = Condvar::new();

    //fn new_uuid = || { uuid::Uuid::new_v4().simple().to_string() };

    let reply = socket_events.send_anyhow(Request::EventStream)?;
    if matches!(reply, Ok(Response::Handled)) {
        let mut read_event = socket_events.read_events();
        while let Ok(event) = read_event() {
            if let Event::WorkspacesChanged { workspaces } = event {
                let needs_renaming = workspaces
                    .into_iter()
                    .filter(|w| w.name.as_ref().map_or(true, |n| n.starts_with("_static")))
                    .filter_map(|w| {
                        Some(WorkspaceToRename {
                            id: w.id,
                            index: w.idx,
                            output: w.output?,
                        })
                    })
                    .collect::<Vec<_>>();
                println!("Received workspaces: {needs_renaming:#?}");
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
