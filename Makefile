BLOG = dais0n.hatenablog.com
DATE_Y = $(shell date +%Y)
DATE_M = $(shell date +%m)
DATE_D = $(shell date +%d)

.PHONY: pull
pull:
	blogsync pull ${BLOG}

.PHONY: new
new:
	echo | blogsync post --draft ${BLOG} | tail -1 | awk '{ print $1 }' | pbcopy

.PHONY: post
post:
	blogsync push ${BLOG}/entry/${DATE_Y}/${DATE_M}/${DATE_D}/*.md

