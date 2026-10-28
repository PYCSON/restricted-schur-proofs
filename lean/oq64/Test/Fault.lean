import OQ64.L3
open OQ64 RSN
-- Each example below must be REJECTED (decide proves the proposition false).
-- 1. tampered identity: first edge with w changed from vertex 3 to vertex 4
example : (⟨0, 2, [(1, 1), (1, 2)], 4⟩ :: l3E0.tail).all (edgeOK 3 3 4 l3V l3F) = true := by decide +kernel
-- 2. region extended to k0 = 2 (big multiplicity k - c could be 0)
example : l3E0.all (edgeOK 3 2 4 l3V l3F) = true := by decide +kernel
-- 3. target F - 1 instead of F (some edge reaches w = F)
example : l3E0.all (edgeOK 3 3 4 l3V [2, 4, 1]) = true := by decide +kernel
-- 4. tampered LRAT step: first step with its hints removed
example : checkSegF ((⟨208, [5, 7, 9], []⟩ : Step) :: l3Seg0.tail) l3Db0 = true := by decide +kernel
