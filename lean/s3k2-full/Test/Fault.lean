import RSN
open RSN
-- (1) a false edge identity must be rejected
example : identOK top0Verts ((1, 2, 3) :: top0Edges) = true := by decide +kernel
-- (2) a vertex polynomial out of range must be rejected
example : vertsOK (top0N + 1) (top0Verts ++ [[0]]) = true := by decide +kernel
-- (3) a tampered LRAT step (first step of segment 0, hints [962, 961, 593] replaced by [962]) must be rejected
example : checkSegF ((⟨967, [81], [962]⟩ : Step) :: top0Seg0.tail) top0Db0 = true := by
  decide +kernel
-- (4) a wrong blue fact (blue vertex claimed to be a + 2) must be rejected
example : blueOK top0Verts [9, 1] top0Blues = true := by decide +kernel
