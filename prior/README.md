# Prior probability of treatment

This directory computes the prior probability of treatment for compound–disease pairs using network permutation.

## Background

This overview and motivation is described in the [project report](https://thinklab.com/doc/7/review#section-84) as follows:

> The 755 treatments in Hetionet v1.0 are not evenly distributed between all compounds and diseases. For example, methotrexate treats 19 diseases and hypertension is treated by 68 compounds. We [estimated](https://doi.org/10.15363/thinklab.d201) a prior probability of treatment — based only on the treatment degree of the source compound and target disease — on 744,975 permutations of the bipartite treatment network. Methotrexate received a 79.6% prior probability of treating hypertension, whereas a compound and disease that both had only one treatment received a prior of 0.12%.

> Across the 209,168 compound–disease pairs, the prior predicted the known treatments with AUROC = 97.9%. The strength of this association threatened to dominate our predictions. However, not modeling the prior can lead to omitted-variable bias and confounded proxy variables. To address the issue, we included the logit-transformed prior, without any regularization, as a term in the model. This restricted model fitting to the 29,799 observations with a nonzero prior — corresponding to the 387 compounds and 77 diseases with at least one treatment. To enable predictions for all 209,168 observations, we set the prior for each compound–disease pair to the overall prevalence of positives (0.36%).

> This method succeeded at accommodating the treatment degrees. The prior probabilities performed poorly on the validation sets with AUROC = 54.1% on DrugCentral indications and AUROC = 62.5% on clinical trials. This performance dropoff compared to training shows the danger of encoding treatment degree into predictions. The benefits of our solution are highlighted by the superior validation performance of our predictions compared to the prior.

See [this discussion](https://thinklab.com/discussion/network-edge-prediction-estimating-the-prior/201#2) for more information and a summary of the results of this method.

## Notebooks

+ [`1-prior.ipynb`](1-prior.ipynb) computes the prior probabilities in Python, which are exported to [`data`](data).
+ [`2-prior-viz.ipynb`](2-prior-viz.ipynb) visualizes the prior probabilities based on treatment degree in R. Visualization are exported to [`viz`](viz).
