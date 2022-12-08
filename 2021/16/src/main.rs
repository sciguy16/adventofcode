#![allow(unused)]

use bitvec::prelude::*;
use std::str::FromStr;

#[derive(Debug, PartialEq, Eq)]
struct Packet {
    version: u8,
    type_id: u8,
    length: usize,
    inner: PacketInner,
}

#[derive(Debug, PartialEq, Eq)]
enum PacketInner {
    Literal(u64),
    SubPackets(Vec<Packet>),
}

#[derive(Debug, PartialEq, Eq)]
enum LengthType {
    NumBits(usize),
    NumSubpackets(usize),
}

impl FromStr for Packet {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // iterate over bits
        let bytes = s
            .chars()
            .collect::<Vec<_>>()
            .chunks(2)
            .map(|b| {
                u8::from_str_radix(&format!("{}{}", b[0], b[1]), 16).unwrap()
            })
            .collect::<Vec<_>>();
        let bv = bytes.view_bits::<Msb0>();
        Ok(Packet::from(bv))
    }
}

impl From<&BitSlice<u8, Msb0>> for Packet {
    fn from(bv: &BitSlice<u8, Msb0>) -> Packet {
        let version = bv[0..3].load::<u8>();
        let type_id = bv[3..6].load::<u8>();
        #[cfg(debug_assertions)]
        println!("bv: {bv}\nversion {version}, type {type_id}");
        let mut length = 0;
        let inner = match type_id {
            4 => {
                let mut lit = 0;
                let mut pos: usize = 0;
                const OFFSET: usize = 6;
                loop {
                    lit <<= 4;
                    lit |= bv[OFFSET + pos * 5 + 1..OFFSET + pos * 5 + 1 + 4]
                        .load_be::<u8>() as u64;
                    #[cfg(debug_assertions)]
                    println!(
                        "[{}] slice: {}, lit: {:b}",
                        pos,
                        &bv[OFFSET + pos * 5..OFFSET + pos * 5 + 1 + 4],
                        lit
                    );
                    if !bv[OFFSET + pos * 5] {
                        break;
                    }
                    pos += 1;
                }
                length = OFFSET + pos * 5 + 1 + 4;
                println!("LITERAL PACKET: {lit}");
                PacketInner::Literal(lit)
            }
            _ => {
                println!("[subpackets]");
                let mut subpackets = Vec::new();
                match bv[6] {
                    false => {
                        // next 15 bits are total length in bits of the subpackets
                        let end = 7 + 15;
                        let num_bits: usize = bv[7..end].load_be();
                        println!("[loading {num_bits} bits]");
                        length = end + num_bits;
                        let mut pos = end;
                        while pos < end + num_bits {
                            let next_packet = Packet::from(&bv[pos..]);
                            pos += next_packet.length;
                            subpackets.push(next_packet);
                        }
                    }
                    true => {
                        // next 11 bits are number of subpackets
                        let end = 7 + 11;
                        let num_subpackets: usize = bv[7..end].load_be();
                        println!("[loading {num_subpackets} subpackets]");
                        let mut pos: usize = end;
                        for _ in 0..num_subpackets {
                            let next_packet = Packet::from(&bv[pos..]);
                            pos += next_packet.length;
                            subpackets.push(next_packet);
                        }
                    }
                }
                println!("CONTAINER SUBPACKET, LEN {}", subpackets.len());
                PacketInner::SubPackets(subpackets)
            }
        };
        Packet {
            version,
            type_id,
            length,
            inner,
        }
    }
}

impl Packet {
    pub fn version_sum(&self) -> usize {
        let mut sum = self.version as usize;
        println!("ADDING VERSION {}", self.version);
        if let PacketInner::SubPackets(sub) = &self.inner {
            sum += sub.iter().map(|p| p.version_sum()).sum::<usize>();
        }
        sum
    }
}

fn part_one(packet: &Packet) -> usize {
    // add up all of the version numbers
    packet.version_sum()
}

fn part_two(packet: &Packet) -> usize {
    todo!()
}

fn main() {
    let input = include_str!("../input.txt");
    let data = input.parse().unwrap();
    let ans = part_one(&data);
    println!("part one: {ans}");
    let ans = part_two(&data);
    println!("part two: {ans}");
}

#[cfg(test)]
mod test {
    use super::*;

    const TEST_DATA: &str = r#"D2FE28"#;

    const CASES: &[(&str, usize)] = &[
        ("8A004A801A8002F478", 16),
        ("620080001611562C8802118E34", 12),
        ("C0015000016115A2E0802F182340", 23),
        ("A0016C880162017C3686B18A3D4780", 31),
    ];

    #[test]
    fn load_test_case_1() {
        let packet: Packet = TEST_DATA.parse().unwrap();
        assert_eq!(
            packet,
            Packet {
                version: 6,
                type_id: 4,
                length: 21,
                inner: PacketInner::Literal(2021)
            }
        );
    }

    #[test]
    fn load_operator_1() {
        let packet: Packet = "38006F45291200".parse().unwrap();
        assert_eq!(
            packet,
            Packet {
                version: 1,
                type_id: 6,
                length: 49,
                inner: PacketInner::SubPackets(vec![
                    Packet {
                        version: 3,
                        type_id: 4,
                        length: 11,
                        inner: PacketInner::Literal(10)
                    },
                    Packet {
                        version: 2,
                        type_id: 4,
                        length: 16,
                        inner: PacketInner::Literal(20)
                    }
                ]),
            }
        );
    }

    #[test]
    fn load_operator_2() {
        let packet: Packet = "EE00D40C823060".parse().unwrap();
        let PacketInner::SubPackets(v) = packet.inner else { panic!()};

        assert_eq!(v.len(), 3);
    }

    #[test]
    fn test_part_1() {
        for (packet, expected) in CASES {
            println!("CASE {packet}: {expected}");
            let packet = packet.parse().unwrap();
            let ans = part_one(&packet);
            assert_eq!(ans, *expected);
        }
    }

    //#[test]
    fn test_part_2() {
        for (packet, expected) in CASES {
            let packet = packet.parse().unwrap();
            let ans = part_two(&packet);
            assert_eq!(ans, *expected);
        }
    }
}
