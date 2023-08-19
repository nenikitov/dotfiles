use walkdir::{WalkDir, DirEntry};

use super::resolver::{Icon, IconResolver};
use std::{env, fs::FileType, path::PathBuf};

pub struct IconResolverDesktop {}

impl IconResolverDesktop {
    fn get_path_variables(key: &str, default: &str) -> Vec<PathBuf> {
        env::var(key)
            .unwrap_or(String::from(default))
            .split(":")
            .map(|p| shellexpand::tilde(p).into_owned())
            .map(PathBuf::from)
            .collect()
    }
}

impl IconResolver for IconResolverDesktop {
    fn resolve(name: &str, size: Option<u16>) -> Option<Vec<Icon>> {
        // User applications
        let mut dirs: Vec<_> =
            Self::get_path_variables("XDG_DATA_HOME", "/usr/local/share/:/usr/share/")
                .into_iter()
                .map(|p| p.join("applications"))
                .collect();
        // User desktop
        dirs.append(
            &mut Self::get_path_variables("XDG_DESKTOP_DIR", "~/Desktop")
                .into_iter()
                .collect(),
        );
        // Global applications
        dirs.append(
            &mut Self::get_path_variables("XDG_DATA_DIRS", "/usr/local/share/:/usr/share/")
                .into_iter()
                .map(|p| p.join("applications"))
                .collect());

        for dir in dirs {
            for entry in WalkDir::new(dir)
                .follow_links(true)
                .into_iter()
                .filter_map(|e| e.ok())
            {
                let file_name = entry.file_name().to_string_lossy();
            }
        }

        None
    }
}
