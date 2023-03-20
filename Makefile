OUT_DIR = target
TARGET = riscv64gc-unknown-none-elf
BIN_NAME = os.bin

all: build

clean:
	cargo clean

build-user:
	@echo "Build user bin"
	@cd user && make build && cd -

build: build-user
	@echo "Build os"
	@cd os && make build && cd -

run-gdb: build
	qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios ./bootloader/rustsbi-qemu.bin \
    -device loader,file=${OUT_DIR}/${TARGET}/debug/${BIN_NAME},addr=0x80200000 \
    -s -S

run: build
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

.PHONY : clean
