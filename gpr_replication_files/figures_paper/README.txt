STAGE 1
-------

FILES TO RUN

1. run_process_data_all.do 

INPUT FILES
1. GPRNEW_20210615.xlsx
Contains relevant series tabulated from Python searches and various other sources

2. NYT_count_daily_all.xlsx
Contains hand tabulations of NYT articles


OUTPUT
1. data_for_charts_in_paper.dta (gpr data at monthly frequency)
2. data_gpr_quarterly.dta (gpr data at quarterly frequency)


-----------------------
2. run_charts_for_paper.do

INPUT FILES
1. data_for_charts_in_paper.dta
2. data_gpr_quarterly.dta
3. data_vardatagpr_q.csv (quarterly data from various sources)

OUTPUT
Charts contained in the paper