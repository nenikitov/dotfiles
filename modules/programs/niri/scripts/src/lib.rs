use niri_ipc::{Request, Response, socket::Socket};
use std::io;

pub trait SocketExt {
    fn send_anyhow(&mut self, request: Request) -> io::Result<Result<Response, anyhow::Error>>;
}

impl SocketExt for Socket {
    fn send_anyhow(&mut self, request: Request) -> io::Result<Result<Response, anyhow::Error>> {
        Ok(self.send(request)?.map_err(anyhow::Error::msg))
    }
}
