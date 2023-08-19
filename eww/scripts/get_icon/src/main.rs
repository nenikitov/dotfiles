mod args;
mod resolver;

use args::Args;
use clap::Parser;

use crate::resolver::{linicon::IconResolverLinicon, resolver::IconResolver};

fn main() {
    let args = Args::parse();
    println!(
        "{:#?}",
        IconResolverLinicon::resolve(&args.names[0], args.size)
    );
}
