
R version 4.3.2 (2023-10-31) -- "Eye Holes"
Copyright (C) 2023 The R Foundation for Statistical Computing
Platform: aarch64-apple-darwin20 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

Natural language support but running in an English locale

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

1+1
[1] 2
 100:130
[1] 100 101 102 103 104 105 106 107 108 109 110
[12] 111 112 113 114 115 116 117 118 119 120 121
[23] 122 123 124 125 126 127 128 129 130
> 5-
  + 
  + 1
[1] 4
> 3%5
Error: unexpected input in "3%5"
> 2*3
[1] 6
> 4-1
[1] 3
> 6/(4-1)
[1] 2
> #Commenting Symbol
  > 10+2
[1] 12
> 12*3
[1] 36
> 36-6
[1] 30
> 30/3
[1] 10
> 1:6
[1] 1 2 3 4 5 6
> #Objects
  > a <- 1
> a
[1] 1
> a+2
[1] 3
> die <- 1:6
> die
[1] 1 2 3 4 5 6
> Name <- 1
> name <- 0
> Name+1
[1] 2
> #Case-sensitive
  > my_number <- 1
> my_number
[1] 1
> my_number <- 999
> my_number
[1] 999
> #Will overwrite
  > ls()
[1] "a"         "die"       "my_number"
[4] "name"      "Name"     
> die -1
[1] 0 1 2 3 4 5
> die /2
[1] 0.5 1.0 1.5 2.0 2.5 3.0
> die * die
[1]  1  4  9 16 25 36
> #Element-wise execution
  > 1:2
[1] 1 2
> 1:4
[1] 1 2 3 4
> die
[1] 1 2 3 4 5 6
> die+1:2
[1] 2 4 4 6 6 8
> die+1:4
[1] 2 4 6 8 6 8
Warning message:
  In die + 1:4 :
  longer object length is not a multiple of shorter object length
> die %*% die
[,1]
[1,]   91
> die %o% die
[,1] [,2] [,3] [,4] [,5] [,6]
[1,]    1    2    3    4    5    6
[2,]    2    4    6    8   10   12
[3,]    3    6    9   12   15   18
[4,]    4    8   12   16   20   24
[5,]    5   10   15   20   25   30
[6,]    6   12   18   24   30   36
> #Functions
  > round(3.1415)
[1] 3
> factorial(3)
[1] 6
> mean(1:6)
[1] 3.5
> mean(die)
[1] 3.5
> round(mean(die))
[1] 4
> #Simulate a roll with sample
  > sample(x = 1:4, size=2)
[1] 4 2
> sample(x = die, size = 1)
[1] 1
> sample(x = die, size = 1)
[1] 3
> sample(x = die, size = 1)
[1] 3
> sample(die, size = 1)
[1] 6
> round(3.1415, corners = 2)
Error in round(3.1415, corners = 2) : unused argument (corners = 2)
> #Check arguments of function with args()
  > args(round)
function (x, digits = 0) 
  NULL
> round(3.1415, digits = 2)
[1] 3.14
> sample(die,1)
[1] 5
> sample(size=1, x= die)
[1] 3
> #Sample with replacement
  > sample(die,size = 2)
[1] 4 2
> sample(die, size = 2, replace = TRUE)
[1] 3 1
> sample(die, size = 2, replace = TRUE)
[1] 4 5
> dice <- sample(die, size = 2, replace = TRUE)
> dice
[1] 4 1
> sum(dice)
[1] 5
> dice
[1] 4 1
> dice
[1] 4 1
> dice
[1] 4 1
> roll <- function(){die <- 1:6}
> View(roll)
> roll <- function()
  + View(roll)
> roll <- function(){}
> View(roll)
> roll <- function(){die <- 1:6
+ dice <- sample(die, size = 2, replace = TRUE)
+ sum(dice)
+ }
> View(roll)
> roll()
[1] 4
> roll()
[1] 11
> roll()
[1] 3
> roll
function(){die <- 1:6
dice <- sample(die, size = 2, replace = TRUE)
sum(dice)
}
<bytecode: 0x1099f08f0>
  > dice
[1] 4 1
> 1+1
[1] 2
> sqrt
function (x)  .Primitive("sqrt")
> sqrt(2)
[1] 1.414214
> dice <- sample(die, size = 2, replace = TRUE)
> a <- sqrt(2)
> #Does not return a value if saving value to object
  > #Arguments
  > roll2 <- function(){
    +   dice <- sample(bones, size = 2, replace = TRUE)
    +   sum(dice)
    + }
> roll2()
Error in roll2() : object 'bones' not found
> roll2 <- function(bones){
  +   dice <- sample(bones, size = 2, replace = TRUE)
  +   sum(dice)
  + }
> roll2(bones = 1:4)
[1] 7
> roll2(bones = 1:6)
[1] 2
> roll2(bones = 1:20)
[1] 32
> roll2()
Error in roll2() : argument "bones" is missing, with no default
> roll2 <- function(bones = 1:6){
  +   dice <- sample(bones, size = 2, replace = TRUE)
  +   sum(dice)
  + }
> roll2()
[1] 10