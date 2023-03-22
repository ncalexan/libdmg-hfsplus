Make sure we have a fresh build:

  $ export BUILDDIR=$TESTDIR/../build
  $ cd $BUILDDIR
  $ make &> /dev/null
  $ cd $CRAMTMP

  $ $BUILDDIR/dmg/dmg build $TESTDIR/attribution_reference/hdiutila.hfs testa.dmg __MOZILLA__attr-value- >/dev/null

Note the "attr-value-p" suffix below!

  $ $BUILDDIR/dmg/dmg build $TESTDIR/attribution_reference/hdiutilp.hfs testb.dmg __MOZILLA__attr-value- >/dev/null

  $ xxd testa.dmg > testa.txt
  $ xxd testb.dmg > testb.txt
  $ diff --unified=3 testa.txt testb.txt
  --- testa.txt* (glob)
  +++ testb.txt* (glob)
  @@ -3349,7 +3349,7 @@
   0000d140: 7400 7200 2d00 6b00 6500 7900 0000 1000  t.r.-.k.e.y.....
   0000d150: 0000 0000 0000 0000 0000 175f 5f4d 4f5a  ...........__MOZ
   0000d160: 494c 4c41 5f5f 6174 7472 2d76 616c 7565  ILLA__attr-value
  -0000d170: 2d61 0000 0000 0000 0000 0000 0000 0000  -a..............
  +0000d170: 2d70 0000 0000 0000 0000 0000 0000 0000  -p..............
   0000d180: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   0000d190: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   0000d1a0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  @@ -16652,7 +16652,7 @@
   000410b0: 4141 6741 4141 4141 4141 4141 4141 4141  AAgAAAAAAAAAAAAA
   000410c0: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
   000410d0: 4141 4141 410a 0909 0909 4141 4941 4141  AAAAA.....AAIAAA
  -000410e0: 4167 3544 5163 6877 4141 4141 4141 4141  Ag5DQchwAAAAAAAA
  +000410e0: 4167 2b53 4962 7641 4141 4141 4141 4141  Ag+SIbvAAAAAAAAA
   000410f0: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
   00041100: 4141 4141 4141 0a09 0909 0941 4141 4141  AAAAAA.....AAAAA
   00041110: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
  @@ -16918,8 +16918,8 @@
   00042150: 4141 4258 3344 424d 4877 4541 4141 4141  AABX3DBMHwEAAAAA
   00042160: 4141 4141 4141 4141 4141 4141 4141 4141  AAAAAAAAAAAAAAAA
   00042170: 4141 4166 0a09 0909 0941 5141 4141 4141  AAAf.....AQAAAAA
  -00042180: 4141 4141 4142 4141 4141 4141 415a 3871  AAAAABAAAAAAAZ8q
  -00042190: 3836 3646 494d 3855 7442 5141 4141 4141  866FIM8UtBQAAAAA
  +00042180: 4141 4141 4142 4141 4141 4141 4170 7856  AAAAABAAAAAAApxV
  +00042190: 6f30 4b46 494d 3855 7442 5141 4141 4141  o0KFIM8UtBQAAAAA
   000421a0: 4141 4a62 690a 0909 0909 4171 3041 5945  AAJbi.....Aq0AYE
   000421b0: 7341 4141 4141 4141 3d3d 0a09 0909 093c  sAAAAAAA==.....<
   000421c0: 2f64 6174 613e 0a09 0909 093c 6b65 793e  /data>.....<key>
  @@ -16936,7 +16936,7 @@
   00042270: 064c 0000 0000 0000 0000 0000 0000 0000  .L..............
   00042280: 0000 0000 0001 0000 0001 2a0c b53a d9ac  ..........*..:..
   00042290: b760 f13a d610 a741 0000 0000 0002 0000  .`.:...A........
  -000422a0: 0020 8e77 24c9 0000 0000 0000 0000 0000  . .w$...........
  +000422a0: 0020 8eb5 c555 0000 0000 0000 0000 0000  . ...U..........
   000422b0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   000422c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   000422d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  @@ -16953,7 +16953,7 @@
   00042380: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   00042390: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   000423a0: 0000 0000 0000 0000 0000 0000 0002 0000  ................
  -000423b0: 0020 2339 ec78 0000 0000 0000 0000 0000  . #9.x..........
  +000423b0: 0020 0b7d d859 0000 0000 0000 0000 0000  . .}.Y..........
   000423c0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   000423d0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
   000423e0: 0000 0000 0000 0000 0000 0000 0000 0000  ................
  [1]

Check resources:

  $ $BUILDDIR/dmg/dmg res testa.dmg - | expand -t 4
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
      <key>resource-fork</key>
      <dict>
          <key>blkx</key>
          <array>
              <dict>
                  <key>Attributes</key>
                  <string>0x0050</string>
                  <key>CFName</key>
                  <string>Driver Descriptor Map (DDM : 0)</string>
                  <key>Data</key>
                  <data>
                  bWlzaAAAAAEAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAA
                  AAII/////wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAIAAAAgXDMYCQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAACgAAABgAAAAAAAAAAAAAAAAAAAAAAAAABAAAA
                  AAAAAAAAAAAAAAAANf////8AAAAAAAAAAAAAAAEAAAAA
                  AAAAAAAAAAAAAAA1AAAAAAAAAAA=
                  </data>
                  <key>ID</key>
                  <string>-1</string>
                  <key>Name</key>
                  <string>Driver Descriptor Map (DDM : 0)</string>
              </dict>
              <dict>
                  <key>Attributes</key>
                  <string>0x0050</string>
                  <key>CFName</key>
                  <string>Apple (Apple_partition_map : 1)</string>
                  <key>Data</key>
                  <data>
                  bWlzaAAAAAEAAAAAAAAAAQAAAAAAAAA/AAAAAAAAAAAA
                  AAIIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAIAAAAg7xHa2gAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAACgAAABgAAAAAAAAAAAAAAAAAAAAAAAAA/AAAA
                  AAAAADUAAAAAAAAAv/////8AAAAAAAAAAAAAAD8AAAAA
                  AAAAAAAAAAAAAAD0AAAAAAAAAAA=
                  </data>
                  <key>ID</key>
                  <string>0</string>
                  <key>Name</key>
                  <string>Apple (Apple_partition_map : 1)</string>
              </dict>
              <dict>
                  <key>Attributes</key>
                  <string>0x0050</string>
                  <key>CFName</key>
                  <string>Macintosh (Apple_Driver_ATAPI : 2)</string>
                  <key>Data</key>
                  <data>
                  bWlzaAAAAAEAAAAAAAAAQAAAAAAAAAAIAAAAAAAAAAAA
                  AAIIAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAIAAAAgxxwAEQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAACgAAABgAAAAAAAAAAAAAAAAAAAAAAAAAIAAAA
                  AAAAAPQAAAAAAAAAK/////8AAAAAAAAAAAAAAAgAAAAA
                  AAAAAAAAAAAAAAEfAAAAAAAAAAA=
                  </data>
                  <key>ID</key>
                  <string>1</string>
                  <key>Name</key>
                  <string>Macintosh (Apple_Driver_ATAPI : 2)</string>
              </dict>
              <dict>
                  <key>Attributes</key>
                  <string>0x0050</string>
                  <key>CFName</key>
                  <string>Mac_OS_X (Apple_HFSX : 3)</string>
                  <key>Data</key>
                  <data>
                  bWlzaAAAAAEAAAAAAAAASAAAAAAAACewAAAAAAAAAAAA
                  AAIIAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAIAAAAg5DQchwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAVAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAIAAAAA
                  AAAAAR8AAAAAAAQAAIAAAAYAAAAAAAAAAAAAAgAAAAAA
                  AAACAAAAAAAABAEfAAAAAAAAAC2AAAAGAAAAAAAAAAAA
                  AAQAAAAAAAAAAgAAAAAAAAQBTAAAAAAAAAF0gAAABgAA
                  AAAAAAAAAAAGAAAAAAAAAAIAAAAAAAAEAsAAAAAAAAAA
                  LYAAAAYAAAAAAAAAAAAACAAAAAAAAAACAAAAAAAABALt
                  AAAAAAAAAEiAAAAGAAAAAAAAAAAAAAoAAAAAAAAAAgAA
                  AAAAAAQDNQAAAAAAAAAtgAAABgAAAAAAAAAAAAAMAAAA
                  AAAAAAIAAAAAAAAEA2IAAAAAAAAALYAAAAYAAAAAAAAA
                  AAAADgAAAAAAAAACAAAAAAAABAOPAAAAAAAAAC2AAAAG
                  AAAAAAAAAAAAABAAAAAAAAAAAgAAAAAAAAQDvAAAAAAA
                  AAAtgAAABgAAAAAAAAAAAAASAAAAAAAAAAIAAAAAAAAE
                  A+kAAAAAAAAALYAAAAYAAAAAAAAAAAAAFAAAAAAAAAAC
                  AAAAAAAABAQWAAAAAAAAAC2AAAAGAAAAAAAAAAAAABYA
                  AAAAAAAAAgAAAAAAAAQEQwAAAAAAAAAtgAAABgAAAAAA
                  AAAAAAAYAAAAAAAAAAIAAAAAAAAEBHAAAAAAAAAALYAA
                  AAYAAAAAAAAAAAAAGgAAAAAAAAACAAAAAAAABASdAAAA
                  AAAAAC2AAAAGAAAAAAAAAAAAABwAAAAAAAAAAgAAAAAA
                  AAQEygAAAAAAAAAtgAAABgAAAAAAAAAAAAAeAAAAAAAA
                  AAIAAAAAAAAEBPcAAAAAAAAALYAAAAYAAAAAAAAAAAAA
                  IAAAAAAAAAACAAAAAAAABAUkAAAAAAAAAC2AAAAGAAAA
                  AAAAAAAAACIAAAAAAAAAAgAAAAAAAAQFUQAAAAAAAAAt
                  gAAABgAAAAAAAAAAAAAkAAAAAAAAAAIAAAAAAAAEBX4A
                  AAAAAAAALYAAAAYAAAAAAAAAAAAAJgAAAAAAAAABsAAA
                  AAAABAWrAAAAAAAAAKH/////AAAAAAAAAAAAACewAAAA
                  AAAAAAAAAAAAAAQGTAAAAAAAAAAA
                  </data>
                  <key>ID</key>
                  <string>2</string>
                  <key>Name</key>
                  <string>Mac_OS_X (Apple_HFSX : 3)</string>
              </dict>
              <dict>
                  <key>Attributes</key>
                  <string>0x0050</string>
                  <key>CFName</key>
                  <string> (Apple_Free : 4)</string>
                  <key>Data</key>
                  <data>
                  bWlzaAAAAAEAAAAAAAAn+AAAAAAAAAAKAAAAAAAAAAAA
                  AAAAAAAAAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAIAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAACAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAKAAAA
                  AAAEBkwAAAAAAAAAAP////8AAAAAAAAAAAAAAAoAAAAA
                  AAAAAAAAAAAABAZMAAAAAAAAAAA=
                  </data>
                  <key>ID</key>
                  <string>3</string>
                  <key>Name</key>
                  <string> (Apple_Free : 4)</string>
              </dict>
          </array>
          <key>plst</key>
          <array>
              <dict>
                  <key>Attributes</key>
                  <string>0x0050</string>
                  <key>Data</key>
                  <data>
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAQAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
                  AAAAAAAAAAAA
                  </data>
                  <key>ID</key>
                  <string>0</string>
                  <key>Name</key>
                  <string></string>
              </dict>
          </array>
          <key>attribution</key>
          <array>
              <dict>
                  <key>Attributes</key>
                  <string>0x0000</string>
                  <key>Data</key>
                  <data>
                  cnR0YQEAAABX3DBMHwEAAAAAAAAAAAAAAAAAAAAAAAAf
                  AQAAAAAAAAAABAAAAAAAZ8q866FIM8UtBQAAAAAAAJbi
                  Aq0AYEsAAAAAAA==
                  </data>
                  <key>ID</key>
                  <string>2</string>
                  <key>Name</key>
                  <string></string>
              </dict>
          </array>
      </dict>
  </dict>
  </plist>

Line in the sand:

  $ shasum testa.dmg testb.dmg
  a4ff8876728adb580fbc266ce5758b0d9c5ef0e0  testa.dmg
  b7f39dd45e727bbdc77f19c11c5da2cca9c1a57d  testb.dmg

Attribute:

  $ $BUILDDIR/dmg/dmg attribute testa.dmg testa_updated.dmg __MOZILLA__attr-value- __MOZILLA__attr-value-p >/dev/null

Note -- same same:

  $ xxd testa_updated.dmg > testa_updated.txt
  $ diff --unified=3 testb.txt testa_updated.txt
  $ shasum testb.dmg testa_updated.dmg
  b7f39dd45e727bbdc77f19c11c5da2cca9c1a57d  testb.dmg
  b7f39dd45e727bbdc77f19c11c5da2cca9c1a57d  testa_updated.dmg

We could also revert:

  $ $BUILDDIR/dmg/dmg attribute testa_updated.dmg testa_reverted.dmg  __MOZILLA__attr-value- __MOZILLA__attr-value-a >/dev/null

Note -- same same:

  $ xxd testa_reverted.dmg > testa_reverted.txt
  $ diff --unified=3 testa.txt testa_reverted.txt
  $ shasum testa.dmg testa_reverted.dmg
  a4ff8876728adb580fbc266ce5758b0d9c5ef0e0  testa.dmg
  a4ff8876728adb580fbc266ce5758b0d9c5ef0e0  testa_reverted.dmg
