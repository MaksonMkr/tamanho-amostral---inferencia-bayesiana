library(bssbinom)
library(tidyverse)

# critério ACC
mss.bb(crit = "ACC", c = 2, d = 8, rho.min = 0.95, len = 0.2)

n <- 47
xn <- 9
c <- 2
d <- 8
len <- 0.200

hd.beta(c = c + xn, d = d + n - xn, len = len)

# critério ALC
set.seed(23)

abc <- mss.bb(crit = "ALC", c = 10, d = 2, rho = 0.95, len.max = 0.25)

mss.bb(crit = "ALC", c = 10, d = 2, rho = 0.9, len.max = 0.25)


n <- 346
xn <- 181
c <- d <- 10
rho <- 0.95

hd.beta(c = c + xn, d = d + n - xn, rho = rho)

mss.bb(crit = "ACC", c = 2, d = 10, rho.min = 0.95, len = 0.1)

hd.beta()



