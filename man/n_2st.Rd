% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/n_2st.R
\name{n_2st}
\alias{n_2st}
\title{Determine Number of Clusters or Cluster Size for Two-Level Multisite Randomzied Trials}
\usage{
n_2st(
  d_est,
  d_sd,
  alpha = 0.05,
  power = 0.8,
  ep = NULL,
  al = NULL,
  test = "two.sided",
  plot = FALSE
)
}
\arguments{
\item{d_est}{Effect size estimate, defined as
\eqn{d = \frac{\bar x_2 - \bar x_1}
  {\sqrt{\frac{(n_1 - 1)s_1^2 + (n_2 - 1)s_2^2}{n_1 + n_2 - 2}}}}}

\item{d_sd}{Uncertainty level of the effect size estimate.}

\item{alpha}{Type I error rate. Default to be \code{.05}.}

\item{power}{Desired level of statistical power.}

\item{ep}{Desired expected power to achieve. If neither \code{ep} nor
\code{al} is specified, \code{ep} = \code{power}. An 80\% expected power
indicates that the mean or average power value is 80\% over
the specified uncertainty.}

\item{al}{Assurance level to achieve. An 80\% assurance level indicates 80\% of the
power values are above the desired statistical power over the specified uncertainty.
Default to be \code{.6}.}

\item{test}{One-sided or two-sided test. Options are either "one.sided" or "two.sided".}

\item{plot}{If TRUE, plots of J and n against the expected power or assurance level
will be printed.}
}
\value{
The required group size for a two-sample t-test.
}
\description{
\code{n_2st()} solves for the required group size for a two-sample t-test.
When the uncertainty level of the effect size is specified, this function
determines the sample size requisite that achieves the desired expected power
or assurance level. Otherwise, this function determines the sample size requisite
that achieves the desired classical power.
}
\examples{
n_2st(d_est = .5, d_sd = .1)
}
\seealso{
\url{https://winnie-wy-tse.shinyapps.io/hcb_shiny/}
}
