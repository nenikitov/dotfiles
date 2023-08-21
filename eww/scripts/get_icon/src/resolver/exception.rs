use std::collections::HashMap;

use super::{
    linicon::IconResolverLinicon,
    resolver::{Icon, IconResolver},
};

pub struct IconResolverException {
    linicon: IconResolverLinicon,
    exceptions: HashMap<String, String>,
}

impl IconResolverException {
    pub fn new(linicon: IconResolverLinicon, exceptions: HashMap<String, String>) -> Self {
        Self {
            linicon,
            exceptions,
        }
    }
}

impl IconResolver for IconResolverException {
    fn resolve(&self, name: &str, size: Option<u16>) -> Option<Vec<Icon>> {
        let icon = self.exceptions.get(name)?;
        self.linicon.resolve(icon, size)
    }
}
