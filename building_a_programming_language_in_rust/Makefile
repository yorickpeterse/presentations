INPUT := slides.typ
OUTPUT := build/slides.pdf

${OUTPUT}: ${INPUT}
	mkdir -p build
	typst compile --format pdf $< $@

watch:
	mkdir -p build
	typst watch --open --format=pdf ${INPUT} ${OUTPUT}

clean:
	rm -rf build/

.PHONY: watch clean
