
Predicting optimal chamber size for swimming cells

In the pub 'Gotta catch ‘em all: Agar microchambers for high-throughput single-cell live imaging' we are interested in gaining a quantitative understanding of how confinement affects organismal biology, including cell behavior and motility. in this notebook we analyze a publicly available resource data set, the BOSO-Micro dataset (https://doi.org/10.1371/journal.pone.0252291), which contains information about cell size, shape, and behavior for 382 unicellular species/cell types of swimming prokaryotes and eukaryotes.

Organismal size is a clear constraint on chamber size. Perhaps less obvious is the effect of an organism’s speed of movement. For example, a large organism that swims slowly would likely require a different chamber size from one that swims quickly (since the faster organism would hit the chamber boundaries more frequently).

To control for this, here we calculate the area covered/second for each organism and then estimate an appropriate chamber size for measuring open field swimming. A suggested scaling value of 200x area covered/second is used (calculated from the empirical relationship of Chlamydomonas rheinhardtii cells with 100 micron diamter chambers).
