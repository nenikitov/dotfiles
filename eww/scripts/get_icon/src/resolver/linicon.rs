use linicon::{IconPath, IconType};

use super::resolver::{Icon, IconResolver};

impl Into<Icon> for IconPath {
    fn into(self) -> Icon {
        Icon {
            path: self.path,
            theme: self.theme,
            scalable: self.icon_type == IconType::SVG,
            size: (self.min_size, self.max_size),
        }
    }
}

#[derive(Default, Clone, Copy)]
pub struct IconResolverLinicon {}

impl IconResolver for IconResolverLinicon {
    fn resolve(&self, name: &str, size: Option<u16>) -> Option<Vec<Icon>> {
        let icons: Vec<_> = linicon::themes()
            .into_iter()
            .map(|t| {
                let mut icons = linicon::lookup_icon(name)
                    .from_theme(t.name)
                    .use_fallback_themes(false);
                if let Some(size) = size {
                    icons = icons.with_size(size);
                }
                let icons: Vec<_> = icons.collect::<Result<_, _>>().ok()?;
                let icons: Vec<Icon> = icons.into_iter().map(|i| i.into()).collect();
                Some(icons)
            })
            .flat_map(|i| i)
            .flatten()
            .collect();

        Some(icons)
    }
}
