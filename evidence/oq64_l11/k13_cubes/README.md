# S_2(k;11) ≤ F(k,11) for every k ≥ 13: 222 cube certificates (v1.1)

Status: computer-assisted proof candidate, not peer reviewed. For the statement, the layout and the replay commands, see the section "Result 4 for k ≥ 13" of the top-level `README.md` and §4.1 of the preprint.

* The colour of 1 is fixed. A prefix `P` fixes the colour of the integer `j+2` to `P[j]`, where `0` means the colour of 1. The 222 prefixes are pairwise prefix-free and Σ2^(−|P|) = 1, which `check_partition.py` checks.
* Origin: the hyperedge lists came from a cube-and-conquer run of the project's search program `symeng_v16` (`evidence/oq64_l8/symeng_v16.cpp`) on the author's computer. The engine binary had SHA-256 `68d18716d4565ef4f60c28684ab660b3f2d17d55b4a5749bcac8e7a75457c4f2` and arguments `11 13 70 10 100000000 1 0 11`. Neither the engine nor its scheduler is trusted.
* Construction: `generation/cubecert.py` turned each edge list into a certificate. All edges were kept; no minimisation was done.
* First-party checks: `generation/runcert.py` and `verify_first_party.sh` ran `check_cert.py`, CaDiCaL 3.0.1 with LRAT output, `lrat-check` and `cake_lpr`. The results are in `logs/first_party_results.tsv` and `logs/first_party_checker_logs.tar.xz`, 222/222 PASS.
* Second-party checks: see `independent_review/`.
