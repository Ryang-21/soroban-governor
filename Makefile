default: build

test: build
	cargo test --all --tests

build:
	cargo rustc --manifest-path=contracts/votes/Cargo.toml --crate-type=cdylib --target=wasm32-unknown-unknown --release
	cargo rustc --manifest-path=contracts/governor/Cargo.toml --crate-type=cdylib --target=wasm32-unknown-unknown --release
	mkdir -p target/wasm32-unknown-unknown/optimized
	soroban contract optimize \
		--wasm target/wasm32-unknown-unknown/release/votes.wasm \
		--wasm-out target/wasm32-unknown-unknown/optimized/votes.wasm
	soroban contract optimize \
		--wasm target/wasm32-unknown-unknown/release/governor.wasm \
		--wasm-out target/wasm32-unknown-unknown/optimized/governor.wasm
	cd target/wasm32-unknown-unknown/optimized/ && \
		for i in *.wasm ; do \
			ls -l "$$i"; \
		done

fmt:
	cargo fmt --all

clean:
	cargo clean

generate-js:
	soroban contract bindings typescript --overwrite \
		--contract-id CBWH54OKUK6U2J2A4J2REJEYB625NEFCHISWXLOPR2D2D6FTN63TJTWN \
		--wasm ./target/wasm32-unknown-unknown/optimized/backstop.wasm --output-dir ./js/js-votes/
	soroban contract bindings typescript --overwrite \
		--contract-id CBWH54OKUK6U2J2A4J2REJEYB625NEFCHISWXLOPR2D2D6FTN63TJTWN \
		--wasm ./target/wasm32-unknown-unknown/optimized/emitter.wasm --output-dir ./js/js-governor/
