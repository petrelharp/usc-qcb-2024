.PHONY : all

dating_problem_pdfs = dating_problem_00.pdf dating_problem_01.pdf dating_problem_02.pdf dating_problem_03.pdf dating_problem_04.pdf dating_problem_05.pdf

dating_problem_figs = $(dating_problem_pdfs:pdf=png)

.SECONDARY : $(dating_problem_pdfs)

all : $(dating_problem_figs)

$(dating_problem_figs) :

$(dating_problem_pdfs) : dating_problem.ink.svg
	../export-layers-svg.sh $< dating_problem_00.pdf transit base nodes
	../export-layers-svg.sh $< dating_problem_01.pdf transit base nodes muts
	../export-layers-svg.sh $< dating_problem_02.pdf transit base nodes muts samples
	../export-layers-svg.sh $< dating_problem_03.pdf transit times samples base nodes muts 
	../export-layers-svg.sh $< dating_problem_04.pdf transit times samples base nodes edges muts
	../export-layers-svg.sh $< dating_problem_05.pdf transit times samples base nodes edges muts curves

include ../../rules.mk
