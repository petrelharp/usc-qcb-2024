SHELL := /bin/bash
# use bash for <( ) syntax

.PHONY : setup

TARGET := usc-qcb-2024.slides.html

$(TARGET) : setup

setup :
	$(MAKE) -C figs

publish : $(TARGET)
	# do this after giving the talk
	sed -i '/mathjax: .*MathJax.js/d' $<

include rules.mk
