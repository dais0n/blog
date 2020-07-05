BLOG = dais0n.hatenablog.com
DATE = $(shell date +%Y%m%d)

.PHONY: pull
pull:
	blogsync pull ${BLOG}

.PHONY: new
new:
	echo | blogsync post --draft ${BLOG} | tail -1 | awk '{ print $1 }' | pbcopy

.PHONY: post
post:
	blogsync push ${BLOG}/entry/${DATE}/*.md

