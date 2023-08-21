mod args;
mod resolver;

use std::fs;

use args::Args;
use clap::Parser;
use freedesktop_desktop_entry::{default_paths, DesktopEntry, Iter, PathSource};

use crate::resolver::{
    desktop::IconResolverDesktop,
    linicon::IconResolverLinicon,
    resolver::{IconCollection, IconResolver, Theme},
};

fn main() {
    let args = Args::parse();
    let icons = IconResolverDesktop::resolve(&args.names[0], args.size)
        .unwrap()
        .order_by_theme_preference(
            vec![Theme::UserSelected, Theme::Any],
            String::from("Fluent-dark"),
        );
    println!("{icons:#?}");
}
