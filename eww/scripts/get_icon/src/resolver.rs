pub mod desktop;
pub mod exception;
pub mod fallback;
pub mod linicon;

use std::{cmp::Ordering, collections::HashSet, env::current_exe, fmt::Display, path::PathBuf};

use serde::{Deserialize, Serialize};

use self::linicon::IconResolverLinicon;

#[derive(Debug, Clone)]
pub enum Theme {
    UserSelected,
    Custom(String),
    Any,
}

#[derive(Debug, PartialEq, Eq, Clone, Ord, Serialize, Deserialize)]
pub struct IconResolved {
    pub path: PathBuf,
    pub theme: Option<String>,
    pub scalable: bool,
    pub size: (u16, u16),
}
impl IconResolved {
    fn new_local(path: &PathBuf) -> Self {
        let path = if path.is_absolute() {
            path.clone()
        } else {
            PathBuf::from(current_exe().expect("Executable path should be valid")).join(path)
        };

        Self {
            path,
            theme: None,
            scalable: false,
            size: (1, 1),
        }
    }
}

#[derive(Debug)]
pub enum IconFallback {
    Theme(String),
    Local(PathBuf),
}
impl IconFallback {
    fn resolve(
        &self,
        linicon: &IconResolverLinicon,
        size: Option<u16>,
    ) -> Option<Vec<IconResolved>> {
        match self {
            IconFallback::Theme(name) => linicon.resolve(name, size),
            IconFallback::Local(path) => Some(vec![IconResolved::new_local(path)]),
        }
    }
}

impl PartialOrd for IconResolved {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        match (self.scalable, other.scalable) {
            (true, false) => Some(Ordering::Less),
            (false, true) => Some(Ordering::Greater),
            _ => other.size.0.partial_cmp(&self.size.0),
        }
    }
}

pub trait IconCollection {
    fn group_by_theme(self) -> Vec<(Option<String>, Vec<IconResolved>)>;
    fn order_by_theme(self) -> Self;
    fn order_by_theme_preference(self, themes: &Vec<Theme>, current: &String) -> Self;
}

pub trait IconResolver {
    fn resolve(&self, name: &str, size: Option<u16>) -> Option<Vec<IconResolved>>;
}

impl IconCollection for Vec<IconResolved> {
    fn group_by_theme(self) -> Vec<(Option<String>, Self)> {
        let mut themes: Vec<(Option<String>, Self)> = Vec::new();
        let mut theme_current: Self = Vec::new();
        let mut theme_current_name = Some(String::from(""));

        for icon in self {
            if theme_current_name != icon.theme {
                theme_current.sort();

                if !theme_current.is_empty() {
                    themes.push((theme_current_name.clone(), theme_current));
                    theme_current = Vec::new();
                }
                theme_current_name = icon.theme.clone();
            }
            theme_current.push(icon);
        }

        theme_current.sort();
        themes.push((theme_current_name.clone(), theme_current));

        themes
    }

    fn order_by_theme(self) -> Self {
        self.group_by_theme()
            .into_iter()
            .map(|i| i.1)
            .flatten()
            .collect()
    }

    fn order_by_theme_preference(self, themes: &Vec<Theme>, current: &String) -> Self {
        let grouped = self.group_by_theme();
        let mut icons: Self = Vec::new();
        let mut used_theme_names: HashSet<String> = HashSet::new();

        let mut append_with_theme = |theme: Option<String>| {
            let theme = if let Some(theme) = theme {
                theme
            } else {
                return;
            };
            if !used_theme_names.contains(&theme) {
                used_theme_names.insert(theme.clone());
                let mut to_add: Self = grouped
                    .iter()
                    .filter(|i| i.0 == None || i.0 == Some(theme.clone()))
                    .map(|i| i.1.clone())
                    .flatten()
                    .collect();
                icons.append(&mut to_add);
            }
        };

        for theme in themes {
            match theme {
                Theme::UserSelected => append_with_theme(Some(current.clone())),
                Theme::Custom(name) => append_with_theme(Some(name.clone())),
                Theme::Any => {
                    let theme_names: HashSet<String> =
                        grouped.iter().filter_map(|i| i.0.clone()).map(|i| i.clone()).collect();
                    for t in theme_names {
                        append_with_theme(Some(t.clone()))
                    }
                }
            }
        }
        append_with_theme(None);

        icons
    }
}

impl Display for Theme {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Theme::UserSelected => "User selected",
                Theme::Custom(_) => "Named theme",
                Theme::Any => "Any other theme",
            }
        )
    }
}
