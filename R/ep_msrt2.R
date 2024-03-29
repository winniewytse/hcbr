#' Expected Power for Two-Level Multisite Randomized Trials
#'
#' \code{ep_msrt2()} computes the expected power over the specified uncertainty
#' about the parameters for a two-level MSRT design.
#'
#' @param d_est Effect size estimate, defined as
#'   \eqn{\delta = \frac{\gamma_{01}}{\tau^2 + \sigma^2}},
#'   where \eqn{\gamma_{01}} is the main effect of the treatment on the outcome,
#'   \eqn{\tau^2} is the variance of the cluster-specific random effect
#'   in the unconditional model (without covariates), and
#'   \eqn{\sigma^2} is the variance of the random error in the unconditional model.
#' @param d_sd Uncertainty level of the effect size estimate.
#' @param rho_est Intraclass correlation estimate, defined as
#'   \eqn{\rho = \frac{\tau^2}{\tau^2 + \sigma^2}}, where \eqn{\tau^2} and \eqn{\sigma^2}
#'   are the variance components in the unconditional model.
#' @param rho_sd Uncertainty level of the intraclass correlation estimate.
#' @param omega_est Estimate of the treatment effect hetereogeneity, defined as
#'   \eqn{\omega = \frac{\tau_1^2}{\tau_0^2}} where \eqn{\tau_0^2} is the variance of the
#'   intercept random component and \eqn{\tau_1^2} is the variance of the treatment
#'   random effect.
#' @param omega_sd Uncertainty level of the treatment effect hetereogeneity estimate.
#' @param rsq1 Estimate of variance explained by the level-1 (e.g., individual-level) covariates.
#' @param rsq2 Estimate of variance explained by the cluster-level covariates.
#' @param J Number of clusters. Determine \code{n} if \code{J} is specified.
#' @param n Cluster size. Determine \code{J} if \code{n} is specified.
#' @param K Number of cluster-level covariates.
#' @param P Proportion of the clusters that is treatment group.
#' @param power Desired statistical power to achieve. Default to be \code{.8}.
#' @param alpha Type I error rate. Default to be \code{.05}.
#' @param test One-sided or two-sided test. Options are either "one.sided" or "two.sided".
#' @param ... Additional arguments passed to \code{cubuture::hcubature()} to evaluate
#'   the integral.
#'
#' @return The expected power given a two-level CRT design with J clusters each
#'   with n observations.
#' @export
#' @examples
#' ep_msrt2(J = 30, n = 20, d_est = .3, d_sd = .1, rho_est = .2, rho_sd = .05,
#'          omega_est = .3, omega_sd = .05)

ep_msrt2 <- function(J, n, d_est, d_sd, rho_est, rho_sd, omega_est, omega_sd,
                     rsq1 = 0, rsq2 = 0, K = 0, P = .5, power = .8, alpha = .05,
                     test = "two.sided", ...) {

  # round extremely small d_sd to 0 for computational stability
  if (d_sd < .005) {d_sd = 0} else {d_sd = d_sd}

  if (d_sd == 0) {
    if (rho_sd == 0) {
      if (omega_sd == 0) { # (1) d_sd = rho_sd = omega_sd = 0
        pow_msrt2(J = J, n = n, d_est = d_est, rho_est = rho_est,
                  omega_est = omega_est, rsq1 = rsq1, rsq2 = rsq2,
                  K = K, P = P, alpha = alpha, test = test)
      } else { # (2) d_sd = rho_sd = 0
        omega_ab <- gamma_ab(omega_est, omega_sd)
        cubature::hcubature(
          function(omega) {
            pow_msrt2(J = J, n = n, d_est = d_est, rho_est = rho_est,
                      omega_est = omega, rsq1 = rsq1, rsq2 = rsq2,
                      K = K, P = P, alpha = alpha, test = test) *
              stats::dgamma(omega, omega_ab[1], omega_ab[2])
          },
          lowerLimit = 0, upperLimit = 1,
          vectorInterface = TRUE, ...
        )$integral
      }
    } else {
      if (omega_sd == 0) { # (3) d_sd = omega_sd = 0
        rho_ab <- get_ab(rho_est, rho_sd)
        cubature::hcubature(
          function(rho) {
            pow_msrt2(J = J, n = n, d_est = d_est, rho_est = rho,
                      omega_est = omega_est, rsq1 = rsq1, rsq2 = rsq2,
                      K = K, P = P, alpha = alpha, test = test) *
              stats::dbeta(rho, rho_ab[1], rho_ab[2])
          },
          lowerLimit = 0, upperLimit = 1,
          vectorInterface = TRUE, ...
        )$integral
      } else { # (4) d_sd = 0
        rho_ab <- get_ab(rho_est, rho_sd)
        omega_ab <- gamma_ab(omega_est, omega_sd)
        cubature::hcubature(
          function(x) {
            matrix(apply(x, 2, function(arg) {
              rho <- arg[1]
              omega <- arg[2]
              pow_msrt2(J = J, n = n, d_est = d_est, rho_est = rho,
                        omega_est = omega, rsq1 = rsq1, rsq2 = rsq2,
                        K = K, P = P, alpha = alpha, test = test) *
                stats::dbeta(rho, rho_ab[1], rho_ab[2]) *
                stats::dgamma(omega, omega_ab[1], omega_ab[2])
            }), ncol = ncol(x))
          },
          lowerLimit = c(0, 0), upperLimit = c(1, 1),
          vectorInterface = TRUE, ...
        )$integral
      }
    }
  } else {
    if (rho_sd == 0) {
      if (omega_sd == 0) { # (5) rho_sd = omega_sd = 0
        cubature::hcubature(
          function(delta) {
            pow_msrt2(J = J, n = n, d_est = delta, rho_est = rho_est,
                      omega_est = omega_est, rsq1 = rsq1, rsq2 = rsq2,
                      K = K, P = P, alpha = alpha, test = test) *
              stats::dnorm(delta, d_est, d_sd)
          },
          lowerLimit = -Inf, upperLimit = Inf,
          vectorInterface = TRUE, ...
        )$integral
      } else { # (6) rho_sd = 0
        omega_ab <- gamma_ab(omega_est, omega_sd)
        cubature::hcubature(
          function(x) {
            matrix(apply(x, 2, function(arg) {
              delta <- arg[1]
              omega <- arg[2]
              pow_msrt2(J = J, n = n, d_est = delta, rho_est = rho_est,
                        omega_est = omega, rsq1 = rsq1, rsq2 = rsq2,
                        K = K, P = P, alpha = alpha, test = test) *
                stats::dnorm(delta, d_est, d_sd) *
                stats::dgamma(omega, omega_ab[1], omega_ab[2])
            }), ncol = ncol(x))
          },
          lowerLimit = c(-Inf, 0), upperLimit = c(Inf, 1),
          vectorInterface = TRUE, ...
        )$integral
      }
    } else {
      if (omega_sd == 0) { # (7) omega_sd = 0
        rho_ab <- get_ab(rho_est, rho_sd)
        cubature::hcubature(
          function(x) {
            matrix(apply(x, 2, function(arg) {
              delta <- arg[1]
              rho <- arg[2]
              pow_msrt2(J = J, n = n, d_est = delta, rho_est = rho,
                        omega_est = omega_est, rsq1 = rsq1, rsq2 = rsq2,
                        K = K, P = P, alpha = alpha, test = test) *
                stats::dnorm(delta, d_est, d_sd) *
                stats::dbeta(rho, rho_ab[1], rho_ab[2])
            }), ncol = ncol(x))
          },
          lowerLimit = c(-Inf, 0), upperLimit = c(Inf, 1),
          vectorInterface = TRUE, ...
        )$integral
      } else { # (8)
        rho_ab <- get_ab(rho_est, rho_sd)
        omega_ab <- gamma_ab(omega_est, omega_sd)
        cubature::hcubature(
          function(x) {
            matrix(apply(x, 2, function(arg) {
              delta <- arg[1]
              rho <- arg[2]
              omega <- arg[3]
              pow_msrt2(J = J, n = n, d_est = delta, rho_est = rho,
                        omega_est = omega, rsq1 = rsq1, rsq2 = rsq2,
                        K = K, P = P, alpha = alpha, test = test) *
                stats::dnorm(delta, d_est, d_sd) *
                stats::dbeta(rho, rho_ab[1], rho_ab[2]) *
                stats::dgamma(omega, omega_ab[1], omega_ab[2])
            }), ncol = ncol(x))
          },
          lowerLimit = c(-Inf, 0, 0), upperLimit = c(Inf, 1, 1),
          vectorInterface = TRUE, ...
        )$integral
      }
    }
  }
}
