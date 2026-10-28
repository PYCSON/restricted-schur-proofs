module

public import OQ64.Kernel
public import OQ64.Data.Q5D0

@[expose] public section

namespace OQ64

def q5Es : List (List Edge) := [q5E0, q5E1, q5E2, q5E3, q5E4, q5E5, q5E6, q5E7]

def q5Cs : List (List RSN.Clause) := [q5C0, q5C1, q5C2, q5C3, q5C4, q5C5, q5C6, q5C7]

end OQ64
