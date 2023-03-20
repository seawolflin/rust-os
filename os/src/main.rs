#![no_std]
#![no_main]
#![feature(panic_info_message)]

mod batch;
#[macro_use]
mod console;
mod lang_items;
mod sbi;
mod trap;
mod sync;
mod syscall;
#[path = "boards/qemu.rs"]
mod board;

use core::arch::global_asm;

global_asm!(include_str!("entry.asm"));
global_asm!(include_str!("link_app.S"));

#[no_mangle]
fn rust_main() {
    clear_bss();
    println!("Hello World!");

    trap::init();
    batch::init();
    batch::run_next_app();
}

fn clear_bss() {
    extern "C" {
        fn sbss();
        fn ebss();
    }
    (sbss as usize..ebss as usize).for_each(|a| unsafe {
        (a as *mut u8).write_volatile(0);
    })
}
