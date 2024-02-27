#nohup Rscript /data/mli13/learn.manqi.hetnet/all-features/7-transform.R > /data/mli13/learn.manqi.hetnet/all-features/log/trans_output.log 2>&1 &
#ps -p 233941
library(magrittr)

options(stringsAsFactors=F)

feature_df = readr::read_tsv('/data/mli13/learn.manqi.hetnet/all-features/data/matrix/rephetio-v2.0/features.tsv.bz2')
summary_df = readr::read_tsv('/data/mli13/learn.manqi.hetnet/all-features/data/feature-performance/primary-aurocs.tsv') %>%
  dplyr::filter(feature %in% colnames(feature_df))
degrees = dplyr::filter(summary_df, feature_type == 'degree')$feature
metapaths = dplyr::filter(summary_df, feature_type == 'dwpc')$feature

head(summary_df, 2)
head(feature_df, 2)

prior_df = feature_df %>%
  dplyr::mutate(prior_logit = boot::logit(prior_prob)) %>%
  dplyr::select(prior_logit)
degree_df = feature_df[, colnames(feature_df) %in% degrees]
dwpc_df = feature_df[, colnames(feature_df) %in% metapaths]
head(prior_df, 2)
head(degree_df, 2)
head(dwpc_df, 2)

#prior probability distribution
options(repr.plot.width=6, repr.plot.height=3)

feature_df %>%
  dplyr::mutate(prior_logit = boot::logit(prior_prob)) %>%
  dplyr::select(prior_prob, prior_logit) %>%
  tidyr::gather('feature', 'value') %>%
  ggplot2::ggplot(ggplot2::aes(x = value)) +
    ggplot2::facet_wrap(~ feature, scales='free') +
    ggplot2::geom_histogram(bins = 50, alpha = 0.6, fill = '#00693E') +
    ggplot2::theme_bw() +
    ggplot2::theme(strip.background=ggplot2::element_rect(fill='#FEF2E2')) +
    ggplot2::theme(plot.margin=grid::unit(c(2, 7, 2, 2), 'points')) +
    ggplot2::ylab(NULL)
    
#visualize degree features
set.seed(0)
dist_df = summary_df %>%
  dplyr::filter(feature_type == 'degree') %>%
  dplyr::mutate(nonzero_quantile = dplyr::ntile(nonzero, 10)) %>%
  dplyr::group_by(nonzero_quantile) %>%
  dplyr::sample_n(1) %>%
  dplyr::arrange(nonzero) %>%
  dplyr::select(feature, nonzero, nonzero_quantile)
  
  example_df = degree_df %>%
  dplyr::select(one_of(dist_df$feature)) %>%
  tidyr::gather(key = feature, value = value) %>%
  dplyr::inner_join(dist_df) %>%
  dplyr::mutate(nonzero = scales::percent(nonzero))

grouped_df = example_df %>%
  dplyr::group_by(feature)

all_df = dplyr::bind_rows(
  grouped_df %>% dplyr::mutate(value = value, transform='(1) identity'),
  grouped_df %>% dplyr::mutate(value = log1p(value), transform='(2) log1p(x)'),
  grouped_df %>% dplyr::mutate(value = asinh(value), transform='(3) asinh(x)')
)

options(repr.plot.width=8, repr.plot.height=15)

all_df %>%
  ggplot2::ggplot(ggplot2::aes(x = value)) +
    ggplot2::facet_wrap(nonzero_quantile + feature ~ transform + nonzero, scales='free', ncol=3,
      labeller = ggplot2::as_labeller(I, multi_line = F)) +
    ggplot2::geom_histogram(bins = 50, alpha = 0.6, fill = '#00693E') +
    ggplot2::theme_bw() +
    ggplot2::theme(strip.background=ggplot2::element_rect(fill='#FEF2E2')) +
    ggplot2::theme(plot.margin=grid::unit(c(2, 7, 2, 2), 'points')) +
    ggplot2::xlab('Degree') + ggplot2::ylab(NULL)
    
#visualize degree features

set.seed(0)
dist_df = summary_df %>%
  dplyr::filter(feature_type == 'dwpc') %>%
  dplyr::mutate(nonzero_quantile = dplyr::ntile(nonzero, 10)) %>%
  dplyr::group_by(nonzero_quantile) %>%
  dplyr::sample_n(1) %>%
  dplyr::arrange(nonzero) %>%
  dplyr::select(feature, nonzero, nonzero_quantile)
head(dist_df, 2)

example_df = dwpc_df %>%
  dplyr::select(one_of(dist_df$feature)) %>%
  tidyr::gather(key = feature, value = value) %>%
  dplyr::inner_join(dist_df) %>%
  dplyr::mutate(nonzero = scales::percent(nonzero))

grouped_df = example_df %>%
  dplyr::group_by(feature)

all_df = dplyr::bind_rows(
grouped_df %>% dplyr::mutate(value = value, transform='1-identity'),
grouped_df %>% dplyr::mutate(value = log1p(value / sd(value)), transform='2-log1p-sd'),
grouped_df %>% dplyr::mutate(value = log1p(value / mean(value)), transform='3-log1p-mean'),
grouped_df %>% dplyr::mutate(value = asinh(value / sd(value)), transform='4-asinh-sd'),
grouped_df %>% dplyr::mutate(value = asinh(value / mean(value)), transform='5-asinh-mean')
)

options(repr.plot.width=15, repr.plot.height=15)

all_df %>%
  dplyr::filter(value > 0) %>%
  ggplot2::ggplot(ggplot2::aes(x = value)) +
    ggplot2::facet_wrap(nonzero_quantile + feature ~ transform + nonzero, scales='free', ncol=5,
      labeller = ggplot2::as_labeller(I, multi_line = F)) +
    ggplot2::geom_histogram(bins = 50, alpha = 0.6, fill = '#00693E') +
    ggplot2::theme_bw() +
    ggplot2::theme(strip.background=ggplot2::element_rect(fill='#FEF2E2')) +
    ggplot2::theme(plot.margin=grid::unit(c(2, 7, 2, 2), 'points')) +
    ggplot2::xlab('DWPC (Zero-filtered)') + ggplot2::ylab(NULL) +
    ggplot2::expand_limits(x = 0)
    
#transformation sweep
grid_df = expand.grid(
  degree_transformer = c('identity', 'log1p', 'asinh'),
  dwpc_scaler = c('none', 'mean', 'sd'),
  dwpc_transformer = c('identity', 'log1p', 'asinh'),
  alpha = c(0, 1),
  seed = 1:10,
  stringsAsFactors = FALSE
) %>% dplyr::filter(dwpc_transformer != 'identity' | dwpc_scaler == 'none')

nrow(grid_df)

none = function(x) {return(1)}

to_fxn = function(x) {eval(parse(text=x))}

get_performance = function(params) {
  # Evaluate performance of specified tranformations
  dwpc_scaler = to_fxn(params['dwpc_scaler'])
  dwpc_transformer = to_fxn(params['dwpc_transformer'])
  degree_transformer = to_fxn(params[['degree_transformer']])

  X = dplyr::bind_cols(
    prior_df,
    degree_df %>%
      dplyr::mutate(across(everything(), ~degree_transformer(.))),
    dwpc_df %>%
      dplyr::mutate(across(everything(), ~dwpc_transformer(./dwpc_scaler(.))))
  ) %>% as.matrix()
  
  y_true = feature_df$status
  penalty_factor = ifelse(colnames(X) == 'prior_logit', 0, 1)
  fit = hetior::glmnet_train(X = X, y = y_true, alpha = params['alpha'], cores = 12,
                             seed = params['seed'], penalty.factor=penalty_factor, lambda.min.ratio=1e-6, nlambda=200)
  df = data.frame(t(params), auroc = fit$vtm$auroc, auprc = fit$vtm$auprc)
  return(df)
}

perf_df = grid_df %>% apply(1, get_performance) %>% dplyr::bind_rows()

head(perf_df, 4)

#average results across seeds
summary_df = perf_df %>%
  dplyr::group_by(degree_transformer, dwpc_scaler, dwpc_transformer, alpha) %>%
  dplyr::do(
    dplyr::bind_cols(
      ggplot2::mean_cl_normal(.$auroc) %>% dplyr::rename(auroc=y, auroc_lower=ymin, auroc_upper=ymax),
      ggplot2::mean_cl_normal(.$auprc) %>% dplyr::rename(auprc=y, auprc_lower=ymin, auprc_upper=ymax))
  ) %>%
  dplyr::ungroup() %>%
  dplyr::arrange(desc(auroc))

head(summary_df, 2)

summary_df %>% readr::write_tsv('/data/mli13/learn.manqi.hetnet/all-features/data/transformation-sweep.tsv')