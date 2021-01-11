
robin = function(){
  score = 1
  r1 = runif(1)
  done = FALSE
  while (!done){
    r0 = r1
    r1 = runif(1)
    if (r1 < r0) score = score + 1 
    else done = TRUE
  #    x1 = y1
}
  score = score + 1 
}

s = sapply(c(1:1e8), function(x) robin())

mean(s)
#[1] 2.718269           
