.PHONY : all sampling_sim_figs 

all : sampling_sim_figs sampling_sim+62400.png validation.png kreitman/kreitman-tsinfer.png kreitman/inference.png
	$(MAKE) -C tree_sequence

sampling_sim_figs : sampling_sim_sub_l1.png sampling_sim_sub_l1_l2.png sampling_sim_sub_l1_l2_l3.png 

sampling_sim_sub_%.pdf : sampling_sim_sub.ink.svg
	./export-layers-svg.sh $< $@ data $(subst _, ,$*)

include ../rules.mk

