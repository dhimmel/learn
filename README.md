# Machine learning for Project Rephetio

[![Latest Zenodo DOI](https://zenodo.org/badge/42207400.svg)](https://zenodo.org/badge/latestdoi/42207400)

_Systematic predictions of whether a compound treats a disease using hetnet data integration._

This is the machine learning repository for [Project Rephetio](http://thinklab.com/p/rephetio "Rephetio on Thinklab · Repurposing drugs on a hetnet"). The repository covers:

+ [extracting features](https://thinklab.com/d/210#2) from [Hetionet v1.0](https://github.com/dhimmel/hetionet/tree/59c448fd912555f84b9822b4f49b431b696aea15) and its [permuted](https://thinklab.com/d/178) derivatives.
+ computing the performance of each metapath-based feature, as available in [this interactive table](http://het.io/repurpose/metapaths.html).
+ computing the [prior probability of treatment](https://thinklab.com/d/201#2) via edge-swap permutation
+ fitting a regularized [logistic regression model](https://thinklab.com/d/210#4) to predict the probability that each compound treats each disease.
+ evaluating the [performance of predictions](https://thinklab.com/d/203#2) on several catalogs of medical indications.
+ for each prediction, computing the [contributions](https://thinklab.com/discussion/d/229#2) of specific metapaths and paths.

For a comprehensive description of Project Rephetio, see the manuscript titled [**Systematic integration of biomedical knowledge prioritizes drugs for repurposing**](https://doi.org/10.1101/087619). The predictions from this repository are browsable at [het.io/repurpose](http://het.io/repurpose/ "Project Rephetio Prediction Browser").

## Execution and directories

The computations in this repository are performed by a series of Jupyter notebooks, using approximately the conda environment [specified here](https://github.com/dhimmel/integrate/blob/725f4e4b4a737cfb15abe55ef36386c23e1c4f1f/environment.yml). [`config.ini`](config.ini) provides version information for external data dependencies. 

This repository is operated in the following order:

1. [`summary`](summary): extract connected compounds and connected diseases as well as the gold standard of disease-modifying indications to be used throughout this repository.
+ [`optimize`](optimize): analyses for benchmarking and optimizing our Cypher queries.
+ [`prior`](prior): compute the prior probability of treatment between each compound and disease.
+ [`all-features`](all-features): extract and transform features for all 1,206 metapaths on Hetionet v1.0 and the 5 permuted derivatives. For efficiency, only a subset of compound–disease pairs are analyzed. Assess the performance of each feature separately.
+ [`validate`](validate): create indication sets to systematically evaluate the performance of predictions.
+ [`prediction`](prediction): extract and transform features for all 209,168 compound–disease pairs on pre-selected features. Predict the probability of treatment for each compound–disease pair. Export metapath and path contribution information.

Note however that since the repository structure evolved over time, it may not be possible to rerun all notebooks sequentially. Some notebooks may assume a previous version of the repository, hence requiring reversion to a past commit. Furthermore, until [recently](https://github.com/dhimmel/learn/commit/8792c2e408e790cd8d77adb34d013961f4d5c4f0) large datasets were not tracked and may have to be regenerated. Now Git LFS is used to track large files.

## Hetnet & Neo4j server nomenclature

The hetnet nomenclature of this repository predates the naming and versioning system of [Hetionet v1.0](https://github.com/dhimmel/hetionet/tree/59c448fd912555f84b9822b4f49b431b696aea15). Confusingly, the hetnet referred to in this repository as `rephetio-v2.0` is more accurately `hetionet-v1.0`. Accordingly, `rephetio-v2.0_perm-1` is `hetionet-v1.0_perm-1`. This repository queries Hetionet v1.0 through Neo4j servers residing in a local clone of [`dhimmel/integrate`](https://github.com/dhimmel/integrate/tree/725f4e4b4a737cfb15abe55ef36386c23e1c4f1f). Archives of these Neo4j database stores are available for the [unpermuted](https://github.com/dhimmel/hetionet/blob/7eec671b230212b5cd5b92f583884639045c4735/hetnet/neo4j/hetionet-v1.0.db.tar.bz2) and [permuted](https://github.com/dhimmel/hetionet/tree/7eec671b230212b5cd5b92f583884639045c4735/hetnet/permuted/neo4j) hetnets, using the newer `hetionet` nomenclature.

## Questions & Feedback

For questions or feedback related to the code or data in this repository, please use [GitHub Issues](https://github.com/dhimmel/learn/issues). For other questions related to Project Rephetio, please comment on the relevant [discussion](https://thinklab.com/p/rephetio/discussion) or [report section](https://thinklab.com/doc/7/review) on _Thinklab_. Both venues support markdown formatting. To keep things organized, please create new issues/discussions unless the subject is directly related to previous content in an existing thread.

## License

All original content in this repository is released under [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/ "CC0 1.0 Universal · Public Domain Dedication"). The repository includes [Disease Ontology](http://disease-ontology.org/) and [DrugBank](http://www.drugbank.ca/) identifiers, which may impose additional reuse restrictions.
