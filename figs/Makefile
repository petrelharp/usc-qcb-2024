.PHONY : all sampling_sim_figs 

all : sampling_sim_figs sampling_sim+62400.png validation.png kreitman/kreitman-tsinfer.png kreitman/inference.png validation_sub.png
	$(MAKE) -C tree_sequence
	$(MAKE) -C dating_problem

sampling_sim_figs : sampling_sim_sub_l1.png sampling_sim_sub_l1_l2.png sampling_sim_sub_l1_l2_l3.png sampling_sim_ages_l1.png sampling_sim_ages_l1_l2.png

sampling_sim_ages_%.pdf : sampling_sim_ages.ink.svg
	./export-layers-svg.sh $< $@ data $(subst _, ,$*)

sampling_sim_sub_%.pdf : sampling_sim_sub.ink.svg
	./export-layers-svg.sh $< $@ data $(subst _, ,$*)

include ../rules.mk

