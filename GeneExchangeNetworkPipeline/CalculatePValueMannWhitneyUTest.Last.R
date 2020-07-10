# TODO: Add comment
#
# Author: Mostafa Ellabaan
###############################################################################


## TODO improve the code performance and readability 
## 
args <- commandArgs(TRUE)
hkgfile = args[1] # species pairwise matrix
htgfile = args[2] # gene pairwise matrix
h = args[3] #index file
speciesCutOFF= as.numeric(args[4])
confidenceLevel= as.numeric(args[5])
clusteringfile = args[6] 



index = read.table(h, sep="\t", header=TRUE)

#print(index)

rRNA=index[,2]
gen=index[,3]


htgMatrix <- read.table(htgfile, sep="\t" )

hkgMatrix <- read.table(hkgfile, sep="\t" )
#print(htgMatrix )
#print(hkgMatrix )

n <- nrow(hkgMatrix)

#print (n)
ptm <- proc.time()
hkgdt=dist(hkgMatrix, method="maximum")
#print(hkgdt)
hkghc=hclust(hkgdt,method="average") 

clusters=cutree(hkghc, h=speciesCutOFF)




l=unique(index[,2])
l=cbind(l,clusters)

write.table(l,clusteringfile, quote=FALSE, sep="\t" )	



#cbind(index,clusters)
#print (index)
proc.time() - ptm

##options("scipen"=-100, "digits"=4)
ptm <- proc.time()

lappend <- function (lst, ...){
lst <- c(lst, list(...))
  return(lst)
}




fishersMethod = function(x) pchisq(-2 * sum(log(x)),df=2*length(x),lower=FALSE) 


cls=unique(clusters)


lst=which(clusters==1)

clstrs = list(lst)


for( i in 2: length(cls)  ) { 
	
	lst=which(clusters==i)
	clstrs=lappend(clstrs,lst)
	}



#print(clstrs)

#print(index)

max(cls)
print("cls")
cls
#clstrs
f=(max(cls)>1)
print (f)

mx=max(cls)
if(mx==1) {
print ("Only One Species")
stop("Only One Species")
}

c=vector()
hkgtst =vector()

htgtst =vector()
for( i in 1: (mx-1)) { 
	for( j in (i+1): mx ) {		
		withRestarts(
			tryCatch(
				{
					xrRRNA = vector()
					xgenees = vector()
					for (x in clstrs[[i]])
					{
                                            genesres=gen[which(rRNA==x)] 
                                            rrnxxa=rRNA[which(rRNA==x)]
                                            lnth1= length(genesres)
                                            lnth2= length(rrnxxa)
                                            xgenees=c(xgenees, genesres)
					     #print (xgenees)
                                            xrRRNA=c(xrRRNA, rrnxxa)
						}

					yrRRNA = vector()
					ygenees = vector()

					for (x in clstrs[[j]])
					{

                                                genesres=gen[which(rRNA==x)]
                                                #genesres
                                                rrnxxa=rRNA[which(rRNA==x)]
                                                lnth1= length(genesres)
                                                lnth2= length(rrnxxa)
                                                ygenees=c(ygenees, genesres)
					        #print (ygenees)
                                                yrRRNA=c(yrRRNA, rrnxxa) 

	                                  }
					#print (xgenees)
				        #print (ygenees)
                                        hkgtst=c(hkgtst, as.vector(t(hkgMatrix[xrRRNA, yrRRNA ] )))
					htgtst=c(htgtst, as.vector(t(htgMatrix[xgenees, ygenees ])) )
					#print (htgtst)
			
				}
			, finally = {},  error = function(e) { print(e)  }) # 
		, abort = function(){},  message = "" )
	}
}
print("Gene Identity test")
htgtst
print("16S rRNA")
hkgtst
tstresult=wilcox.test( htgtst, hkgtst, alternative = c( "less" ) , correct=FALSE, conf.int=TRUE, conf.level = confidenceLevel)
proc.time() - ptm
statisticalDetails = {}
statisticalDetails <- c(tstresult$p.value,   tstresult$estimate, tstresult$conf.int, tstresult$conf.in )
sprintf("Confidence level %.10f", confidenceLevel)
sprintf("P-value %.10e", tstresult$p.value)
sprintf("Estimate %.10e", tstresult$estimate)
sprintf("Confidence Interveal [%.10f,%.10f] ", tstresult$conf.in[1], tstresult$conf.in[2]) 

#else { print ("Only one class"); }

