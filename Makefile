TALK = introQTL

all: $(TALK).pdf notes

$(TALK).pdf: DerivedFiles/$(TALK).tex Stuff/header.tex
	cd DerivedFiles;xelatex $(TALK)
	mv DerivedFiles/$(TALK).pdf $(TALK).pdf

notes: $(TALK)_withnotes.pdf
pdf: $(TALK).pdf notes

DerivedFiles/$(TALK).tex: $(TALK).tex
	cp $< $@

DerivedFiles/$(TALK)_withnotes.tex: DerivedFiles/$(TALK).tex
	Ruby/createVersionWithNotes.rb $<

$(TALK)_withnotes.pdf: DerivedFiles/$(TALK)_withnotes.tex Stuff/header.tex
	cd DerivedFiles;xelatex $(TALK)_withnotes
	cd DerivedFiles;pdfnup $(TALK)_withnotes.pdf --nup 1x2 --no-landscape --paper letterpaper --frame true --scale 0.9
	mv DerivedFiles/$(TALK)_withnotes-nup.pdf $(TALK)_withnotes.pdf
	rm DerivedFiles/$(TALK)_withnotes.pdf

DerivedFiles/$(TALK)_withnotes.tex: $(TALK).tex Stuff/Ruby/createVersionWithNotes.rb
	Stuff/Ruby/createVersionWithNotes.rb DerivedFiles/$(TALK).tex DerivedFiles/$(TALK)_withnotes.tex

web: $(TALK).pdf $(TALK)_withnotes.pdf
	scp $(TALK).pdf $(TALK)_withnotes.pdf broman-10.biostat.wisc.edu:Website/presentations/ProspStudents2017/
