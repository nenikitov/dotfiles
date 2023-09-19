use std::collections::HashMap;

use super::{linicon::IconResolverLinicon, IconFallback};
use crate::resolver::{IconResolved, IconResolver};

pub struct IconResolverException {
    linicon: IconResolverLinicon,
    exceptions: HashMap<String, IconFallback>,
}

impl IconResolverException {
    pub fn new(linicon: IconResolverLinicon, exceptions: HashMap<String, IconFallback>) -> Self {
        Self {
            linicon,
            exceptions,
        }
    }
}

impl IconResolver for IconResolverException {
    fn resolve(&self, name: &str, size: Option<u16>) -> Option<Vec<IconResolved>> {
        let icon = self.exceptions.get(name)?;
        icon.resolve(&self.linicon, size)
    }
}
