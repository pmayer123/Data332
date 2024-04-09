#Chapter 6 Environments
deal(deck)

library(devtools)
library(pryr)
parenvs(all = TRUE) #parenvs got removed and added to pryr
as.environment("package:stats")

globalenv()
baseenv()
emptyenv()

parent.env(globalenv())
parent.env(emptyenv())
ls(emptyenv())
ls(globalenv())

head(globalenv()$deck, 3)
assign("new", "Hello Global", envir = globalenv())
globalenv()$new

#Active Environment
environment()

#Assignment
new
new <- "Hello Active"

#Evaluation

show_env <- function(){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()
environment(show_env)
environment(parenvs)

show_env <- function(){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env()

foo <- "take me to your runtime"
show_env <- function(x = foo){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}
show_env()

deal <- function(){
  deck[1, ]
}
environment(deal)
deal()

DECK <- deck

deck <- deck[-1, ]
head(deck, 3)

deal <- function(){
  card <- deck[1, ]
  assign("deck", deck[-1, ], envir = globalenv())
  card
}
deal()
deal()
deal()

shuffle <- function(cards){
  random <- sample(1:52, size = 52)
  assign("deck", DECK[random, ], envir = globalenv())
}

head(deck, 3)
a <- shuffle(deck)
head(deck, 3)
head(a, 3)

#Closure

shuffle()

deal()
deal()

setup <- function(deck) {
  DECK <- deck
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = globalenv())
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = globalenv())
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}


deal <- card$deal
shuffle <- card$shuffle
environment(deal)
environment(shuffle)

setup <- function(deck) {
  DECK <- deck
  
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  SHUFFLE <- function(){
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  list(deal = DEAL, shuffle = SHUFFLE)
}
cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle

rm(deck)

shuffle()
deal()
