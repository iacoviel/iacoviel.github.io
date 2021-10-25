The directory contained in disaster_estimation.zip includes the files needed to create the disaster probabilites for countries used in section 5 of the paper. 

We use the code provided by Nakamura et al. (2013) to estimation of the disaster events through 2019. This code uses the Winbugs package which you will need to download and is run in R. It takes as input cdata20210312.txt to generate dis_probs_df.csv, the disaster probabilities used in Section 5 of the paper. Further description of the codes and packages are publicaly available here: https://www.openicpsr.org/openicpsr/project/114277/version/V1/view. 


In the zipped file you will find 

cdisastersDocumentation = documentation provided by Nakamura et al., for modeling the disaster episodes. 

sandbox = folder containing the codes and input data needed to produce the disaster estimates. 
	- cdata20210312.txt = input file with updated consumption data 
	
data = folder containing the output produced by Winbugs. 
	- bigDataSummaryDisasterEpisodes.txt contains the estimated disaster episodes used in the paper
	- dis_probs_df.csv contains the disaster episodes and thier estimated probabilities in convenient format for our codes





