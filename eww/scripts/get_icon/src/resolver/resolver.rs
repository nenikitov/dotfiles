use std::{cmp::Ordering, collections::HashSet, fmt::Display, path::PathBuf};

use crate::args::Args;

#[derive(Debug, Clone)]
pub enum Theme {
    UserSelected,
    Custom(String),
    Any,
}

#[derive(Debug, PartialEq, Eq, Clone)]
pub struct Icon {
    pub path: PathBuf,
    pub theme: String,
    pub scalable: bool,
    pub size: (u16, u16),
}

impl PartialOrd for Icon {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        match (self.scalable, other.scalable) {
            (true, false) => Some(Ordering::Greater),
            (false, true) => Some(Ordering::Less),
            _ => other.size.1.partial_cmp(&self.size.1),
        }
    }
}

impl Ord for Icon {
    fn cmp(&self, other: &Self) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

impl IconCollection for Vec<Icon> {
    fn group_by_theme(self) -> Vec<(String, Self)> {
        let mut themes: Vec<(String, Self)> = Vec::new();
        let mut theme_current: Self = Vec::new();
        let mut theme_current_name = String::from("");

        for icon in self {
            if theme_current_name != icon.theme {
                theme_current.sort();
                themes.push((theme_current_name.clone(), theme_current));

                theme_current = Vec::new();
                theme_current_name = icon.theme.to_string();
            }
            theme_current.push(icon);
        }

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

    fn order_by_theme_preference(self, themes: Vec<Theme>, current: String) -> Self {
        let grouped = self.group_by_theme();
        let mut icons: Self = Vec::new();
        let mut used_theme_names: HashSet<String> = HashSet::new();

        let mut append_with_theme = |theme: String| {
            if !used_theme_names.contains(&theme) {
                used_theme_names.insert(theme.clone());
                let mut to_add: Self = grouped
                    .iter()
                    .filter(|i| i.0 == theme)
                    .map(|i| i.1.clone())
                    .flatten()
                    .collect();
                icons.append(&mut to_add);
            }
        };

        for theme in themes {
            match theme {
                Theme::UserSelected => append_with_theme(current.clone()),
                Theme::Custom(name) => append_with_theme(name),
                Theme::Any => {
                    let theme_names: HashSet<String> =
                        grouped.iter().map(|i| i.0.clone()).collect();
                    let theme_names = theme_names.difference(&theme_names);
                    for t in theme_names {
                        append_with_theme(t.clone())
                    }
                }
            }
        }

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

pub trait IconResolver {
    fn resolve(name: &str, size: Option<u16>) -> Option<Vec<Icon>>;
}

pub trait IconCollection {
    fn group_by_theme(self) -> Vec<(String, Vec<Icon>)>;
    fn order_by_theme(self) -> Self;
    fn order_by_theme_preference(self, themes: Vec<Theme>, current: String) -> Self;
}
