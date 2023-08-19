mod args;
mod resolver;

use args::Args;
use clap::Parser;

use crate::resolver::{
    linicon::IconResolverLinicon,
    resolver::{IconCollection, IconResolver, Theme},
};

fn main() {
    let args = Args::parse();
    println!(
        "{:#?}",
        IconResolverLinicon::resolve(&args.names[0], args.size)
            .unwrap()
            .order_by_theme_preference(
                vec![
                    Theme::Any,
                ],
                String::from("Fluent-dark")
            )
    );
}
