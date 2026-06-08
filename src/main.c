#include "stm32f100xb.h"
#include <stdint.h>
#include <stdbool.h>

#define timer_ms(ms) do { \
    TIM2->ARR  = (ms) - 1;    \
    TIM2->EGR  = (1 << 0);    \
    TIM2->SR   = 0;           \
    TIM2->CR1 |= (1 << 0);    \
    __asm__ volatile ("wfi"); \
    TIM2->CR1 &= ~(1 << 0);   \
} while (0)

#define aplicar_cor(idx) do {                        \
    uint32_t odr = GPIOA->ODR;                       \
    odr &= ~0b111u;                                  \
    odr |= (cores[(idx)][0] << 0)                    \
         | (cores[(idx)][1] << 1)                    \
         | (cores[(idx)][2] << 2);                   \
    GPIOA->ODR = odr;                                \
} while (0)

static volatile uint8_t cor_atual = 0;

static const uint8_t cores[7][3] = {
    {0, 1, 1},  // Verde
    {1, 0, 1},  // Azul
    {1, 1, 0},  // Vermelho
    {0, 1, 0},  // Amarelo
    {0, 0, 1},  // Ciano
    {1, 0, 0},  // Magenta
    {1, 1, 1},  // Branco
};

void TIM2_IRQHandler(void) {
    if (TIM2->SR & (1 << 0)) {
        TIM2->SR &= ~(1 << 0);
    }
}

int main(void) {
    RCC->APB2ENR |= (1 << 0) | (1 << 2) | (1 << 3);
    RCC->APB1ENR |= (1 << 0);

    GPIOA->CRL = 0x00;
    GPIOB->CRL = 0x00;
    GPIOB->CRH = 0x00;
    GPIOB->CRL |= (0b0010 << 4);
    GPIOB->CRH |= (0b0010 << 8) | (0b0010 << 12);
    GPIOA->CRL |= (0b0010 << 0) | (0b0010 << 4) | (0b0010 << 8);

    aplicar_cor(0);

    TIM2->PSC  = 7999;
    TIM2->DIER = (1 << 0);
    TIM2->CR1  = 0;

    NVIC->ISER[0] |= (1 << 28);
    __asm__ volatile ("cpsie i");

    while (1) {
        cor_atual = (cor_atual + 1) % 7;
        aplicar_cor(cor_atual);
        timer_ms(500);
    }
}
