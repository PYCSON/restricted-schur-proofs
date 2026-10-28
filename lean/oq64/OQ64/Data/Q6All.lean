module

public import OQ64.Kernel
public import OQ64.Data.Q6D0
public import OQ64.Data.Q6D1
public import OQ64.Data.Q6D2
public import OQ64.Data.Q6D3

@[expose] public section

namespace OQ64

def q6Es : List (List Edge) := [q6E0, q6E1, q6E2, q6E3, q6E4, q6E5, q6E6, q6E7, q6E8, q6E9, q6E10, q6E11, q6E12, q6E13, q6E14, q6E15, q6E16, q6E17, q6E18, q6E19, q6E20, q6E21, q6E22, q6E23, q6E24, q6E25, q6E26]

def q6Cs : List (List RSN.Clause) := [q6C0, q6C1, q6C2, q6C3, q6C4, q6C5, q6C6, q6C7, q6C8, q6C9, q6C10, q6C11, q6C12, q6C13, q6C14, q6C15, q6C16, q6C17, q6C18, q6C19, q6C20, q6C21, q6C22, q6C23, q6C24, q6C25, q6C26]

end OQ64
