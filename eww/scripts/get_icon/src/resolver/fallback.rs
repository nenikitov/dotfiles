use super::{linicon::IconResolverLinicon, IconFallback};
use crate::resolver::{IconResolved, IconResolver};

pub struct IconResolverFallback {
    linicon: IconResolverLinicon,
    icons: Vec<IconFallback>,
}

impl IconResolverFallback {
    pub fn new(linicon: IconResolverLinicon, icons: Vec<IconFallback>) -> Self {
        Self { linicon, icons }
    }
}

impl IconResolver for IconResolverFallback {
    fn resolve(&self, _: &str, size: Option<u16>) -> Option<Vec<IconResolved>> {
        let icons: Option<Vec<_>> = self
            .icons
            .iter()
            .map(|i| {
                i.resolve(&self.linicon, size)
            })
            .collect();
        let icons = icons?;
        let icons = Some(icons.into_iter().flatten().collect());
        icons
    }
}
