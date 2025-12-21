use crate::{codegen::top::Ping, SerDe};
use hex_literal::hex;

#[track_caller]
fn assert_eq_hex(left: impl AsRef<[u8]>, right: impl AsRef<[u8]>) {
    let left = hex::encode(left);
    let right = hex::encode(right);
    assert_eq!(left, right);
}

#[test]
fn ping_roundtrip() {
    let ping = Ping { data: 0x12345678 };
    let mut buf = [0; 1024];
    let len = ping.serialise(&mut buf).unwrap();
    assert_eq_hex(&buf[..len], hex!("12345678"));
    let parsed = Ping::deserialise(&buf[..len]).unwrap();
    assert_eq!(ping, parsed);
}

#[test]
fn ping_roundtrip_as_top() {
    use crate::codegen::top::Types;

    let ping: Types = Ping { data: 0x12345678 }.into();
    let mut buf = [0; 1024];
    let len = ping.serialise(&mut buf).unwrap();
    assert_eq_hex(&buf[..len], hex!("00000004 12345678"));
    let parsed = Types::deserialise(&buf[..len]).unwrap();
    assert_eq!(ping, parsed);
}
