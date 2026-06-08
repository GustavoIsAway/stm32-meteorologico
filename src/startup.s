.syntax unified
.cpu cortex-m3
.thumb
.global _start
.global Reset_Handler
.global TIM2_IRQHandler
.section .isr_vector, "a", %progbits
.type _start, %function

_start:
  .word _stack_top          /* 0  Topo da pilha */
  .word Reset_Handler       /* 1  Reset */
  .word 0                   /* 2  NMI */
  .word 0                   /* 3  HardFault */
  .word 0                   /* 4  MemManage */
  .word 0                   /* 5  BusFault */
  .word 0                   /* 6  UsageFault */
  .word 0                   /* 7  Reserved */
  .word 0                   /* 8  Reserved */
  .word 0                   /* 9  Reserved */
  .word 0                   /* 10 Reserved */
  .word 0                   /* 11 SVCall */
  .word 0                   /* 12 DebugMon */
  .word 0                   /* 13 Reserved */
  .word 0                   /* 14 PendSV */
  .word 0	            /* 15 SysTick */
  /* IRQs externas */
  .word 0                   /* 16 IRQ0  WWDG */
  .word 0                   /* 17 IRQ1  PVD */
  .word 0                   /* 18 IRQ2  TAMPER */
  .word 0                   /* 19 IRQ3  RTC */
  .word 0                   /* 20 IRQ4  FLASH */
  .word 0                   /* 21 IRQ5  RCC */
  .word 0                   /* 22 IRQ6  EXTI0 */
  .word 0                   /* 23 IRQ7  EXTI1 */
  .word 0                   /* 24 IRQ8  EXTI2 */
  .word 0                   /* 25 IRQ9  EXTI3 */
  .word 0                   /* 26 IRQ10 EXTI4 */
  .word 0                   /* 27 IRQ11 DMA1_CH1 */
  .word 0                   /* 28 IRQ12 DMA1_CH2 */
  .word 0                   /* 29 IRQ13 DMA1_CH3 */
  .word 0                   /* 30 IRQ14 DMA1_CH4 */
  .word 0                   /* 31 IRQ15 DMA1_CH5 */
  .word 0                   /* 32 IRQ16 DMA1_CH6 */
  .word 0                   /* 33 IRQ17 DMA1_CH7 */
  .word 0                   /* 34 IRQ18 ADC1 */
  .word 0                   /* 35 IRQ19 Reserved */
  .word 0                   /* 36 IRQ20 Reserved */
  .word 0                   /* 37 IRQ21 Reserved */
  .word 0                   /* 38 IRQ22 Reserved */
  .word 0                   /* 39 IRQ23 EXTI9_5 */
  .word 0                   /* 40 IRQ24 TIM1_BRK */
  .word 0                   /* 41 IRQ25 TIM1_UP */
  .word 0                   /* 42 IRQ26 TIM1_TRG_COM */
  .word 0                   /* 43 IRQ27 TIM1_CC */
  .word Timer2_IRQHandler   /* 44 IRQ28 TIM2 */
  .word 0                   /* 45 IRQ29 TIM3 */
  .word 0                   /* 46 IRQ30 TIM4 */
  .word 0                   /* 47 IRQ31 I2C1_EV */
  .word 0                   /* 48 IRQ32 I2C1_ER */
  .word 0                   /* 49 IRQ33 I2C2_EV */
  .word 0                   /* 50 IRQ34 I2C2_ER */
  .word 0                   /* 51 IRQ35 SPI1 */
  .word 0                   /* 52 IRQ36 SPI2 */
  .word 0                   /* 53 IRQ37 USART1 */
  .word 0                   /* 54 IRQ38 USART2 */
  .word 0                   /* 55 IRQ39 USART3 */
  .word 0                   /* 56 IRQ40 EXTI15_10 */
  .word 0                   /* 57 IRQ41 RTCAlarm */
  .word 0                   /* 58 IRQ42 CEC */
  .word 0                   /* 59 IRQ43 TIM12 */
  .word 0                   /* 60 IRQ44 TIM13 */
  .word 0                   /* 61 IRQ45 TIM14 */
  .word 0                   /* 62 IRQ46 Reserved */
  .word 0                   /* 63 IRQ47 Reserved */
  .word 0                   /* 64 IRQ48 Reserved */
  .word 0                   /* 65 IRQ49 Reserved */
  .word 0                   /* 66 IRQ50 Reserved */
  .word 0                   /* 67 IRQ51 TIM6_DAC */
  .word 0                   /* 68 IRQ52 TIM7 */
  .word 0                   /* 69 IRQ53 Reserved */
  .word 0                   /* 70 IRQ54 Reserved */
  .word 0                   /* 71 IRQ55 Reserved */
  .word 0                   /* 72 IRQ56 Reserved */
  .word 0                   /* 73 IRQ57 Reserved */
  .word 0                   /* 74 IRQ58 Reserved */
  .word 0                   /* 75 IRQ59 Reserved */

.section .text.Reset_Handler, "ax", %progbits
.type Reset_Handler, %function
Reset_Handler:
  /* Copiar .data da Flash para RAM */
  ldr r0, =_sdata
  ldr r1, =_edata
  ldr r2, =_etext
copy_data:
  cmp r0, r1
  bge copy_data_end
  ldr r3, [r2], #4
  str r3, [r0], #4
  b copy_data
copy_data_end:
  /* Zerar .bss */
  ldr r0, =_sbss
  ldr r1, =_ebss
  movs r2, #0
clear_bss:
  cmp r0, r1
  bge clear_bss_end
  str r2, [r0], #4
  b clear_bss
clear_bss_end:
  /* Chamar main() */
  bl main
.infinite:
  b .infinite
