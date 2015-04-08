IN = input
OUT = output
TRANS = transforms
APP_XML=$(IN)/mdm.xml
TABLE=$(OUT)/mdm-table.html
SIMPLIFIED=$(OUT)/mdm-table-reqs.html
APP_HTML=$(OUT)/mdm.html
APP_OP_HTML=$(OUT)/mdm-optionsappendix.html
APP_RELEASE_HTML=$(OUT)/mdm-release.html
all: $(TABLE) $(SIMPLIFIED) $(APP_HTML)

pp:$(APP_HTML)
$(APP_HTML):  $(TRANS)/pp2html.xsl $(APP_XML)
	xsltproc -o $(APP_HTML) $(TRANS)/pp2html.xsl $(APP_XML)
	xsltproc --stringparam appendicize on -o $(APP_OP_HTML) $(TRANS)/pp2html.xsl $(APP_XML)
	xsltproc --stringparam appendicize on --stringparam release final -o $(APP_RELEASE_HTML) $(TRANS)/pp2html.xsl $(APP_XML)

table: $(TABLE)
$(TABLE): $(TRANS)/pp2table.xsl $(APP_XML)
	xsltproc  --stringparam release final -o $(TABLE) $(TRANS)/pp2table.xsl $(APP_XML)

simplified: $(SIMPLIFIED)
$(SIMPLIFIED): $(TRANS)/pp2simplified.xsl $(APP_XML)
	xsltproc --stringparam release final -o $(SIMPLIFIED) $(TRANS)/pp2simplified.xsl $(APP_XML)

schema/application.rnc: schema/application.rng
	trang -I rng -O rnc  schema/application.rng schema/application.rnc

clean:
	@for f in a $(TABLE) $(SIMPLIFIED) $(APP_HTML) $(APP_RELEASE_HTML) $(APP_OP_HTML); do \
		if [ -f $$f ]; then \
			rm "$$f"; \
		fi; \
	done
