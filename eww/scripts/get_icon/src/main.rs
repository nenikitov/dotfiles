mod args;
mod resolver;

use std::fs;

use args::Args;
use clap::Parser;
use freedesktop_desktop_entry::{default_paths, DesktopEntry, Iter, PathSource};

use crate::resolver::{
    linicon::IconResolverLinicon,
    resolver::{IconCollection, IconResolver, Theme}, desktop::IconResolverDesktop,
};

fn main() {
    let args = Args::parse();
    println!(
        "{:#?}",
        IconResolverDesktop::resolve(&args.names[0], args.size)
            .unwrap()
            .order_by_theme_preference(
                vec![
                    Theme::Any,
                ],
                String::from("Fluent-dark")
            )
    );
}
