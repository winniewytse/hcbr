% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Jn_msrt2.R
\name{Jn_msrt2}
\alias{Jn_msrt2}
\title{Determine Number of Clusters or Cluster Size for Two-Level Multisite Randomzied Trials}
\usage{
Jn_msrt2(
  d_est,
  d_sd,
  rho_est,
  rho_sd,
  omega_est,
  omega_sd,
  rsq1 = 0,
  rsq2 = 0,
  J = NULL,
  n = NULL,
  K = 0,
  P = 0.5,
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
\eqn{\delta = \frac{\gamma_{01}}{\tau^2 + \sigma^2}},
where \eqn{\gamma_{01}} is the main effect of the treatment on the outcome,
\eqn{\tau^2} is the variance of the cluster-specific random effect
in the unconditional model (without covariates), and
\eqn{\sigma^2} is the variance of the random error in the unconditional model.}

\item{d_sd}{Uncertainty level of the effect size estimate.}

\item{rho_est}{Intraclass correlation estimate, defined as
\eqn{\rho = \frac{\tau^2}{\tau^2 + \sigma^2}}, where \eqn{\tau^2} and \eqn{\sigma^2}
are the variance components in the unconditional model.}

\item{rho_sd}{Uncertainty level of the intraclass correlation estimate.}

\item{omega_est}{Estimate of the treatment effect hetereogeneity, defined as
\eqn{\omega = \frac{\tau_1^2}{\tau_0^2}} where \eqn{\tau_0^2} is the variance of the
intercept random component and \eqn{\tau_1^2} is the variance of the treatment
random effect.}

\item{omega_sd}{Uncertainty level of the treatment effect hetereogeneity estimate.}

\item{rsq1}{Estimate of variance explained by the level-1 (e.g., individual-level) covariates.}

\item{rsq2}{Estimate of variance explained by the cluster-level covariates.}

\item{J}{Number of clusters. Determine \code{n} if \code{J} is specified.}

\item{n}{Cluster size. Determine \code{J} if \code{n} is specified.}

\item{K}{Number of cluster-level covariates.}

\item{P}{Proportion of the clusters that is treatment group.}

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
The required J or n and optional plots that show the curves of
expected power/assurance level.
}
\description{
\code{Jn_msrt2()} solves for the required number of clusters (J) or cluster size (n)
for a two-level MSRT using the HCB approach. When the uncertainty level of a parameter
is specified, this function determines the minimum required sample size that achieves
the desired expected power or assurance level.
}
\examples{
Jn_msrt2(d_est = .5, d_sd = .1, rho_est = .1, rho_sd = .1,
         omega_est = .3, omega_sd = .1, J = 30)
Jn_msrt2(d_est = .5, d_sd = 0, rho_est = .1, rho_sd = 0,
         omega_est = .3, omega_sd = 0, n = 5)
}
\seealso{
\url{https://winnie-wy-tse.shinyapps.io/hcb_shiny/}
}
