mod args;
mod resolver;

use std::collections::HashMap;

use args::Args;
use clap::Parser;
use resolver::default::IconResolverDefault;

use crate::resolver::{
    desktop::IconResolverDesktop,
    exception::IconResolverException,
    linicon::IconResolverLinicon,
    resolver::{IconCollection, IconResolver, Theme},
};

fn main() {
    let args = Args::parse();

    let resolvers: [Box<dyn IconResolver>; 4] = {
        let linicon = IconResolverLinicon::default();
        [
            Box::new(IconResolverException::new(linicon, {
                let m: HashMap<String, String> = HashMap::new();
                // TODO: Add exceptions here
                m
            })),
            Box::new(linicon),
            Box::new(IconResolverDesktop::new(linicon)),
            Box::new(IconResolverDefault::new(
                linicon,
                vec![
                    String::from("application-default-icon"),
                    String::from("default-application"),
                    String::from("document"),
                    String::from("folder"),
                ],
            )),
        ]
    };

    println!(
        "{:#?}",
        IconResolverLinicon::default()
            .resolve(&args.names[0], None)
            .unwrap()
            .order_by_theme_preference(
                vec![
                    Theme::UserSelected,
                    Theme::Custom("Fluent-dark".to_string()),
                    Theme::Any
                ],
                String::from("Fluent-dark"),
            )
    )
}
