mod args;
mod resolver;

use std::collections::HashMap;

use clap::Parser;
use resolver::default::IconResolverDefault;

use args::Args;
use resolver::{
    desktop::IconResolverDesktop,
    exception::IconResolverException,
    linicon::IconResolverLinicon,
    resolver::{IconCollection, IconResolver},
};

fn main() {
    let args = Args::parse();

    let resolvers: Vec<Box<dyn IconResolver>> = {
        let linicon = IconResolverLinicon::default();
        vec![
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

    let current = linicon::get_system_theme().unwrap_or(String::from("hicolor"));
    let icons: HashMap<_, _> = args
        .names
        .into_iter()
        .map(|n| {
            for r in &resolvers {
                let icons = r
                    .resolve(&n, args.size)
                    .map(|i| i.order_by_theme_preference(&args.themes, &current));
                if let Some(icons) = icons {
                    if icons.len() > 0 {
                        return (n, icons[0].path.clone());
                    }
                }
            }
            unreachable!("Will be resolved by the default resolver");
        })
        .collect();

    println!(
        "{}",
        serde_json::to_string(&icons).expect("Will always produce valid JSON")
    );
}
