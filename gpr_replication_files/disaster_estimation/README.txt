
We use the code provided by Nakamura et al. (2013) to extend the estimation of the disaster events through 2019. The code are publicly available here https://www.openicpsr.org/openicpsr/project/114277/version/V1/view. 

As detailed in cdisasterDocumentation, run the files in the sandbox folder. This code uses as input cdata20210312.txt to generate dis_probs_df.csv the disaster- probabilities used in Section 5 of the paper. 

In the zipped file you will find 

cdisastersDocumentation = documentation provided by Nakamura et al., for modeling the disaster episodes. 
winbugs143_unrestricted = the winbugs package needed to run the codes
sandbox = folder containsing the codes and input data needed to produce the disaster estimates. 
	- cdata20210312.txt = input file with updated consumption data 
data = folder containing the output produced by Winbugs. 
	- bigDataSummaryDisasterEpisodes.txt contains the estimated disaster episodes used in the paper


