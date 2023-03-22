# Attribution

`dmg build in.hfs out.dmg <sentinel>`
- strip unnecessary resources, including `cSum`
- include new `attribution` resource
- arrange single BZ_RAW block

`dmg attribute in.dmg out.dmg <sentinel> <replacement>`
N.b. attribute shouldn't parse the DMG, it should operate on bytestream
- read `attribution` resource
- update bytes in BZ_RAW block in place
- update <blkx> checksum
- update data fork checksum (compressed)
- update master checksum (uncompressed)

# Testing

The gold standard is to create two HFS filesystems, both with the same
xattr but with distinct values, and build attributable DMGs with the
same sentinel (a prefix of the distinct values, say).

See `test/hfs_xattrs.t` and `test/attribution_reference.t` for [Cram](https://pypi.org/project/cram/)
tests that generate such HFS and DMG files.

See `test/attribution.t` for tests that exercise `dmg build` and `dmg
attribute`.

## Future

It would be nice to add a command to convert an existing DMG file to
an attributable one, like:

`dmg attributable <in.dmg> <out.dmg> <sentinel>`
- strip unnecessary resources, including `cSum`
- include new `attribution` resource
- arrange single BZ_RAW block
