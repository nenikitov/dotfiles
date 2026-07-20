use clap::Parser;
use niri_ipc::{Action, PositionChange, Request, Response, socket::Socket};

use niri_scripts::SocketExt;

/// Move windows based on floating status.
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// Command to use if the window is tiled.
    #[command(subcommand)]
    command: Action,

    /// X distance to move the floating window.
    #[arg(
        short,
        long,
        global = true,
        allow_hyphen_values = true,
        default_value = "+0"
    )]
    x: PositionChange,
    /// Y distance to move the floating window.
    #[arg(
        short,
        long,
        global = true,
        allow_hyphen_values = true,
        default_value = "+0"
    )]
    y: PositionChange,
}

fn try_main() -> anyhow::Result<()> {
    let args = Args::parse();
    let mut socket = Socket::connect()?;

    let window = socket.send_anyhow(Request::FocusedWindow)??;
    let window = if let Response::FocusedWindow(Some(window)) = window {
        window
    } else {
        return Ok(());
    };

    if window.is_floating {
        socket.send_anyhow(Request::Action(Action::MoveFloatingWindow {
            id: Some(window.id),
            x: args.x,
            y: args.y,
        }))??;
    } else {
        socket.send_anyhow(Request::Action(args.command))??;
    }
    Ok(())
}

fn main() {
    if let Err(e) = try_main() {
        eprintln!("Error: {e}");
        std::process::exit(1)
    }
}
