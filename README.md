# nimrod-murmur

MurmurHash algorithm in pure nimrod.

## Install

    $ babel install murmur

## Example

```nimrod
import murmur

echo(murmur.hash("digest this text", 0xbadc0ffee'i32))
# => 2419875762
```

## Documentation

### hash(key: string, seed: int32 = 0): uint32

Compute the murmur hash of `key` with seed `seed`.

## Acknowledgements

This module is a port of [murmurhash-js](https://github.com/garycourt/murmurhash-js).
