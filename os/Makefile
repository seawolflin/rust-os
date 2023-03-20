OUT_DIR = ../target
TARGET = riscv64gc-unknown-none-elf
NAME = os
BIN_NAME = os.bin

elf:
	cargo build

elf-release:
	cargo build --release

bin: elf
	rust-objcopy --strip-all ${OUT_DIR}/${TARGET}/debug/${NAME} -O binary ${OUT_DIR}/${TARGET}/debug/${BIN_NAME}

bin-release: elf-release
	rust-objcopy --strip-all ${OUT_DIR}/${TARGET}/release/${NAME} -O binary ${OUT_DIR}/${TARGET}/release/${BIN_NAME}

build: bin-release
