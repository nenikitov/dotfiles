use super::{
    linicon::IconResolverLinicon,
    resolver::{Icon, IconResolver},
};

pub struct IconResolverDefault {
    linicon: IconResolverLinicon,
    icons: Vec<String>,
}

impl IconResolverDefault {
    pub fn new(linicon: IconResolverLinicon, icons: Vec<String>) -> Self {
        Self { linicon, icons }
    }
}

impl IconResolver for IconResolverDefault {
    fn resolve(&self, _: &str, size: Option<u16>) -> Option<Vec<Icon>> {
        for icon in &self.icons {
            if let Some(icon) = self.linicon.resolve(&icon, size) {
                return Some(icon);
            }
        }
        return None;
    }
}
