# Stage 1: all features on a subset of observations

Here's a description of this stage quoting from the [project report](https://thinklab.com/doc/7/review#section-83):

> The all-features stage assesses feature performance and does not require computing features for all negatives. Here we selected a random subset of 3,020 (4 × 755) negatives. Little error was introduced by this optimization, since the predominant limitation to performance assessment was the small number of positives (755) rather than negatives.

## Datasets

Here are some of the notable datasets:

+ [`data/metapaths.json`](data/metapaths.json) contains information on and queries for each metapath used to generate features.
+ [`data/dwpc.tsv.bz2`](data/dwpc.tsv.bz2) contains is a tidy (long) TSV of the output from each DWPC query performed including path count (PC), degree-weighted path count (DWPC), and query runtime.

For documentation requests, open a GitHub Issue. Documentation pull requests also welcome.
