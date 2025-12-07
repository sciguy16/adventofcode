## Packet format
Packets are multiples of 32 bits in length, with the first 32-bit word
being the packet header and the last a CRC32

| byte index |  0          |  1   |  2            |  3           |
| Header     | Destination | Type | Length (15:8) | Length (7:0) |
| Data       | ...         | ...  | ...           | ...          |
| CRC32      | CRC         | CRC  | CRC           | CRC          |

Packet IDs are defined in `packetdefs.yaml`, from which VHDL constants and
Rust types are generated. Run `make vhdl-autogen` to regenerate the constants.
