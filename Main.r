setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Packages -------------------------------------------------------------
library(rstan)
library(xts)
source('Feature Extraction.R')

# Constantes ------------------------------------------------------------
direction.up =  1
direction.lt =  0
direction.dn = -1
extrema.min  = -1
extrema.max  =  1
trend.up =  1
trend.lt =  0
trend.dn = -1
volume.up =  1
volume.lt =  0
volume.dn = -1
state.bull  =  1
state.local =  0
state.bear  = -1
alpha <- 0.25

K <- 4 # K : nombre d'etats possibles {z21, z22, z23, z24}
L <- 9 # L : nombre d'outcome possibles {U1,...,U9} U {D1,...,D9}

n.iter <- 500
n.warmup <- 250
n.chaines <- 1
n.cores <- 1
n.thin <- 1
n.seed <- 9000

# Chargement des donnees -------------------------------------------------
for (day in c('01', '02', '03', '04', '07')){ # Utilisation de 5 jours ouvres de donnees pour entrainer le modele
    file.path <- paste(paste("Data/2007.05.", day, sep=''),'.G.TO.RData', sep='')
    load(file = file.path)
    data.name <- load(file = file.path)
    data.val <- get(data.name)
    data.val <- na.omit(data.val[,1:2])
    indexTZ(data.val) <- 'America/Toronto' # Time zone des donnees
    colnames(data.val) <- c('PRICE','SIZE')
    if (day=='01') {data <- data.val} else {data <- rbind(data, data.val)}
}

# Extraction des features ------------------------------------------------
zig <- extract_features(data, alpha)

# Estimation du modele et utilisation du package "stan" pour estimer les parametres du modele (35 parametres a estimer)
nb_period <- nrow(zig) # renvoie le nombre de periodes considere
legs <- as.vector(zig$feature) # renvoie un outcome possible pour chaque donnee {U1,...,U9}U{D1,...,D9} sous format d'un chiffre defini dans le script "Feature Extraction"

rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores()) # si l'on possede un processeur multi-coeur et de la memoire RAM, cette ligne permet de paralleliser le calcul

stan.model = 'config.stan'
stan.data = list(
    T = nb_period,
    K = K,
    L = L,
    sign = ifelse(legs < L + 1, 1, 2),
    x = ifelse(legs < L + 1, legs, legs - L))

stan.fit <- stan(file = stan.model,
            model_name = stan.model,
            data = stan.data, verbose = T,
            iter = n.iter, warmup = n.warmup,
            thin = n.thin, chains = n.chaines,
            cores = n.cores, seed = n.seed)

n.samples = (n.iter - n.warmup) * n.chaines

# Résumé des outputs
options(digits = 2)

print("Estimated initial state probabilities")
matrix(summary(stan.fit,
               pars = c('p_1k'),
               probs = c(0.10, 0.50, 0.90))$summary[, c(1, 3, 4, 5, 6)][, 4],
       1, K, TRUE)

print("Estimated probabilities in the transition matrix")
matrix(summary(stan.fit,
               pars = c('A_ij'),
               probs = c(0.10, 0.50, 0.90))$summary[, c(1, 3, 4, 5, 6)][, 4],
       K, K, TRUE)

print("Estimated event probabilities in each state")
matrix(summary(stan.fit,
               pars = c('phi_k'),
               probs = c(0.10, 0.50, 0.90))$summary[, c(1, 3, 4, 5, 6)][, 4],
       K, L, TRUE)

