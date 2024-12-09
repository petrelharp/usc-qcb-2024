---
title: "Uncovering the time axis of recombining genomes using ARGs"
author: "Peter Ralph <br/> University of Oregon <br/> Dept of Data Science"
date: "Quantitative and Computational Biology Seminar<br/> University of Southern California // 5 December 2024"
---

# Outline

::: columns
:::::: {.column width=60%}

1. Ancestral Recombination Graphs (ARGs)
2. Tree sequences: storage and computation
3. Variational dating of ARGs
4. Application: pathogenic variants

::::::
:::::: {.column width=60%}

::: {.fragment .floatright}
![tskit logo](figs/tskit_logo.png){width=60%}

[tskit.dev](https://tskit.dev)
:::

:::::: 
::: 

<!--
Abstract: The Ancestral Recombination Graph (or, ARG) is a way of representing all ancestral relationships
between a collection of recombining genomes. It can be viewed as a collection of trees along the genome
or as a set of inheritance relationships between modern and ancestral haplotypes. If known, it gives
a more natural and informative way to summarize genetic variation: for instance, by providing ages and
inheritance patterns of the mutations that led to modern variants. In this talk I will summarize recent
progress in estimating whole-genome ARGs, including from Biobank-scale datasets, and describe how this
way of representing data leads to orders-of-magnitude improvements in storage and computation. I will also
describe a (variational) Bayesian method for estimating the times of events in a given ARG, leading to
substantial improvements in dating accuracy. Using the new method on ARGs estimated from 50,000 whole genomes,
I will show that inferred dates are more informative about SNP pathogenicity than allele frequency.
This is one example of how ARGs provide a way to summarize genetic variation without relying on
the more usual problematic and inaccurate division into "populations".
-->

<!--
title-slide-attributes:
    data-background-image: /path/to/title_image.png
    data-background-size: contain
-->

--------------------

> UO is located on the traditional indigenous homeland of the Kalapuya people.
Kalapuya people were dispossessed of their indigenous homeland by the United States government and forcibly removed.
Today, Kalapuya descendants are primarily citizens of the Confederated Tribes of Grand Ronde and the Confederated Tribes of Siletz Indians,
and continue to make important contributions to their communities, to the UO, to Oregon, and to the world.



# What's an ARG?

## Genomes

> - are very big ($10^7$--$10^{12}$ nucleotides)
> - encode the basic *mechanisms* of life
> - reflect past *history* and *process*

. . .

![Genotype matrix from Kreitman 1983](figs/kreitman/kreitman-1983.png)


## Meiosis & Recombination

::: {.columns}
::::::: {.column width=50%}

![recombination](figs/recombination-cartoon-crop.png)

:::
::::::: {.column width=50%}

- You have two copies of each chromosome, 
  one from each parent.

- When you make a gamete, the copies *recombine*, at Poisson($\rho$) locations.

- *Mutations* appear at Poisson($\mu$) locations.

:::
::::::

## What is an ARG?

For a set of sampled chromosomes,
an ARG describes
at each position along the genome the genealogical tree
that says how they are related.


![Trees along a chromosome](figs/example.svg)

## What is an ARG?

::: columns
:::::: {.column width=30%}

Better, in some ways, is to think of an ARG
as a set of relationships between haplotypes.

::: fragment
An ARG, broadly, is a graph-like structure
that tells us how a set of sampled chromosomes
are related to each other,
along a recombining genome.
:::

::::::
:::::: {.column .centered}

![](lit/hudson1991.png){width=60%}

::::::
:::



# ARG inference: a quick overview


------------

<!-- see lit/notes.md -->

::: {.columns}
:::::: {.column width=50%}

ARG/coalescent theory:

::: incremental
- [Hudson 1983, 1991](https://www.sciencedirect.com/science/article/abs/pii/0040580983900138)
- [Griffiths & Tavaré 1994](https://doi.org/https:%2f%2fdoi.org%2f10.1006%2ftpbi.1994.1023)
- [Griffiths & Marjoram 1997](https://www.bibsonomy.org/bibtex/2d60d21cbcdf8d4328d26446b0ea3bee8/peter.ralph)
:::



::: fragment
Parsimony:
dozens of samples, dozens of SNPs:
:::

::: incremental
- [Hudson & Kaplan 1985](https://doi.org/10.1093/genetics/111.1.147)
- [Hein 1990](https://www.sciencedirect.com/science/article/abs/pii/002555649090123G)
- [Myers & Griffiths 2003](https://dx.doi.org/10.1093/genetics/163.1.375)
- [Song & Hein 2005](https://doi.org/10.1089/cmb.2005.12.147)
- [Song, Wu & Gusfeld 2005](https://doi.org/10.1093/bioinformatics/bti1033)
- [Minichello & Durbin 2006](https://pubmed.ncbi.nlm.nih.gov/17033967/)
:::

::::::
:::::: {.column width=50%}

::: fragment
Full likelihood: integrating over possible ARGs;
dozens of samples, a few dozen SNPs:
:::

::: incremental
- [Griffiths & Marjoram 1996](https://www.liebertpub.com/doi/abs/10.1089/cmb.1996.3.479)
- [Kuhner, Yamato & Felsenstein 2000](https://academic.oup.com/genetics/article/156/3/1393/6051663)
- [Nielsen 2000](https://academic.oup.com/genetics/article/154/2/931/6047972)
- [Fearnhead & Donnelly 2001](https://academic.oup.com/genetics/article/159/3/1299/6049673)
- [Stephens and Donnelly 2002](https://doi.org/https:%2f%2fdoi.org%2f10.1111%2f1467-9868.00254)
- ARGweaver [(Rasmussen et al 2014)](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004342)
    MCMC; dozens of samples for *megabases*
:::

::: fragment
"Modern" methods (whole chromosomes!):
:::

::: incremental
- Relate [(Speidel et al 2019)](https://doi.org/10.1038%2fs41588-019-0484-x)
    local tree building + reconciliation; $n \sim 10^3$
- tsinfer [(Kelleher et al 2019)](https://doi.org/10.1038%2fs41588-019-0483-y)
    haplotype matching; $n \sim 10^5$
- ARG-needle [(Zhang et al 2023)](https://doi.org/10.1038%2fs41588-023-01379-x)
    haplotype matching + [ASMC](https://palamaralab.github.io/software/asmc/); $n \sim 10^5$
- Singer [(Deng, Nielsen & Song 2024)](https://doi.org/10.1101%2f2024.03.16.585351)
    MCMC with full likelihood; $n \sim 10^2$
:::

::::::
:::

--------------

::: {.r-stack .centered}

![](lit/hudson1991.png){width=50%}

::::: fragment
![](lit/griffiths-marjoram-1997.png){width=50%}
:::::

::::: fragment
![](lit/kuhner-yamato-felsenstein-2000.png){width=60%}
:::::

::::: fragment
![](lit/fearnhead-donnelly-2001.png){width=50%}
:::::

::::: fragment
![](lit/song-wu-gusfield-2005.png){width=80%}
:::::

::::: fragment
![](lit/song-hein-2005.png){width=60%}
:::::

::::: fragment
![](lit/rasmussen2014.png){width=80%}
:::::

::::: fragment
![](lit/kelleher2019.png){width=70%}
:::::

:::

---------

![](figs/kreitman/inference.png)

::: {.caption}
from [Wong et al 2024, *Genetics*](https://academic.oup.com/genetics/article/228/1/iyae100/7714980)
:::


<!-- Tree sequences: storage and computation -->

# Storage and computation

::: floatright
![tskit logo](figs/tskit_logo.png){width=40%}
:::

-------------

One way to view an ARG is as a sequence of genealogical trees
(with many nodes shared between adjacent trees).

. . .

![Trees along a chromosome](figs/example.svg)


----------------------

The **succinct tree sequence**

::: {.floatright}
is a way to succinctly describe this, er, sequence of trees

*and* the resulting genome sequences.

:::: {.caption}
[Kelleher, Etheridge, & McVean](http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004842) 
::::

:::

. . .

<div class="columns" style="clear: both;">
:::::: {.column width=50%}

![tskit logo](figs/tskit_logo.png){width=80%}

::::::
:::::: {.column width=50%}

::: {.floatright}
![jerome kelleher](figs/jerome.jpeg){width=50%}

:::: {.caption}
jerome kelleher
::::

:::

::::::
</div>



## Example: three samples; two trees; two variant sites

![Example tree sequence](figs/example_tree_sequence.png)


## Nodes and edges

Edges 

:   Who inherits from who.

    Records: interval (left, right); parent node; child node.

Nodes 

:   The ancestors those happen in.

    Records: time ago (of birth); ID (implicit).

-------------------

![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.0.png)

-------------------


![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.1.png)

-------------------


![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.2.png)

-------------------


![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.3.png)

-------------------


![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.4.png)

-------------------


![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.5.png)

-------------------

![Building a tree sequence](nodes_edges_walkthrough/nodes_edges_walkthrough.6.png)


## Sites and mutations

Mutations

:   When state changes along the tree.

    Records: site it occured at; node it occurred in; derived state.

Sites 

:   Where mutations fall on the genome.

    Records: genomic position; ancestral (root) state; ID (implicit).


------------------

![Adding mutations](sites_muts_walkthrough/sites_muts_walkthrough.0.png)

------------------

![Adding mutations](sites_muts_walkthrough/sites_muts_walkthrough.1.png)

------------------

![Adding mutations](sites_muts_walkthrough/sites_muts_walkthrough.2.png)

------------------

![Adding mutations](sites_muts_walkthrough/sites_muts_walkthrough.3.png)

------------------

![Adding mutations](sites_muts_walkthrough/sites_muts_walkthrough.4.png)

------------------

**The result:**
an encoding of the genomes *and* all the genealogical trees.

::: {.centered}
![Example tree sequence](figs/example_tree_sequence.png)
:::


<!-- # How's it work? -->


## File sizes

::: {.centered}
![file sizes](figs/tsinfer_sizes.png){width=90%}
:::

::: {.caption}
100Mb chromosomes;
from [Kelleher et al 2018, *Inferring whole-genome histories in large population datasets*](https://www.nature.com/articles/s41588-019-0483-y), Nature Genetics
:::

<!-- Estimated sizes of files required to store the genetic variation data for a
simulated human-like chromosome (100 megabases) for up to 10 billion haploid
(5 billion diploid) samples. Simulations were run for 10 1 up to 10 7 haplotypes
using msprime [Kelleher et al., 2016], and the sizes of the resulting files plotted
(points). -->


---------------

![genotypes](figs/ts_ex/tree_sequence_genotypes.png)

---------------

![genotypes and a tree](figs/ts_ex/tree_sequence_genotype_and_tree.png)

---------------

![genotypes and the next tree](figs/ts_ex/tree_sequence_next_genotype_and_tree.png)



## For $N$ samples genotyped at $M$ sites

::: {.columns}
::::::: {.column width=50%}


*Genotype matrix*:

$N \times M$ things.


:::
::::::: {.column width=50%}

*Tree sequence:*

- $2N-2$ edges for the first tree
- $\sim 4$ edges per each of $T$ trees
- $M$ mutations

$O(N + T + M)$ things

:::
:::::::

![genotypes and a tree](figs/ts_ex/tree_sequence_genotype_and_tree.png){width=60%}



<!-- # Summarizing genomes and genealogies -->

## Fast genotype statistics

::: {.centered}
![efficiency of treestat computation](figs/treestats/benchmarks_without_copy_longer_genome.png){width=70%}
:::

::: {.caption}
from [R., Thornton and Kelleher 2019, *Efficiently summarizing relationships in large samples*](https://academic.oup.com/genetics/article/215/3/779/5930459), Genetics
:::



## Summaries of genotypes and genealogies

::: {.columns}
:::::: {.column width=47%}

*Genotypes:*

1. For each site,
2. look at who has which alleles,
3. and add a *summary* of these values to our running total.

*Example:*
genetic distance
counts how many mutations differ between two sequences.

:::
:::::: {.column width=5%}

:::
:::::: {.column width=47%}

![site stats](figs/ts_ex/tree_sequence_site.png)

:::
::::::

## Summaries of genotypes and genealogies

::: {.columns}
:::::: {.column width=47%}


*Trees:*

1. For each branch,
2. look at who would inherit mutations on that branch,
3. and add the *expected contribution* to the running total.

*Example:*
the mean time to most recent common ancestor between two sequences.

:::
:::::: {.column width=5%}

:::
:::::: {.column width=47%}

![branch stats](figs/ts_ex/tree_sequence_branch.png)

:::
::::::

##

Given

1. a *weight* $w_i \in \mathbb{R}^n$ for each *sample node*, and
2. a *summary function* $f : \mathbb{R}^n \to \mathbb{R}$,

. . .

the **Site** statistic 
$$\begin{equation}
 \text{Site}(f,w) = \sum_{i: \text{sites}} \sum_{a: \text{alleles}_i} f(w_a)
\end{equation}$$
is the total summarized weights of all mutations,

. . .

and the **Branch** statistic 
$$\begin{equation}
 \text{Branch}(f,w) = \sum_{T: \text{trees}} s_T \sum_{b: \text{branches}_T} f(w_b) \ell_b
\end{equation}$$
is the *expected value* of $\text{Site}(f,w)$ under Poisson(1) mutation, given the trees.

## 

With genealogies *fixed*, and averaging only over *mutations* with rate $\mu$,
$$\begin{equation}
    \text{Branch}(f, w) = \frac{1}{\mu} \mathbb{E}\left[ \text{Site}(f, w) \vert T \right] .
\end{equation}$$

. . .

Dealing directly with genealogies
removes the layer of noise due to mutation:
$$\begin{equation}
    \frac{1}{\mu^2} \text{var}\left[\text{Site}(f,w)\right]
    =
    \text{var}\left[\text{Branch}(f,w)\right]
    +
    \frac{1}{n}
    \mathbb{E}\left[\text{Branch}(f^2,w)\right]
\end{equation}$$

. . .

and might produce *unbiased* estimates from ascertained genotype data.

::: {.caption .greyed .floatright}
also see R., TPB, 2019
:::

## 

:::: {.columns}
:::::::: {.column width=60%}


![duality in 1000G data](figs/treestats/relate_chr20_site_div_branch.1000000.diversity.png){width=100%}

:::
:::::::: {.column width=40%}

Duality, on 1000 Genomes data? Not quite...

- variation in mutation rate?
- biased gene conversion?
- selection?
- inference artifacts?

::: {.caption}
*Tree sequence from [Speidel et al 2019](https://www.nature.com/articles/s41588-019-0484-x).*
:::

:::
::::::::


# The tree sequence as a sparse matrix

*Problem:* given a $N \times M$ genotype matrix $G$ (of 0/1s)
and a $M$-vector $v$, compute $Gv$.

. . .

If $v_j$ is the additive effect of SNP $j$,
then $(Gv)_i$ is the genetic value of chromosome $i$.


## Matrix multiplication

*Problem:* compute $G1$, the number of mutations that each genome carries.

::: r-stack

:::: fragment
![](figs/tree_sequence/summing_down_00.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_01.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_02.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_03.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_04.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_05.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_06.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_07.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_08.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_09.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_10.png)
::::

:::: fragment
![](figs/tree_sequence/summing_down_11.png)
::::

:::

-------

::: columns
:::::: column
*Naive complexity:* $O(NM)$

*Tree sequence:* $O(N + M + T)$

::: fragment
Similar: relatedness matrix-vector product
(used in GWAS, genomic prediction, etc).
:::

:::::::
::::::: {.column .centered}

![](figs/tree_sequence/summing_down_10.png)

:::::::
:::



# Application: pathogenic variants

## {data-background-image="figs/gel-rare-diseases.png" data-background-position=center data-background-size=100%}

## the [UK 100,000 Genomes project](https://www.genomicsengland.co.uk/initiatives/100000-genomes-project)

::: columns
:::::: {.column width=65%}
![Sam Tallman](figs/folks/Sam-Tallman.jpg){width=30%}
![Yan Wong](figs/folks/yan_wong.jpg){width=30%}
![Ben Jeffery](figs/folks/ben_jeffery.jpg){width=30%}
![Jerome Kelleher](figs/folks/jerome_kelleher.jpg){width=30%}
![Duncan Mbuli-Robertson](figs/folks/duncan-mr.jpeg){width=30%}
![Nate Pope](figs/nate-pope.png){width=30%}
:::::: 
:::::: {.column width=35%}
![tskit logo](figs/tskit_logo.png){width=60%}

Sam Tallman

Yan Wong

Ben Jeffery

Jerome Kelleher

Duncan Mbuli-Robertson

Nate Pope

::: fragment
*slides in part due to Sam Tallman*
:::

:::::: 
::: 

## The 100,000 Genomes Project

::: columns
:::::: {.column width=60%}

- UK initiative to sequence 100,000 genomes from 85,000 NHS patients
    and family members affected by rare disease or cancer.

- 71,800 participants (probands and family members) across over 190 rare diseases,
    none with genetic diagnoses prior to recruitment.

- Since 2018, over 6,000 genetic diagnoses

:::::: 
:::::: {.column width=40%}

![](figs/gel-logo.png){width=90%}

:::::: 
::: 

## Motivation: penetrant, pathogenic variants usually rare

::: centered
![](figs/sam/variant-classification.jpg)
:::

::: caption
[Nykamp et al. 2017](https://www.nature.com/articles/gim201737)
:::

## But: datasets are notoriously unbalanced

::: columns
:::::: {.columns width=50%}

::::: fragment
![](figs/genome-study-representation.png){width=80%}

::: caption
Sam Tallman
:::
:::::


:::::: 
:::::: {.columns width=50%}


:::: fragment

![](figs/manrai_2016_nejm.jpg){width=100%}

::: caption
[Manrai et al 2016](https://www.nejm.org/doi/pdf/10.1056/NEJMsa1507092),
*Genetic Misdiagnoses and the Potential for Health Disparities*
:::

::::

:::::: 
::: 

## What about age? {data-background-image="figs/folks/yan_wong.jpg" data-background-position="bottom 50px right 50px" data-background-size=10%}

::: r-stack

:::: fragment
![](figs/sampling_sim_ages_l1.png){width=90%}
::::

:::: fragment
![](figs/sampling_sim_ages_l1_l2.png){width=90%}
::::

:::



# Variational dating: tsdate 0.2

::: centered
![](figs/tsdate_logo.png){width=30%}
:::

::: floatright
![tsNate](figs/nate-pope.png){width=50%}
:::

::: {.caption .floatright}
Nate Pope
:::

## Dating an ARG

::: columns
::::::: {.column width=50%}

*Given* an ARG with:

- nodes $\mathcal{N}$
- edges $\mathcal{E} \subset \{i \to j : i, j \in \mathcal{N}\}$
- mutation counts per edge $\{y_{ij} : ij \in \mathcal{E}\}$
- *sample* nodes with known time

*Infer:*

- times $\{t_i\}$ of remaining nodes
- satisfying the constraints $\{t_i < t_j : i \to j \in \mathcal{E}\}$

:::::::
::::::: {.column width=50%}

:::: r-stack

![](figs/dating_problem/dating_problem_00.png)

::: fragment
![](figs/dating_problem/dating_problem_01.png)
:::

::: fragment
![](figs/dating_problem/dating_problem_02.png)
:::

::: fragment
![](figs/dating_problem/dating_problem_03.png)
:::

::: fragment
![](figs/dating_problem/dating_problem_04.png)
:::

::::

:::::::
:::


## Dating an ARG

::: columns
::::::: {.column width=50%}

*Goal:* find $\{t_i\}$

*The model:*
with mutation rate $\mu$, edge span $s_{ij}$:
$$y_{ij} \sim \text{Poisson}(\mu s_{ij} (t_j - t_i) )$$

::: fragment
*The MLE:* minimize
$$\begin{aligned}&\sum_{ij \in \mathcal{E}} \mu s_{ij} (t_j - t_j) \\&\qquad{}- y_{ij} \log\left(\mu s_{ij} (t_j - t_j)\right)\end{aligned}$$
subject to $\{t_i < t_j : i \to j \in \mathcal{E}\}$
:::

:::::::
::::::: {.column width=50%}

![](figs/dating_problem/dating_problem_04.png)

:::::::
:::

## But, what about uncertainty?

::: columns
::::::: {.column width=50%}

*New goal*: infer $t = \{t_i\}$, but Bayesian

::: incremental

- Given a prior $p(t)$,

- the per-edge likelihood is
$$p(y_{ij}|t_i-t_j) \propto (t_j - t_j)^{y_{ij}} e^{-\mu s_{ij} (t_i - t_j)}$$

- the full likelihood is
$$p(t,y) = p(t) \prod_{ij} p(y_{ij}|t_i - t_j)$$

- and so the marginal posterior on $t_i$ is
$$p(t_i|y) = \frac{\int p(t,y) dt_{\setminus i}}{\int p(t,y) dt}$$

- but, those integrals are rather difficult.

:::

:::::::
::::::: {.column width=50%}

::: floatright
![](figs/dating_problem/dating_problem_05.png){width=120%}
:::

:::::::
:::

## Variational approximation

::: columns
::::::: {.column width=70%}

- Approximate posterior marginals
    by Gamma distribution

- Fit by matching moments

- Result (hopefully) has exact marginal moments
    but ignores dependence in posterior

:::::::
::::::: {.column width=70%}

::: r-stack

:::: fragment
![](figs/nate/plot_like.png)
::::

:::: fragment
![](figs/nate/plot_exact.png)
::::

:::: fragment
![](figs/nate/plot_both.png)
::::

:::

::::::: 
::: 


<!--
## Expectation propagation

factor variational posterior
into edge terms (like true posterior)

then do iterative refinement of edge contributions

that reduces to adjusting moments for $i$ and $j$
thanks to exponential family magic

and some serious computational magic
-->

## Some assembly required


::: columns
::::::: {.column width=70%}

- Fit by expectation propagation,
- requiring efficient stable computation of ${}_2F_1(a,b;c;z)$.

Additional magic:

- ambiguous singleton phasing
- better prior on root ages
- "recalibration" of times to enforce molecular clock

:::::::
::::::: {.column width=70%}

![](figs/nate-pope-hat.png)

::::::: 
::: 

## Validation: simulation {data-background-image="figs/folks/yan_wong.jpg" data-background-position="bottom 50px right 50px" data-background-size=10%}


::: r-stack

:::: fragment
![](figs/sampling_sim_sub_l1_l2.png){width=70%}
::::

:::: fragment
![](figs/sampling_sim_sub_l1_l2_l3.png){width=70%}
::::

:::


## Validation: real data {data-background-image="figs/folks/yan_wong.jpg" data-background-position="bottom 50px right 50px" data-background-size=10%}

![](figs/validation_sub.png)


# Back to the data

## {data-background-image="figs/folks/ben_jeffery.jpg" data-background-position="bottom 50px right 50px" data-background-size=10%}

We built the world’s largest whole-chromosome tree sequence from the phased 100,000 Genomes Project (aggV2) dataset.

5,680,570 hypothetical ancestors along chromosome 17
(as an example). ~870Mb.

![](figs/sam/chr17age_vs_freq.png)

## ADAC

Age Divergence at Allele Count (ADAC) quantifies (as an odds ratio) the probability that a given mutation is older than expected relative to some reference set of mutations at the same frequency in the data

::: r-stack

::: fragment
![](figs/sam/adac-defn.png)
:::

::: fragment
![](figs/sam/adac-defn2.png)
:::

:::

## Deleterious variants are enriched in recent times

![](figs/sam/missense_enrichment.png)

-------


![](figs/sam/enrichment3.png)

-----------

![](figs/sam/example-indiv.png)

## Conclusions

- Mutations may be rare because they are recent
    or just because the individual's ancestry is not well-represented in the data.

- ARGs capture the complex and continuous nature of human genetic ancestry. 

- Mutations' age estimation reflects this uncertainty (at single locus resolution). 

- ARG inference and variant dating methods that work well with
    large, heterogeneous, and unbalanced biobanks
    can provide valuable insights into genetic variation
    without the need for discrete categorizations.


# Wrap-up

## Software development goals

::: {.columns}
:::::: {.column width=50%}

- open
- welcoming and supportive
- reproducible and well-tested
- backwards compatible
- well-documented
- capacity building

::: {.centered}
![popsim logo](figs/popsim.png){width=35%}
:::

[PopSim Consortium](https://popsim-consortium.github.io/stdpopsim-docs/stable/index.html)

:::
:::::: {.column width=50%}


::: {.centered}
![tskit logo](figs/tskit_logo.png){width=60%}

[tskit.dev](https://tskit.dev)

![SLiM logo](figs/slim_logo.png){width=80%}
:::

:::
::::::


## Thanks!

:::: {.columns}
:::::::: {.column width=40%}

<div style="font-size: 85%;">
- Andy Kern
- Nate Pope
- Victoria Caudill
- Murillo Rodrigues 
- Gilia Patterson
- Chris Smith
- Thomas Forest
- Jiseon Min
- Clara Rehmann
- Anastasia Teterina
- Angel Rivera-Colon
<!--
- Bruce Edelman
- Matt Lukac
- Saurabh Belsare
- Gabby Coffing
- Jeff Adrion
- CJ Battey
- Jared Galloway
-->
- the rest of [the Co-Lab](https://kr-colab.github.io/people)

Funding:

- NIH NIGMS
- NSF DBI

</div>

<img src="figs/KernRalph_5x5.png" alt="KR-colab logo" style="width: 50%; margin: 0px;"/>

::::
:::::::: {.column width=60%}

:::::::::: {.columns}
::::::::::::: {.column width=30%}

<div style="font-size: 85%;">


- Jerome Kelleher
- Ben Haller
- Yan Wong
- Ben Jeffery
- Sam Tallman
- Duncan Mbuli-Robertson
- Hanbin Lee
- Gregor Gorjanc
- Elsie Chevy
- Madeline Chase
- Sean Stankowski
- Matt Streisfeld
<!--
- Georgia Tsambos
- Jaime Ashander
- Jared Galloway
- Gideon Bradburd
- Bill Cresko
- Alison Etheridge
- Evan McCartney-Melstad
- Brad Shaffer
-->

</div>

:::::::::::::
::::::::::::: {.column width=30%}

<div class=centered style="margin-top: -60px;">
<img src="figs/tskit_logo.png" alt="tskit logo" style="width: 60%; margin: 10px;"/>
<img src="figs/slim_logo.png" alt="SLiM logo" style="width: 90%; margin: 10px;"/>
</div>

:::::::::::::
::::::::::

<div style="margin-top: -30px;">
![](figs/colab.png){width=80%}
</div>

::::
::::::::




## {data-background-image="figs/guillemots_thanks.png" data-background-position=center data-background-size=50%}
