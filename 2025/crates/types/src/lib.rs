pub use color_eyre::Result;

pub mod build_lib;

#[cfg(test)]
mod serde_tests;

pub mod codegen {
    include!(concat!(env!("OUT_DIR"), "/codegen.rs"));
}

pub trait Destination {
    const ID: u8;
    const NAME: &'static str;
    type Types;
}

pub trait Type {
    const ID: u8;
    const NAME: &'static str;
    const REPLY_TO: Option<&'static str>;
}

pub trait SerDe {
    fn serialise(&self, buf: &mut [u8]) -> Result<usize>;
    fn deserialise(buf: &[u8]) -> Result<Self>
    where
        Self: std::marker::Sized;
}

#[derive(Copy, Clone, Debug, PartialEq, Eq)]
pub struct Header {
    pub destination: u8,
    pub ty: u8,
    pub len: u16,
}

impl From<[u8; 4]> for Header {
    fn from([destination, ty, len_hi, len_lo]: [u8; 4]) -> Self {
        Self {
            destination,
            ty,
            len: u16::from_be_bytes([len_hi, len_lo]),
        }
    }
}

impl From<Header> for [u8; 4] {
    fn from(
        Header {
            destination,
            ty,
            len,
        }: Header,
    ) -> [u8; 4] {
        let [len_hi, len_lo] = len.to_be_bytes();
        [destination, ty, len_hi, len_lo]
    }
}
