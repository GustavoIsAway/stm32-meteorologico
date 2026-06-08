/* Definições básicas para STM32F100 */
#ifndef SCRIPTS_H
#define SCRIPTS_H
#include <stdint.h>

typedef enum {
  TRUE = 1,
  FALSE = 0
} bl;

#define PERIPH_BASE       0x40000000UL
#define APB2PERIPH_BASE   (PERIPH_BASE + 0x10000)
#define AHBPERIPH_BASE    (PERIPH_BASE + 0x20000)

#define RCC_BASE          (AHBPERIPH_BASE + 0x1000)
#define GPIOA_BASE        (APB2PERIPH_BASE + 0x0800)
#define GPIOB_BASE        (APB2PERIPH_BASE + 0x0C00)
#define GPIOC_BASE        (APB2PERIPH_BASE + 0x1000)

/* Ponteiros para registradores */
#define RCC_APB2ENR       (*(volatile uint32_t*)(RCC_BASE + 0x18))
#define GPIOA_CRL         (*(volatile uint32_t*)(GPIOA_BASE + 0x00))
#define GPIOA_CRH         (*(volatile uint32_t*)(GPIOA_BASE + 0x04))
#define GPIOA_ODR         (*(volatile uint32_t*)(GPIOA_BASE + 0x0C))
#define GPIOB_CRL         (*(volatile uint32_t*)(GPIOB_BASE + 0x00))
#define GPIOB_CRH         (*(volatile uint32_t*)(GPIOB_BASE + 0x04))
#define GPIOB_ODR         (*(volatile uint32_t*)(GPIOB_BASE + 0x0C))
#define GPIOC_CRL         (*(volatile uint32_t*)(GPIOC_BASE + 0x00))
#define GPIOC_CRH         (*(volatile uint32_t*)(GPIOC_BASE + 0x04))
#define GPIOC_ODR         (*(volatile uint32_t*)(GPIOC_BASE + 0x0C))

#define RCC_IOPAEN        (1 << 2)   // Bit para habilitar clock do GPIOA
#define RCC_IOPBEN        (1 << 3)   // Bit para habilitar clock do GPIOA
#define RCC_IOPCEN        (1 << 4)   // Bit para habilitar clock do GPIOC
#define LED_INTERNO_PIN   (1 << 13)  // PC13

#define WRITE_GPIOA(pin, value) ((value) ? (GPIOA_ODR |= (1 << pin)) : (GPIOA_ODR &= ~(1 << pin)))
#define WRITE_GPIOB(pin, value) ((value) ? (GPIOB_ODR |= (1 << pin)) : (GPIOB_ODR &= ~(1 << pin)))
#define WRITE_GPIOC(pin, value) ((value) ? (GPIOC_ODR |= (1 << pin)) : (GPIOC_ODR &= ~(1 << pin)))

 

void gpioAOutputSet(unsigned char pin);


void gpioBOutputSet(unsigned char pin);


void gpioCOutputSet(unsigned char pin);


/* Função de delay simples */
void delayBurro(uint32_t count);

#endif
