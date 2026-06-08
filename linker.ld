ENTRY(_start)
MEMORY
{
  FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 128K
  RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}
SECTIONS
{
  .text :
  {
    KEEP(*(.isr_vector))
    *(.text*)
    *(.rodata*)
    _etext = .;
  } > FLASH
  .data : AT(_etext)
  {
    _sdata = .;
    *(.data*)
    _edata = .;
  } > RAM
  .bss :
  {
    _sbss = .;
    *(.bss*)
    *(COMMON)
    _ebss = .;
  } > RAM
  /DISCARD/ :
  {
    *(.ARM.exidx*)
    *(.ARM.extab*)
  }
  _stack_top = 0x20005000;
}