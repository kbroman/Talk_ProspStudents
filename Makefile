TALK = introQTL

all: $(TALK).pdf notes

$(TALK).pdf: DerivedFiles/$(TALK).tex Stuff/header.tex Figs/data_fig.png Figs/ail.pdf Figs/hs.pdf Figs/lodcurve_insulin.pdf
	cd DerivedFiles;xelatex $(TALK)
	mv DerivedFiles/$(TALK).pdf $(TALK).pdf

notes: $(TALK)_withnotes.pdf
pdf: $(TALK).pdf notes

DerivedFiles/$(TALK).tex: $(TALK).tex
	cp $< $@

$(TALK)_withnotes.pdf: DerivedFiles/$(TALK)_withnotes.tex Stuff/header.tex Figs/data_fig.png Figs/ail.pdf Figs/hs.pdf Figs/lodcurve_insulin.pdf
	cd DerivedFiles;xelatex $(TALK)_withnotes
	cd DerivedFiles;pdfnup $(TALK)_withnotes.pdf --nup 1x2 --no-landscape --paper letterpaper --frame true --scale 0.9
	mv DerivedFiles/$(TALK)_withnotes-nup.pdf $(TALK)_withnotes.pdf
	rm DerivedFiles/$(TALK)_withnotes.pdf

DerivedFiles/$(TALK)_withnotes.tex: DerivedFiles/$(TALK).tex Stuff/Ruby/createVersionWithNotes.rb
	Stuff/Ruby/createVersionWithNotes.rb DerivedFiles/$(TALK).tex DerivedFiles/$(TALK)_withnotes.tex

Figs/data_fig.png: R/data_fig.R
	cd R;R CMD BATCH $(<F)

Figs/ail.pdf: R/ail_fig.R
	cd R;R CMD BATCH $(<F)

Figs/hs.pdf: R/hs_fig.R
	cd R;R CMD BATCH $(<F)

Figs/lodcurve_insulin.pdf: R/lodcurve_insulin.R
	cd R;R CMD BATCH $(<F)

web: $(TALK).pdf $(TALK)_withnotes.pdf
	scp $(TALK).pdf $(TALK)_withnotes.pdf broman-10.biostat.wisc.edu:Website/presentations/ProspStudents2017-03/

clean:
	rm DerivedFiles/*.*
