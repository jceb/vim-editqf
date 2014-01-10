PLUGIN = editqf

VIMPLUGINDIR = $(HOME)/.vim/bundle/editqf

all: clean vba

${PLUGIN}.vba: README plugin/${PLUGIN}.vim autoload/${PLUGIN}.vim
	mkdir -p doc
	cp README doc/${PLUGIN}.txt
	find doc plugin autoload -type f | sed -e 's/^\.\/// '> files
	vim --cmd 'let g:plugin_name="${PLUGIN}"' -s build_vba.vim
	[ -e ${PLUGIN}.vmb ] && mv ${PLUGIN}.vmb $@

vba: ${PLUGIN}.vba

${PLUGIN}.vba.gz: ${PLUGIN}.vba
	gzip $<

vba.gz: ${PLUGIN}.vba.gz

clean:
	@rm -rf ${PLUGIN}.vba.gz ${PLUGIN}.vba doc files

installvba: ${PLUGIN}.vba install_vba.vim
	rm -rvf ${VIMPLUGINDIR}
	mkdir -p "${VIMPLUGINDIR}"
	vim --cmd "let g:installdir='${VIMPLUGINDIR}'" -s install_vba.vim $^
	@echo "Plugin was installed in ${VIMPLUGINDIR}. Make sure you are using a plugin loader like pathegon, otherwise the ${PLUGIN} might not work properly."

.PHONY: all clean vba vba.gz installvba
