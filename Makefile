MOCHA_OPTS= -r ts-node/register tests/index.ts
REPORTER = dot

test: test-unit

build: clean build-ts docs cleanjs

test-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		$(MOCHA_OPTS)
	echo "\033[31mTest-unit Completed...\033[0m"

clean:
	rm -rf docs
	rm -rf lib
	mkdir docs
	echo "\033[31m(1/4) Clean Completed...\033[0m"

build-ts:
	./node_modules/.bin/tsc --stripInternal -d --moduleResolution "node" \
		-t "es5" --rootDir "./src" --module "commonjs" --outDir "./lib"
	echo "\033[31m(2/4) Node Build & Type Declarations Completed...\033[0m"

docs:
	./node_modules/.bin/typedoc --out docs --includes src --target ES6 \
		--exclude node_modules --excludeExternals --excludePrivate
	touch docs/.nojekyll
	echo "\033[31m(3/4) Docs Completed...\033[0m"

cleanjs:
	rm -rf src/*.js*
	echo "\033[31m(4/4) Cleaning up all js files...\033[0m"

http-server:
	./node_modules/.bin/http-server ./docs/ -p 9000 -a 127.0.0.1 -i -o --cors
	echo "\033[31mHttp-server Started...\033[0m"

.PHONY: test-unit clean build-ts docs cleanjs lint http-server