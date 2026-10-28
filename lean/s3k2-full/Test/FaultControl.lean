import RSN
open RSN
example : checkSegF ((⟨967, [81], [962, 961, 593]⟩ : Step) :: top0Seg0.tail) top0Db0 = true := by
  decide +kernel
