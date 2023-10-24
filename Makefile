.DEFAULT_GOAL := all

# Define Targets
.PHONY: all clean rulebook scoresheets orga roadmap
rulebook: build/rulebook.pdf
scoresheets: build/score_sheets.pdf
orga: build/organization.pdf
roadmap: build/roadmap.pdf

clean:
	rm -rf build

build: 
	mkdir -p build	

# all .tex files in . (e.g. ./rulebook.tex -> build/rulebook.pdf)
SOURCES = $(shell find -maxdepth 1 -name "*.tex")
_S0 = $(subst ./,,$(SOURCES))
_S1 = $(subst .tex,.pdf,$(_S0))
OUTPUTS=$(addprefix build/,$(_S1))
all: $(OUTPUTS)

# Generate rule 'build/foo.pdf' from ./foo.tex
define latex_rules
## All tex files are dependencies SAD
DEPS := $$(shell find -name "*.tex")

## input.tex -> build/input.pdf
_SCRAP0 := $$(subst ./,,$(1))
_SCRAP1 := $$(addprefix build/,$$(_SCRAP0))
OUTPUT := $$(subst .tex,.pdf,$$(_SCRAP1))

## Generates rule for output (e.g. build/foo.pdf)
## openout_any=a for bug with makeindex (2020)
## https://github.com/James-Yu/LaTeX-Workshop/issues/1932#issuecomment-583258858
$$(OUTPUT): $(1) $$(DEPS) | build
	@echo "\033[1;33mBuilding $$@\033[0m"
	@openout_any=a latexmk -pdf -shell-escape -interaction=nonstopmode -quiet -rc-report- -outdir=build $(1)
endef

$(foreach source, $(_S0), $(eval $(call latex_rules, $(source))))

