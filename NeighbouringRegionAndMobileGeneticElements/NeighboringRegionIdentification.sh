


region=$1;
fileName=$2 

awk -F"\t" -v region=$region '{
if(FNR==1) 
        {
                gid=$1
                regionStart=$2-region
                regionEnd=$3+region
                regionID=1                  
        }
else 
        {
                if(gid==$1) 
                        {
                                if(($2-region) < regionEnd)
                                {
                                         regionEnd=$3+region
                                                                
                                }
                                else
                                        {
                                                if(regionStart<0) regionStart=0;
                                                print gid"__"regionID"__"regionStart"__"regionEnd"\t"gid"\t"regionID"\t"regionStart"\t"regionEnd
                                                regionStart=$2-region
                                                regionEnd=$3+region
                                                regionID=regionID+1                  

                                        }
                        }
                else
                        {
                                if(regionStart<0) regionStart=0;
                                print gid"__"regionID"__"regionStart"__"regionEnd"\t"gid"\t"regionID"\t"regionStart"\t"regionEnd
                                gid=$1
                                regionStart=$2-region
                                regionEnd=$3+region
                                regionID=1                  
                      
                        }
                            
        }
} END {   
if(regionStart<0) regionStart=0;  
print gid"__"regionID"__"regionStart"__"regionEnd"\t"gid"\t"regionID"\t"regionStart"\t"regionEnd; 
}' $fileName    > $fileName.NeighboringRegions

