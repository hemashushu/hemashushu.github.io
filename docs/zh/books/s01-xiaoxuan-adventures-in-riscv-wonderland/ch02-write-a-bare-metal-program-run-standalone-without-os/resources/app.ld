OUTPUT_ARCH(riscv)
ENTRY(_start)
BASE_ADDRESS = 0x80000000;

SECTIONS
{
  . = BASE_ADDRESS;

  .text : {
    *(.text.entry)
    *(.text .text.*)
  }

  .rodata : {
    *(.rodata .rodata.*)
  }

  .data : {
    *(.data .data.*)
  }

  .bss :{
    *(.bss .bss.*)
  }

  . = ALIGN(8);

  /* a 4KB stack */
  stack_bottom = .;
  . += 4096;
  stack_top = .;
}
