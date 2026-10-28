import OQ64.L3
open OQ64 RSN
example : l3E0.all (edgeOK 3 3 4 l3V l3F) = true := by decide +kernel
example : checkSegF l3Seg0 l3Db0 = true := by decide +kernel
