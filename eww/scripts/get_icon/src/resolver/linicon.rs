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

pub struct IconResolverLinicon {}

impl IconResolver for IconResolverLinicon {
    fn resolve(name: &str, size: Option<u16>) -> Option<Vec<Icon>> {
        let mut icons = linicon::lookup_icon(name);

        if let Some(size) = size {
            icons = icons.with_size(size);
        }
        let icons: Vec<_> = icons.collect::<Result<_, _>>().ok()?;

        Some(icons.into_iter().map(|i| i.into()).collect())
    }
}
