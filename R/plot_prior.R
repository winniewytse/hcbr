#' Prior Distributions of Parameters
#'
#' \code{plot_prior()} generate plots of the prior distributions of effect size
#' and/or intraclass correlation.
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
#' @export

plot_prior <- function(d_est, d_sd, rho_est, rho_sd, omega_est = NULL, omega_sd = NULL) {
  if (is.null(omega_sd)) omega_sd <- 0
  if (is.null(rho_sd)) rho_sd <- 0
  if (sum(c(d_sd, rho_sd, omega_sd) != 0) == 0) {
    stop("No prior distributions specified. ")
  }
  plots <- NULL
  if (d_sd != 0) {
    pd <- ggplot2::ggplot(data.frame(d = c(d_est + 3 * d_sd, d_est - 3 * d_sd)),
                          ggplot2::aes(x = d)) +
      ggplot2::stat_function(fun = stats::dnorm, n = 101,
                             args = list(mean = d_est, sd = d_sd)) +
      ggplot2::labs(x = expression(delta), y = "Density")
    plots <- append(plots, list(delta = pd))
  }
  if (rho_sd != 0) {
    rho_ab <- get_ab(rho_est, rho_sd)
    prho <- ggplot2::ggplot(data.frame(rho = c(rho_est + 4 * rho_sd, 0)),
                            ggplot2::aes(x = rho)) +
      ggplot2::stat_function(fun = stats::dbeta, n = 101,
                             args = list(shape1 = rho_ab[1], shape2 = rho_ab[2])) +
      ggplot2::labs(x = expression(rho), y = "Density")
    plots <- append(plots, list(rho = prho))
  }
  if (omega_sd != 0) {
    omega_ab <- gamma_ab(omega_est, omega_sd)
    pomega <- ggplot2::ggplot(data.frame(omega = c(omega_est + 4 * omega_sd, 0)),
                              ggplot2::aes(x = omega)) +
      ggplot2::stat_function(fun = stats::dgamma, n = 101,
                             args = list(shape = omega_ab[1], rate = omega_ab[2])) +
      ggplot2::labs(x = expression(omega), y = "Density")
    plots <- append(plots, list(omega = pomega))
  }
  return(plots)
}
