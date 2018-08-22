PYTHONPATH=.:stubs

.PHONY: env.brython
env.brython:
	mkdir -p js
	rm -Rf js/brython
	cd js; git clone https://github.com/brython-dev/brython.git
	cd js/brython; git checkout 7e9a7d901acc6f2112ab8e570a0d560aafb616d2
	cp js/brython/www/src/brython_dist.js js

.PHONY: env.vuejs
env.vuejs:
	mkdir -p js
	rm -Rf js/vuejs
	cd js; git clone https://github.com/vuejs/vue.git vuejs
	cd js/vuejs; git checkout v2.5.16
	cp js/vuejs/dist/vue.js js

.PHONY: env.vuex
env.vuex:
	mkdir -p js
	rm -Rf js/vuex
	cd js; git clone https://github.com/vuejs/vuex.git vuex
	cd js/vuex; git checkout v3.0.1
	cp js/vuex/dist/vuex.js js

.PHONY: env.pip
env.pip:
	pip install -r requirements.txt

.PHONY: env.chrome
env.chrome:
	python -c "import chromedriver_install as cdi;cdi.install(file_directory='tests/selenium', overwrite=True)"

.PHONY: env.up
env.up: env.pip env.brython env.vuejs env.vuex env.chrome

.PHONY: env.clean
env.clean:
	git clean -xdf --exclude .idea --exclude venv --exclude js

.PHONY: env.down
env.down:
	git clean -xdf --exclude .idea --exclude venv --exclude debug
	pip freeze | xargs pip uninstall -y

.PHONY: serve
serve:
	python -m http.server 8000

.PHONY: tests.selenium
tests.selenium:
	PYTHONPATH=$(PYTHONPATH) pytest tests/selenium

.PHONY: tests.unit
tests.unit:
	PYTHONPATH=$(PYTHONPATH) pytest tests/unit

.PHONY: tests
tests:
	PYTHONPATH=$(PYTHONPATH) pytest tests

.PHONY: ci.docs
ci.docs:
	rm -Rf gh-pages-build
	mkdir gh-pages-build

	cp -Rf docs/* README.md examples vue gh-pages-build

	mkdir gh-pages-build/js
	cp js/vue.js gh-pages-build/js
	cp js/brython_dist.js gh-pages-build/js

	mkdir gh-pages-build/tests
	cp -R tests/selenium/_html/* gh-pages-build/tests

.PHONY: ci
ci: tests ci.docs
