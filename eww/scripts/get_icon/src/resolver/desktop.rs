use std::{borrow::Cow, cmp::Ordering, fs, path::PathBuf};

use freedesktop_desktop_entry::{default_paths, DesktopEntry, Iter};

use super::{
    linicon::IconResolverLinicon,
    resolver::{Icon, IconResolver},
};

pub struct IconResolverDesktop {}

#[derive(PartialEq, Eq, PartialOrd, Ord)]
enum DesktopSimilarity {
    VagueSubstring,
    StartsEnds,
    Substring,
    Match,
}

impl IconResolverDesktop {
    fn parse_exec(exec: Option<String>) -> Option<String> {
        let exec = exec?;
        let exec = exec
            .split(" ")
            .into_iter()
            .find(|c| !c.trim().is_empty() && !c.contains("="))?;
        Some(String::from(
            PathBuf::from(exec).file_stem()?.to_string_lossy(),
        ))
    }

    fn simplify_string(string: &str) -> String {
        string.replace(" ", "").replace("-", "")
    }

    fn check_entry(name: &str, path: &PathBuf, entry: &DesktopEntry) -> Option<DesktopSimilarity> {
        let info: Vec<_> = vec![
            entry.name(None).map(Cow::into_owned),
            entry.icon().map(String::from),
            Self::parse_exec(entry.exec().map(String::from)),
            entry.startup_wm_class().map(String::from),
            path.file_stem()
                .map(|f| f.to_string_lossy())
                .map(String::from),
        ]
        .into_iter()
        .filter_map(|i| i)
        .map(|i| i.to_lowercase().replace("_", "-"))
        .collect();

        let name = name.to_lowercase();

        if info.contains(&name) {
            Some(DesktopSimilarity::Match)
        } else if info
            .iter()
            .find(|s| s.starts_with(&name) || s.ends_with(&name))
            .is_some()
        {
            Some(DesktopSimilarity::StartsEnds)
        } else if info.iter().find(|i| i.contains(&name)).is_some() {
            Some(DesktopSimilarity::Substring)
        } else if info
            .iter()
            .find(|i| Self::simplify_string(&i).contains(&Self::simplify_string(&name)))
            .is_some()
        {
            Some(DesktopSimilarity::VagueSubstring)
        } else {
            None
        }
    }
}

impl IconResolver for IconResolverDesktop {
    fn resolve(name: &str, size: Option<u16>) -> Option<Vec<Icon>> {
        let icons: Vec<_> = Iter::new(default_paths())
            .filter_map(|path| {
                let entry = fs::read_to_string(&path).ok()?;
                let entry = DesktopEntry::decode(&path, &entry).ok()?;
                let similarity = Self::check_entry(name, &path, &entry);
                Some((similarity, entry.exec().to_owned()))
            })
            .collect();

        todo!();

        // for path in Iter::new(default_paths()) {
        //     if let Ok(bytes) = fs::read_to_string(&path) {
        //         if let Ok(entry) = DesktopEntry::decode(&path, &bytes) {
        //             if Self::check_entry(name, &path, &entry) {
        //                 if let Some(icon) = entry.icon() {
        //                     return IconResolverLinicon::resolve(icon, size);
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}
