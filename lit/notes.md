# ARGs

- [Hudson 1991](https://www.bibsonomy.org/bibtex/2f33182bca8a8368e5d7a86fb5f3b5a5c/peter.ralph) 
    and [1983](https://www.sciencedirect.com/science/article/abs/pii/0040580983900138) described the process

- term comes from [Griffiths and Marjoram 1997](https://www.bibsonomy.org/bibtex/2d60d21cbcdf8d4328d26446b0ea3bee8/peter.ralph)

# Parsimony

- [Hudson & Kaplan 1985](https://doi.org/10.1093/genetics/111.1.147) put a lower bound on the number
    of recombination events needed by an ARG

- [Hein 1990](https://www.sciencedirect.com/science/article/abs/pii/002555649090123G)
    presents an algorithm to compute the minimum SPR distance between two trees

- [Wang 2001](https://doi.org/10.1089/106652701300099119)
    shows that finding the minimum-parsimony ARG is NP-complete

- [Myers & Griffiths 2003](https://dx.doi.org/10.1093/genetics/163.1.375)
    provided better bounds than previous;
    applies to 9.7Kb of LPL from 71 individuals with 88 SNPs

- [Song & Hein 2005](https://doi.org/10.1089/cmb.2005.12.147)
    have a new algorithm for finding a lower bound on the minimum-parsimony number of recombinations

- [Song, Wu & Gusfeld 2005](https://doi.org/10.1093/bioinformatics/bti1033)
    have a much more efficient method, called `SHRUB`, to find lower and upper bounds;
    applied to Kreitman's data that number is 7.

- [Minichello & Durbin 2006](https://pubmed.ncbi.nlm.nih.gov/17033967/)
    uses a heuristic algorithm to infer a "plausible" ARG (more or less parsimony);
    then tests branches in an ensemble of inferred ARGs for association with a trait.
    Method: `Margarita`


# Full likelihood, coalescent-theory-style

The general problem is that the full likelihood of the data
can be characterized but not efficiently computed;
requires integrating over all possible ARGs;
lots of work on how to compute it: importance sampling; MCMC.
Lots of focus on estimating theta and rho; and then maybe
sampling from the distribution of histories.

- described by Hudson

- [Griffiths & Tavaré 1994](https://doi.org/https:%2f%2fdoi.org%2f10.1006%2ftpbi.1994.1023)
    to write the likelihood as an expectation of a functional of a Markov chain going back in time;
    uses importance sampling; applied to like 50 sequences of length 20;
    software: `SEQUENCE`
    

- [Griffiths & Marjoram 1996](https://www.liebertpub.com/doi/abs/10.1089/cmb.1996.3.479)
    "A computational algorithm based on a Markov chain simulation is developed, implemented, and illustrated with examples for these inference procedures. This algorithm is very computationally intensive." Method: `recom`

![](griffiths-marjoram-1996-fig-11.png)

- [Fearnhead & Donnelly 2001](https://academic.oup.com/genetics/article/159/3/1299/6049673) does importance sampling
    follows Stephens & Donnelly in proposing a "threading" type method;
    says it does better than Kuhner et al or Griffiths & Donnelly. Method: `Infs`
    
- [Kuhner, Yamato & Felsenstein 2000](https://academic.oup.com/genetics/article/156/3/1393/6051663)
    does MCMC to estimate rho and theta by MCMCing over histories;
    but is a likelihood method (it's doing importance sampling with the MCMC).
    Called it a "recombinant genealogy".
    Applied to 9734 bp from LDL in 142 haplotypes.
    Method: `Recombine`

- [Wall 2000](https://doi.org/10.1093/oxfordjournals.molbev.a026228) benchmarked the various estimators of C = 4 N r
    with simulations; found Kuhner-Yamato-Felsenstein the best

- [Stephens and Donnelly 2002](https://doi.org/https:%2f%2fdoi.org%2f10.1111%2f1467-9868.00254)
    came up with a new importance sampling technique that seems as good as KYF

- [Nielsen 2000](https://academic.oup.com/genetics/article/154/2/931/6047972)
    is an MCMC method to estimate rho, 
    analyzes 60 sequences of 3kb with 17 SNPs.
    Actually Bayesian, as opposed to KYF; and uses a simpler nucleotide mutation model.

- [Kuhner 2006](https://doi.org/10.1093/bioinformatics/btk051) describes LAMARC 2.0
    which MCMC-integrates over unobserved genealogies with recombination
    to infer theta, growth rate, migration rate, and/or recombation rate,
    combining previous problems.

- ARGweaver [(Rasmussen, Hubisz & Siepel 2014)](https://journals.plos.org/plosgenetics/article?id=10.1371/journal.pgen.1004342)
    MCMC sampling; works on dozens of sequences for megabases

- Singer [(Deng, Nielsen & Song 2024)](https://doi.org/10.1101%2f2024.03.16.585351)
    does MCMC with the full ARG, on hundreds of samples
    

# Heuristic

- Espalier [(Rasmussen & Guo 2022)](https://doi.org/10.1101%2f2022.01.17.476639)
    uses Maximum Agreement Forests between already-inferred local trees;
    applied to examples with tens of SNPs

- Relate [(Speidel et al 2019)](https://doi.org/10.1038%2fs41588-019-0484-x)
    also builds local trees using something derived from Li & Stephens;
    applies to thousands of chromosome-scale samples

- tsinfer [(Kelleher et al 2019)](https://doi.org/10.1038%2fs41588-019-0483-y)
    based on Li & Stephens; applies to hundreds of thousands of samples

- ARG-needle [(Zhang et al 2023)](https://doi.org/10.1038%2fs41588-023-01379-x)
    threads on new samples by identifying the closest-related K samples
    and using ASMC; applies to hundreds of thousands of samples
