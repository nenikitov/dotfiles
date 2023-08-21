use clap::Parser;

use crate::resolver::resolver::Theme;

/// Tool to look up icons for applications
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub struct Args {
    /// Names of the applications to look up icons from
    #[arg(required = true)]
    pub names: Vec<String>,

    /// Preferred sizes of the icons
    #[arg(long, short = 's')]
    pub size: Option<u16>,

    /// Theme priority (comma separated) [possible values: <USER-SELECTED> <ANY> or theme name ("hicolor", etc)]
    #[arg(long, short = 't', value_parser = theme_parser, value_delimiter = ',', default_value = "<USER-SELECTED>,<ANY>")]
    pub themes: Vec<Theme>,
}

fn theme_parser(s: &str) -> Result<Theme, String> {
    Ok(match s {
        "<USER-SELECTED>" => Theme::UserSelected,
        "<ANY>" => Theme::Any,
        _ => Theme::Custom(s.to_string())
    })
}
