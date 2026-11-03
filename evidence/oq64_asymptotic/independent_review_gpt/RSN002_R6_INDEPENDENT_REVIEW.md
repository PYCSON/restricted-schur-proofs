> **Public-release note (added by the repository author, 2026-11-03).** This is GPT's second-party review report. Passages that referred to private correspondence have been replaced by bracketed notes. No verdict, number or other content was changed. The files `GAISER_REPLY_PRIVATE_SOURCE_NOTE.md`, `INPUT_VERSION_DIFF.patch`, `R6_REUPLOAD_CHANGELOG_20261103.md` and GPT's delivery `SHA256SUMS` are not included. `SHA256SUMS_public` lists the files that are included.

# RSN-002 第六轮：R-37 / R-38 渐近常数独立审查

**原审查日期：** 2026-11-02；**增补核验：** 2026-11-03。**本次审查对象：** `GPT_RSN002_ASYMPTOTIC_R6_20261102 (1).zip`（在 11-02 版本上仅增补一项私人通信记录；公开版已删去相关段落）。**研究主张：**
\[
 a_*=(\sqrt2-1)/2,\quad K(\ell)=(1+a_*)\ell+O(1)=\frac{1+\sqrt2}{2}\ell+O(1).
\]

**状态与身份：** 本报告是另一套 Python/SymPy 实现、数学推导和随机/有限枚举所进行的计算性第二方审查。没有同行评议，不替代数学共同体对论文的审稿；审查没有推送仓库、公开新结果、投稿、对外联系或花钱。**注意新版输入包的发布阻断：** 原 `asymptotic/SHA256SUMS` 已过期，只有 **34/35 PASS**；改动的 `THEOREM_ASYMPTOTIC.md` 哈希不匹配。另一个 `independent_review_subagent/SHA256SUMS` **17/17 PASS**。本交付另附建议的修复版 `CORRECTED_ASYMPTOTIC_SHA256SUMS.txt`，须在审核通过后由文件所有者更新原仓库/清单。哈希校验只保证文件身份，不保证数学证明正确。

## 0. 裁决摘要

| 任务 | 判定 | 关键依据 |
|---|---|---|
| A1 三段着色严格好染色 | **PASS（解析）** | 两色 k-和的最小值分别为 m+1 和 V3；覆盖所有可能重复项/小红大红混搭 |
| A2 独立位集 DP | **PASS（有限）** | 自编 exact distinct-count bitset DP；包括 (19,1,5) 和 (20,1,5)；放宽版、对角例也重放 |
| A3 R-37 精确渐近下界 | **PASS（解析＋SymPy）** | 凹二次式、取整损失、顶点范围、e 单调性、所有平移多项式系数非负 |
| A4 \(19\le\ell\le49\) | **PASS（有限）** | 从定义重建 e_L 及全部 6–80 有限表 |
| B1 T1-fill 逐边合法性 | **PASS（解析）** | 六种输出族的不同性/配色/和式/界均检查；完整重建链 |
| B2 S1 内三元组存在 | **PASS（解析）** | 截断仿射闭包 ⇒ 单个等差数列；空交集补情形成立，允许 y=r′ 至关重要 |
| B3 最坏界、u 选择和单调性 | **PASS（解析）** | 上界系数均非负；26,221 稀疏窗口独立全量有限测试 |
| B4 R-38 判别式 | **PASS（解析＋SymPy）** | 两个上界情形在 e=a*ℓ+4、ℓ≥50 的系数非负；cU=3 在 II 情形失败 |
| B5 精确有限阈值与一致性 | **PASS（阈值）／PARTIAL（独立全量一致性）** | 自编 6–80 阈值；有限样本和 DPs 无矛盾；没有独立重演生产者全部 6807 个窗口的全局最小化 |
| C j=1 | **PASS（解析）** | Lemma G、两个 AP 和区间、八个多项式条件在 ℓ≥7,e≥3 与 ℓ≥6,e≥4 系数非负 |
| D 全红窗口 | **PASS（解析）** | Fact 1 的 e=1 两个补洞构造核实，480 个独立穷举；三层范围和最终 F 等式验证 |
| E1–3 THEORY_CASE1 非奇偶平衡 | **PASS（解析）** | 五边 T1、闭包分类、w 粗界余量非负，另 23,845/23,845 有限窗口 PASS |
| E4–5 奇偶窗口 | **PASS（解析，附详细证书）** | k 偶数一边交集；k 奇数独立 AP 子集构造 23,740 例，符号不等式可完整闭合 |
| E′ 放宽版 | **按 c(S)≥ℓ+1 的读法条件性 PASS**（公开版删去一处私人通信引用） | 引言 c≥ℓ+1，第 6 节写 c≥ℓ；只有前者与 Cor.6.3 一致；按前者两例 DP PASS |
| F 文献新颖性 | **PARTIAL** | 已核对 Gaiser (2026) 与 Ahmed 等 (2023)，未发现相同精确系数，但检索不等于全球先有工作穷尽证明 |
| G 论文 LaTeX | **完成草稿** | 见 `ASYMPTOTICS_SECTION_DRAFT.tex`；必须保留未同行评审和依赖出处 |

**合并审查意见：** 本轮未找到足以推翻 R-37/R-38 的数学反例；在本文所列依赖及严格定义下，解析证据支持候选 \(K(\ell)=\frac{1+\sqrt2}{2}\ell+O(1)\)。可交 Claude 复核本报告后考虑登记 R-37/R-38 为 *second-party computationally reviewed proof candidates*。不可写成已同行评审、公开发表或完全形式化证明。

## 1. A：三段染色及下界

固定 \(k=\ell+e\) 与 \(1\le j\le\ell-1\)。令
\[
 m=\frac{\ell(\ell+1)}2+\ell j+e(j+1)-1,\quad q=\ell-j,\quad
 V_3=\frac{j(j+1)}2+q(m+1)+\binom q2+e.
\]
在 \([1,V_3-1]\) 用 \(R=[1,j]\cup[m+1,V_3-1]\), \(B=[j+1,m]\) 着色。

*蓝色：* 任取 \(\ell\) 个不同蓝加数，至少 \(j+1,\dots,j+\ell\)，剩余 e 次至少重复 \(j+1\)。因此和 \(\ge\ell j+\ell(\ell+1)/2+e(j+1)=m+1\)；这个数严格在蓝区右端以外。

*红色：* 最多 j 个不同加数在 \([1,j]\)，所以至少 q 个不同大红加数 \(\ge m+1,\dots,m+q\)。若小红个数不足 j，替换为更大的大红只会增加和；e 次额外拷贝至少 e。因此和 \(\ge\sum_{r=1}^{j}r+\sum_{r=1}^{q}(m+r)+e=V_3\)。即便没有足够的大红点组成合法加数集合，结论更显然。所有被加数为正，所以和必大于最大的加数，不会误把同一输出算入不同加数集合。**三段染色严格 good**，给出 \(S_2(k;\ell)\ge V_3\)。

令 \(F(k,\ell)=k^2+[\ell(\ell-1)/2+1]k+\ell(\ell-2)\)。独立 SymPy 展开得到
\[
 G(j)=V_3-F=(1-e-\ell)j^2+
 (e\ell-e+\ell^2/2-3\ell/2+1)j
 -e^2-e\ell^2/2-e\ell/2-\ell^2/2+\ell/2.
\]
记 \(A=e+\ell-1>0\)，\(G=-Aj^2+\beta j+\gamma\)。连续最大值为 \(G_{\max}=\gamma+\beta^2/(4A)\)，取距连续顶点不超过 1/2 的整数时损失不超过 \(A/4\)。故 \(H=4A\gamma+\beta^2-A^2-4A\ge0\) 保证某个整数 j 满足 \(G(j)\ge1\)。顶点具体为
\[
 j_* = \frac{(\ell-1)(2e+\ell-2)}{4(e+\ell-1)},
\]
在 \(\ell\ge50,e=a_*\ell-4\) 时落于 \([1,\ell-1]\)。`independent_r6_symbolic.py` 对 \(H(50+u,a_*(50+u)-4)\) 进行**精确含根式系数**的分解，三次、多项式各系数均非负；\(G\) 关于 e 的偏导严格负，因此所有整数 \(1\le e\le a_*\ell-4\) 都有反例染色。于是 \(K(\ell)>(1+a_*)\ell-4\) (\(\ell\ge50\))。

主系数：设 \(e=\alpha\ell,j=x\ell\)，\(G\) 的三次项为 \(-[\alpha(2x^2-2x+1)+2x^2-x]\ell^3/2\)，其由正变负的临界 \(\alpha\) 最大值恰为 \(a_*\)，顶点 \(x=(2-\sqrt2)/2\)。

`independent_dp.py` **未读取任何生产者 goodcheck.py 源码**，独立按 (不同值数,额外次数,和) 用位集推进。\((\ell,e,j)=(19,1,5)\) 得 \(F=4163,V_3=4181\)，\((20,1,5)\) 得 \(F=4812,V_3=4861\)；DP 在区间末端查无单色解。于是 \(K(19)\ge21,K(20)\ge22\)。另在 \((20,0,4)\) 得 \(V_3=4770\)，与 \(k=20\) 时全体 distinct 的弱 Schur 约束相容：\(WS_{20}(2)\ge4770\)。这仍不应在没有更完整新文献清查时宣称纪录首创。

## 2. B：T1-fill 上界，五层强制的完整语义

设窗口 \(W=[1,2\ell]\)，少数色 D 有 \(j\) 个点、\(2\le j\le\ell-2\)，多数色 M；\(q=\ell-j\ge2\)。令 \(S_1\) 为窗口中最小 \(\ell\) 个 M 值。选 \(y,r',d\in S_1\)、\(b\in D_W\)，满足 \(b=y+r'-d\)，并令 \(R'=S_1\setminus\{y\}\), \(u=\min R'\), \(r=\min(S_1\setminus\{r'\})\)；\(z_1,\ldots,z_{q-1}\) 为 \(S_1\setminus\{r,r'\}\) 最小的 \(q-1\) 个点。令 \(d_b=\min(D_W\setminus\{b\})\)；\(\Sigma_0=\sum S_1+(e-1)u\)。

* L1、L2、Zi：\(L_1=\Sigma_0+r\), \(L_2=\Sigma_0+r'\), \(Z_i=\Sigma_0+z_i\) 均是 S1 的 M 色 k-和，故为 D。各输入都有恰 ℓ 个不同值，额外重数是 \((e-1)u\) 和单个 r/r′/zi；它们互不相等且大于 2ℓ。
* B3：\(B_3=(D_W\setminus\{b\})\cup\{Z_i\}\)，大小 \((j-1)+(q-1)=\ell-2\)；Zi 大于窗口，因此与 D_W 不重叠，\(d_b\in B_3\)。
* Mv：\(M_v=\sum B_3+b+L_1+e\,d_b\) 是 \(B_3\cup\{b,L_1\}\) 的 D 色 k-和，故为 M；不同性是 b 不在 B3，L1 ≠ Zi，L1 >2ℓ。
* w：\(w=\sum R'+M_v+(e-1)u+d\) 是 \(R'\cup\{M_v\}\) 的 M 色 k-和，故为 D。因为 \(M_v>2\ell\)，它不属于 R′。
* w′：\(w'=\sum B_3+L_1+L_2+e\,d_b\) 是 \(B_3\cup\{L_1,L_2\}\) 的 D 色 k-和，故为 M。L1≠L2 且二者均不等于 Zi。又有 \(w-w'=b+d-y-r'=0\)，构成红蓝矛盾。

每条 k-和的被加数都严格为正，且至少两个不同值，所以输出比每个输入大。\(w\) 是这条传播链内的最大值；条件 \(w\le F\) 足够。详见 `independent_t1.py`：对 26,221 个窗口实例逐步验输出颜色、总次数、不同值个数、求和与范围，全部 PASS；这仅是有限交叉验证，上面的代数是一般证据。

**三元组存在性。** 若 D 与 \([1,m_\ell]\) 相交而找不到三元组，则 \(S_1\) 对任何落在此范围的 \(y+r'-d\) 封闭。令其前两个元素 \(m_1<m_2\)，\(\delta=m_2-m_1\)：若 \(\delta<m_1\)，\(2m_1-m_2\ge1\) 就是比 m1 小的新 M 值，矛盾。故 \(\delta\ge m_1\)。用 \(m_1,m_2\) 的平移和反向减法，所有 \(m_1+n\delta\le m_\ell\) 必在 S1，而其他模 δ 的值通过减 δ 落到 (m1,m2) 禁区，因此 S1 是单一等差列。\(\delta=1\) 迫使 m1=1、D 在 [1,mℓ] 为空，矛盾；\(\delta\ge2\) 则 \(m_\ell\ge m_1+2(\ell-1)>2\ell-2\ge\ell+j\ge m_\ell\)，矛盾。若 D 在 [1,mℓ] 为空，则 S1=[1,ℓ]，并取 \(b\in D\cap[\ell+1,2\ell-1]\)（j≥2 保证）、\(y=\ell,r'=b+1-\ell,d=1\)，合法。允许 \(y=r'\) 是封闭性归纳的重要前提。

**上界公式。** 将原 w 化简为
\[
 w=\sum R'+\sum D_W+q\Sigma_0+\sum_i z_i+r+d+e\,d_b+(e-1)u.
\]
可依次取 \(\sum R'\le\sum S_1\le \ell j+\ell(\ell+1)/2\)、\(\sum D_W\le j(4\ell-j+1)/2\)、\(z_i\le j+i+2\)、\(r\le j+3\)、\(d\le\ell+j\)、\(d_b\le2\ell\)、\(u=1\)（多数红，置 y≠1；若原来 y=1，则对调 y 与 r′）或 \(u\le j+2\)（多数蓝）。代入所得的两个 \(w_{\rm bound}^{\rm I,II}\) 具有非负系数；`independent_r6_symbolic.py` 重建 \(P=F-w_{\rm bound}\)，对 j 的二次项分别为 \(\ell+1\)、\(\ell+e\)。两种 \(Q=4\alpha\gamma-\beta^2\) 在 \(e=a_*\ell+4,\ell=50+u\) 均展开为所有系数非负的多项式。因此所有实 j 的 P≥0。且 \(\partial P/\partial e\) 在第二种情形下 ≥\(\ell^2/4-2\ell+2e-5/4\)；对 ℓ≥9,e≥1 非负。第一种情形导数 \(2e+j+(\ell^2-3\ell)/2>0\)。故所有整数 \(e\ge\lceil a_*\ell+4\rceil\) 都可排除稀疏窗口（ℓ≥50）。

**反例对照：** 将加性上界常数强行改成 cU=3，ℓ=50、100 的第二种情形判别式为负；程序捕获该失败，符合预期。`independent_finite.py` 自算 \(\ell=6\ldots80\) 的 eU（枚举 j=2..ℓ−2）、eJ1 和三段下界 eL，特别得到 \(\ell=6..49\) 上 \(K_{\rm upper}-(1+a_*)\ell\) 最大为约 8.5503，支持全范围加性 +9。**没有**单独重演全部 6807 个生产者 `consistency2.py` 的全窗口最佳 witness；故对此细项保留 PARTIAL，而非冒称独立全量执行。

## 3. C：j=1

令窗口少数色 D 仅一个值 b0。构造多数色 ℓ 元组 S 的重复和集 eS：多数红时，若 b0>ℓ，取 S=[1,ℓ]；否则取 S=[1,ℓ+1]∖{b0}。归一化至最小值 0 后，这样的 S 包含两点长连续段、内部间隙≤2，故若 e≥2，由自证 Lemma G 得
\[eS\supset[e+2,\;e+(e-1)(\ell-1)].\]
多数蓝时 b0=1，取 S=[2,ℓ+1]，则 \(eS=[2e,(\ell+1)e]\)。

**Lemma G 证明：** 若 O⊆[0,Δ] 含两端，每个相邻空隙≤r，并有一个 r 项连续段 [a,a+r−1]，则 \((e-1)O\) 包含 \(\bigcup_{i=0}^{e-2}(iΔ+O)\)。这些翻转块覆盖 [0,(e−1)Δ] 且无长度≥r 的缺口。加上 [a,a+r−1]，可填满 [a,(e−1)Δ+a+r−1]；注意两端包含的边界。故结论成立。

再以一级被迫少数色区间取 q=ℓ−1 个不同元素，连同窗口唯一 D 值及 e 次重复，得到被迫多数色连续区间，其宽度 \(q(L+1-q)\)。要与由最小 ℓ−1 个多数色元素构造的 k-和碰撞，逐一要求一级强制端点≤F、区间长度足够、P≤宽度、V0+P≤F。`independent_aux_symbolic.py` 独立列出 Case I/II 共八个多项式；在 (ℓ,e)=(7+u,3+t) 和 (6+u,4+t) 都具有**非负系数**，故对所有非负 u,t 成立。结论为 j=1 不可能（ℓ≥7,e≥3 或 ℓ=6,e≥4）。

## 4. D：全红窗口与 Fact 1

令 [a,b] 长度 n≥ℓ+2。准确结论：包含 k 项、恰 ℓ 种不同被加数、均取自 [a,b] 的和填满
\[ [ka+D,\;kb-D],\qquad D=\binom\ell2.\]
每个 ℓ 连续点块 S_c=[c,c+ℓ−1] 给出和区间 \([\sum S_c+ec,\;\sum S_c+e(c+ℓ-1)]\)；当 e≥2，邻块重叠。e=1 时两块间仅漏 \(\sum S_c+c+\ell\)，可取 \([c,c+\ell-2]\cup\{c+\ell+1\}\) 并重复 \(c+\ell-2\)；最后一个无法向右取时，取 \(\{c-1\}\cup[c+2,c+\ell]\) 并重复 \(c+2\)。后者需要 n≥ℓ+2。两种构造的和均恰为漏点，所有输入合法且恰 ℓ 种不同值。这是完整解析证明，非只依赖程序。`independent_fact1.py` 独立穷举 480 个 \((\ell,e,a,n)\) 组合，覆盖指定区间 0 漏点。

对全红 W=[1,2ℓ]，第一级 I=[k+D,2kℓ−D] 被迫蓝；对 I 用同一事实，第二级蓝色 k-和覆盖 [t,F]，被迫红，其中 t=k(k+D)+D。最后红解 \(1^{k-\ell+1},2,3,\ldots,\ell-1,t\) 恰 ℓ 种不同值、和为 F。所有 I 的点 >2ℓ 且 <F、I 长≥ℓ+2、第二步右端≥F、t≤F，均通过 `independent_aux_symbolic.py` 将 ℓ=6+u,e=1+t 展开为非负系数多项式证明。

## 5. E：THEORY_CASE1 的独立审阅

### 5.1 平衡非奇偶窗口：PASS

假设 W 上两色各≥ℓ−1。对可用颜色 C，取 C 内 ℓ 个 distinct 值 S 与另一色至少 ℓ−1 个值，旧 T1 五个恒等式对应本报告 §2 将额外 Zi 省略的情形。若无 b=y+r′−d 则 C 在截断 x+y−z 下封闭，因而是单模等差数列。若 C 含 1，数目≥ℓ 迫使公差2、C为全部奇数；若 C 为蓝，最小两点差 δ≥最小蓝值≥2，数目≥ℓ 又迫使蓝为全部偶数。除奇偶窗口外，总有某一色可用 T1。旧粗界 \(w\le 7\ell^2/2+5\ell/2-6+e(3\ell+7)\) 与 F 的差，在 ℓ=6+u,e=1+t 时为
\[
 t^2+\tfrac12tu^2+\tfrac92tu+5t+\tfrac12u^3+\tfrac{15}2u^2+31u+25>0.
\]
这给出所有 ℓ≥6,e≥1 的解析排除。`independent_balanced.py` 不依赖旧 T1 检查器，额外穷举 ℓ=6,7,8 的全部 23,845 个平衡非奇偶窗口，独立检查五边数值、颜色和不同性，0 失败。

### 5.2 奇偶窗口，k 偶数：PASS

红 O=1,3,…,2ℓ−1，蓝 E=2,4,…,2ℓ。蓝 E 上的 k-和取最小全部 ℓ 个不同点、e 次重复2，得 V=ℓ(ℓ+1)+2e。红 O 的和覆盖 \(\ell^2+e,\ell^2+e+2,\ldots,\ell^2+e(2\ell-1)\)。当 k=ℓ+e 偶数时 V−ℓ²=ℓ+2e 与 e 同奇偶且落在 [e,e(2ℓ−1)] 内，同时 V≤F。相同点从红蓝两方都能作合法 k-和，矛盾。

### 5.3 奇偶窗口，k 奇数：PASS（补出可审阅的无限参数不等式）

取 \(m=1\)（ℓ=6,7）；其余 \(m=\lceil\ell/2-\sqrt{\ell-1}\rceil\)。红 O 的所有 k-和形成步长2的 AP
\[A=\{\ell^2+e+2r:0\le r\le e(\ell-1)\}.\]
从 A 中取两个 m 子集 L,L′，令 G 为最大的 m 个偶数、G′ 为最小的 m 个偶数。令
\[M=\sum ((E\setminus G)\cup L)+2e,\quad
w=\sum(O\setminus\{2\ell-1\})+M+e,\quad
w'=\sum((E\setminus G')\cup L')+2\ell e.\]
各步骤颜色：A 被迫蓝、M 被迫红、w 被迫蓝、w′ 被迫红。等式条件为 \(\sum L'-\sum L=r\)，
\[r=(\ell-1)^2-e(2\ell-3)-2m(\ell-m).\]
由于 k 奇数，r 为偶数；在长度 \(N_A=e(\ell-1)+1\) 的步长2 AP 内，两个 m 子集和之差覆盖每个偶数 \([-2m(N_A-m),2m(N_A-m)]\)。故只需 \(|r|\le H=2m(N_A-m)\) 且 w≤F。`independent_parity.py` 采用重新编写的贪婪 AP 子集索引构造，验证从输入 O 到最终矛盾的**每条和值和颜色**，对 23,740 个 (ℓ,e) 组合（ℓ=6..400，e=1..120 与少量更大 e）均 PASS。

无限参数不等式另可直接证明：在 ℓ≥8 时写 \(s=\sqrt{\ell-1}\ge\sqrt7\)，\(m=\ell/2-s+d\)、\(0\le d<1\)，令 \(t=e-1\ge0\)。SymPy 精确给出
\[
 r-H=4d(d-2s)+t[-2ds^2-s^4+2s^3-3s^2+1]\le0,
\]
\[
 -r-H=-(s^2-1)^2+t[-2ds^2-s^4+2s^3+s^2-1]\le0.
\]
第一式用 s²−2s+3>0，第二式用 \(s^2-2s-1>0\)（s≥√7）即可逐项严格负。设 \(w_0\) 为 L 取最小 m 元的 w；若 r<0，将 L 的和增加 -r，因此 \(w=w_0+\max(0,-r)\)。两个需分别检查的裕量为 \(F-w_0\) 和 \(F-w_0+r\)。代入同一 s,d,t：
\[
 F-w_0 =t^2+t\frac{s^4+4s^2+2s+3-2d}{2}+
 s^5+s^4/2+2s^3+s^2+1/2-d(s^4+2s^2-4s)-2d^2>0,
\]
\[
 F-w_0+r=t^2+t\frac{s^4+2s+5-2d}{2}+
 s^5+s^4+2s^3+1-d(s^4+2s^2)>0.
\]
对 0≤d≤1，第一式关于 d 递减，取 d=1 下界为 \(s^5-s^4/2+2s^3-s^2+4s-3/2>0\)；第二式亦在 d=1 下界为 \(s^5+2s^3-2s^2+1>0\)。两式的 t 系数都为正。小例 ℓ=6，e 为奇数，m=1 时 r=15−9e、H=10e、\(w_0=91+4e\)，e≥1 全通过；ℓ=7，e 为偶数，m=1 时 r=24−11e、H=12e、\(w_0=127+4e\)，e≥2 全通过。故**奇偶窗口在所有 ℓ≥6, e≥1 都不可能**。

## 6. 拼接与结论的精确适用范围

任意好染色窗口 W=[1,2ℓ] 落入平衡、全红、少数色 j=1、少数色 2≤j≤ℓ−2、奇偶之一（多数 / 少数的颜色可交换；由于 1 红并不要求多数色红）。前四大类均已由 §2–§5 给出端点；平衡奇偶完全排除对任意 e≥1。若 ℓ≥50 且整数 e≥a*ℓ+4，则 U、j=1、全红都被排除，故 \(K(\ell)\le\ell+\lceil a_*\ell+4\rceil<(1+a_*)\ell+5\)。ℓ=6..49 独立计算 75 行有限表在该范围的最大 \(K_{upper}-(1+a_*)\ell=8.5502525...<9\)，故 \(K(\ell)<(1+a_*)\ell+9\) 对此区间成立（文稿的弱号 ≤ 也成立）。结合 §1 的下界，得到候选渐近式及 \(\ell\ge50\) 的绝对差 <5。

**信任边界：** 证明是数学推导 + 自写程序辅助审阅；不是 Lean/Cake 形式化定理的内核签名，也不是人类专业数学审稿。全部无限参数不等式已给出可读推导，余下供人工专家审查的风险主要是首次定义、表示的完整性、审稿对先有工作的比较，而不是已知有限反例。

## 7. E′ 放宽版定义

Gaiser 2026 原文引言说明“relaxed” 允许 \(c(S)\ge\ell+1\)（输出和另算一个不同值），但第 6 节定义处确实排印为 \(c(S)\ge\ell\)。后二者数学上不是一回事。**若按字面 \(c(S)\ge\ell\)，Corollary 6.3 中 \(S_2(k;\widetilde2)=k^2+2k\) 与通常广义 Schur 数 \(S_2(k)=k^2+k-1\) 相冲突**：对于 ℓ=2，字面条件含有全部 k 次重复同一个值的解（其连同和共 2 种不同值），结果应对应“至少 1 个不同被加数”，而不是“至少 2 个”。［公开版删去：此处原有一段关于私人通信的说明。］故以 c(S)≥ℓ+1 的读法，能够引用 \(\widetilde K(\ell)\le K(\ell)\)、Cor 6.3 及本轮三段染色下界并得相同渐近式。对应逻辑推论在采用该读法、且依赖 R-38 成立的条件下可标 PASS；对于原 PDF 中仍未更正的印刷字面定义，需明确注释，不得静默改写原始文献。

独立 DP 直接针对“至少 ℓ 个不同被加数”在 ℓ=19、20 的三段染色末端检查零同色解，另对 ℓ=20,e=0,j=4 验证了恰 ℓ 不同加数情形。

本轮检索的公开文献见 [Gaiser 2026](https://arxiv.org/abs/2608.08789)（ResearchGate 公共全文也可读取）与 [Ahmed–Boza–Revuelta–Sanz 2023](https://doi.org/10.1007/s11139-023-00760-y)。前者 §6 与引言的内部不一致能够从公开全文直接定位。由于在线 PDF 获取受限，本轮直接检查的是对应公开全文的文字，而非下载后的 PDF 页面图像。请在提交或邮件前对原版 PDF 页面再做一次人工目视校对。

## 8. F：新颖性与优先权

Gaiser 2026 发表了“固定 ℓ、充分大 k”的最终公式以及 OQ 6.4，但其 §5 没有给出这个线性渐近的最优常数；Ahmed 等 2023 使用区块染色讨论 WS 的下界，不能仅因区块数相异断言本构造首创。已检索的资料中没有发现同样的 \((1+\sqrt2)/2\) 精确门槛，但现有搜索**不是详尽先有文献审查**。写作上只能用 “We establish a computer-assisted proof candidate ... subject to verification of the balanced/parity-window lemmas”，不得用 “first proof / novel construction not previously known” 等绝对声明。

## 9. 独立审查证据目录与运行方法

- `independent_r6_symbolic.py` + `symbolic.log/json`：精确含根号判别式、顶点、单调性与负例。
- `independent_t1.py` + `t1.log/json`：26,221 稀疏窗口链。
- `independent_balanced.py` + `balanced.log/json`：23,845 平衡非奇偶窗口。
- `independent_parity.py` + `parity.log/json`：23,740 奇偶奇 k 构造。
- `independent_aux_symbolic.py` + `aux_symbolic.log`：平衡、j=1、全红、奇偶的符号不等式。
- `independent_finite.py` + `finite.log`、`finite_table.csv`：6..80 全部有限阈值。
- `independent_dp.py` + `dp.log`、`relaxed_dp.log`：精确不同性位集 DP。
- `independent_fact1.py` + `fact1.log`：480 个小盒 Fact1 穷举。
- `ASYMPTOTICS_SECTION_DRAFT.tex`：可嵌入论文的英文小节（状态谨慎）。
- `SHA256SUMS`、`REPLAY.txt`：文件散列、实际环境和命令。

所有自写主脚本都在顶端拒绝 `python -O`，避免证明关键 assert 被优化移除；已通过优化模式负例检查。**没有**运行附件中 Claude 的生产者检查器；它们只是供静态阅读及比较。


## 10. 2026-11-03 重上传版本增量复核（本次新执行）

**两份源包比较：** 11-02 原包 SHA256 `84f3cf9452d59faf7bb507b09a9daa29309ec2510cd75aca3b3d38589c279c11`；11-03 重新上传包 SHA256 `b2030810c2d519dc4478d70cad799dbab70e53e50ec4b23111cbb1cb7d8ce647`。文本任务书两版完全一致。新包比旧包多一个私人通信记录文件，并改动主文件 §6a 的一行（公开版未收录这两处）；**其余原有 90 个文件的二进制内容均未改变**，所以 R-37/R-38 数学证明、T1-fill、parity 代码证据均没有变化。（差异文件属私人材料，公开版未收录。）

**输入清单：** 新 `THEOREM_ASYMPTOTIC.md` 实际 SHA256 `dd523f7330a776250114e86ec354d038bf17673d56997b5072267aa66fc5a52a`，原 `SHA256SUMS` 仍期待 `9c8e1c015c0b85376357c7f40114b767b3689ae0c34c6b1f7c75cbf7a7d6c2d9`。因此原清单 34/35，不能宣称 35/35。可按 `CORRECTED_ASYMPTOTIC_SHA256SUMS.txt` 在原证据目录替换后达到 35/35；**本交付未暗改用户原附件。** 原包 zip CRC 通过。

**新一轮真实重跑（调用此前 GPT 自编独立验证器，非重新编写的第三套验证器）：**

| 脚本 | 本次结果 | 证据 |
|---|---|---|
| `independent_r6_symbolic.py` | PASS；含 cU=3 负例 | `rerun_symbolic.log` |
| `independent_aux_symbolic.py` | PASS | `rerun_aux_symbolic.log` |
| `independent_t1.py` | 26,221/26,221 PASS | `rerun_t1.log` |
| `independent_balanced.py` | 23,845/23,845 PASS | `rerun_balanced.log` |
| `independent_parity.py` | 23,740/23,740 PASS | `rerun_parity.log` |
| `independent_finite.py` | ℓ=6..80 PASS | `rerun_finite.log` |
| `independent_fact1.py` | 480/480 PASS | `rerun_fact1.log` |
| `independent_dp.py` | 7 例 PASS，含 ℓ=19,20 | `rerun_dp.log` |
| `independent_relaxed_dp.py` | **本次未完成，超时**。上一轮的 3 例 PASS 日志仍存，不能冒充本轮完成。解析三段好染色下界不依赖本次 DP 重跑 | `rerun_relaxed_dp.log` 为空；历史 `relaxed_dp.log` 保留 |
| `python -O independent_r6_symbolic.py` | 正确拒绝，退出码 1 | `rerun_optimization_negative.log` |

**最终裁决：** 数学主张的独立检查仍支持 R-37 与 R-38 *proof candidates*，未发现数学变化；不过 **新版输入的原始 SHA256 manifest 失配**，应标记 `CHANGES-REQUIRED (PACKAGING)`，完成清单更新后才建议重新冻结。［公开版删去一句关于私人通信的说明。］
