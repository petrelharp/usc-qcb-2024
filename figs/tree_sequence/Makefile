.PHONY : all

summing_down_pdfs = summing_down_00.pdf summing_down_01.pdf summing_down_02.pdf summing_down_03.pdf summing_down_04.pdf summing_down_05.pdf summing_down_06.pdf summing_down_07.pdf summing_down_08.pdf summing_down_09.pdf summing_down_10.pdf summing_down_11.pdf

summing_down_figs = $(summing_down_pdfs:pdf=png)

.SECONDARY : $(summing_down_pdfs)

all : $(summing_down_figs)

$(summing_down_figs) : summing_down.ink.svg

$(summing_down_pdfs) :
	../export-layers-svg.sh $< summing_down_00.pdf base tree1 mut1
	../export-layers-svg.sh $< summing_down_01.pdf base tree1 mut1 num1
	../export-layers-svg.sh $< summing_down_02.pdf base tree1 num1 edge1
	../export-layers-svg.sh $< summing_down_03.pdf base tree1 num1 edge1 path1
	../export-layers-svg.sh $< summing_down_04.pdf base tree1 num1 edge1 path1 arrows1
	../export-layers-svg.sh $< summing_down_05.pdf base tree1 sum1 edge1 path1 arrows1
	../export-layers-svg.sh $< summing_down_06.pdf base tree2 start2
	../export-layers-svg.sh $< summing_down_07.pdf base tree2 start2 mut2
	../export-layers-svg.sh $< summing_down_08.pdf base tree2 num2 mut2
	../export-layers-svg.sh $< summing_down_09.pdf base tree2 num2 edge2 path2
	../export-layers-svg.sh $< summing_down_10.pdf base tree2 num2 edge2 path2 arrows2
	../export-layers-svg.sh $< summing_down_11.pdf base tree3

include ../../rules.mk
