#[doc = "Top-level packets, e.g. ping/pong"]
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Top {}
impl crate::Destination for Top {
    const ID: u8 = 0;
    const NAME: &'static str = "top";
    type Types = top::Types;
}
pub mod top {
    #[derive(Clone, Debug, PartialEq, Eq)]
    pub struct Ping {
        pub data: u32,
    }

    impl crate::Type for Ping {
        const ID: u8 = 0;
        const NAME: &str = "ping";
        const REPLY_TO: Option<&str> = None;
    }

    impl crate::SerDe for Ping {
        fn serialise(&self, buf: &mut [u8]) -> crate::Result<usize> {
            use std::io::Write;
            let mut cur = std::io::Cursor::new(buf);
            cur.write_all(&self.data.to_be_bytes())?;

            Ok(cur.position().try_into()?)
        }

        fn deserialise(buf: &[u8]) -> crate::Result<Self> {
            use std::io::Read;
            let mut cur = std::io::Cursor::new(buf);
            let mut data = 0_u32.to_be_bytes();
            cur.read_exact(&mut data)?;
            let data = u32::from_be_bytes(data);
            Ok(Self { data })
        }
    }

    pub enum Types {
        Ping(Ping),
    }
}
