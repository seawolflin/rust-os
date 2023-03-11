
OUT_DIR = target
TARGET = riscv64gc-unknown-none-elf
NAME = os
BIN_NAME = os.bin

build:
	cargo build

build-release:
	cargo build --release

strip-all: build-release
	rust-objcopy --strip-all ${OUT_DIR}/${TARGET}/release/${NAME} -O binary ${OUT_DIR}/${TARGET}/release/${BIN_NAME}

strip-all-debug: build
	rust-objcopy --strip-all ${OUT_DIR}/${TARGET}/debug/${NAME} -O binary ${OUT_DIR}/${TARGET}/debug/${BIN_NAME}

run-gdb: strip-all-debug
	qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios ./bootloader/rustsbi-qemu.bin \
    -device loader,file=${OUT_DIR}/${TARGET}/debug/${BIN_NAME},addr=0x80200000 \
    -s -S

run: strip-all
	qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios ./bootloader/rustsbi-qemu.bin \
    -device loader,file=${OUT_DIR}/${TARGET}/release/${BIN_NAME},addr=0x80200000

debug-gdb:
	riscv64-unknown-elf-gdb \
    -ex 'file target/riscv64gc-unknown-none-elf/debug/os' \
    -ex 'set arch riscv:rv64' \
    -ex 'target remote localhost:1234'
