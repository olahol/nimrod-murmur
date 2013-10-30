## Module for computing MurmurHash from strings.

proc charCodeAt(s: string, i: int): int32 =
  return toU32(ord(s[i]) and 0xff)

proc hash*(key: string, seed: int32 = 0): uint32 =
  const
    c1 = 0xcc9e2d51'i32
    c2 = 0x1b873593'i32

  let
    chunks    = (len(key) div 4) - 1
    remainder = len(key) mod 4

  var
    h1   = seed
    h1b  = 0'i32
    k1   = 0'i32

  for n in 0 .. chunks:
    k1 = key.charCodeAt(4*n) or
         (key.charCodeAt(4*n+1) shl 8) or
         (key.charCodeAt(4*n+2) shl 16) or
         (key.charCodeAt(4*n+3) shl 24)

    k1 = (((k1 and 0xffff) *% c1) +%
         ((((k1 shr 16) *% c1) and 0xffff) shl 16))
    k1 = (((k1 shr 16) *% c1) and 0xffff) shl 16'i32
    k1 = (k1 shl 15) or (k1 shr 17)
    k1 = ((k1 and 0xffff) *% c2) +%
         ((((k1 shr 16) *% c2) and 0xffff) shl 16)

    h1 = h1 xor k1
    h1 = (h1 shl 13) or (h1 shr 19)
    h1b = (((h1 and 0xffff) *% 5) +%
          ((((h1 shr 16) *% 5) and 0xffff) shl 16))
    h1 = ((h1b and 0xffff) +% 0x6b64) +%
         ((((h1b shr 16) +% 0xe654) and 0xffff) shl 16)

  k1 = 0

  if remainder == 3:
    k1 = k1 xor (key.charCodeAt((chunks+1)*4+2) shl 16)

  if remainder >= 2:
    k1 = k1 xor (key.charCodeAt((chunks+1)*4+1) shl 8)

  if remainder >= 1:
    k1 = k1 xor key.charCodeAt((chunks+1)*4)


  k1 = ((k1 and 0xffff) *% c1) +% ((((k1 shr 16) *% c1) and 0xffff) shl 16)
  k1 = (k1 shl 15) or (k1 shr 17)
  k1 = ((k1 and 0xffff) *% c2) +% ((((k1 shr 16) *% c2) and 0xffff) shl 16)

  h1 = h1 xor k1

  h1 = h1 xor toU32(len(key))
  h1 = h1 xor (h1 shr 16)
  h1 = ((h1 and 0xffff) *% 0x85ebca6b'i32) +%
       ((((h1 shr 16) *% 0x85ebca6b'i32) and 0xffff) shl 16)
  h1 = h1 xor (h1 shr 13)
  h1 = ((h1 and 0xffff) *% 0xc2b2ae35'i32) +%
       ((((h1 shr 16) *% 0xc2b2ae35'i32) and 0xffff) shl 16)
  h1 = h1 xor (h1 shr 16)

  return uint32(h1)

if isMainModule:
  proc `==`(x, y: uint32): bool =
    return int32(x) == int32(y)

  assert(hash("test0", 0) == uint32(2695866395'i64))
  assert(hash("test1", 1) == uint32(2927998745'i64))
  assert(hash("test2", 2) == uint32(1071849810'i64))
  assert(hash("test3", 3) == uint32(3481278076'i64))
  assert(hash("test4", 4) == uint32(2859087174'i64))
  assert(hash("test5", 5) == uint32(3407052333'i64))
