#include "scripts.h"
#include "stm32f100xb.h"
#include <stdint.h>
#include <stdbool.h>


force_inline void timer_ms(int ms) {
	TIM2->ARR  = ms - 1;
	TIM2->EGR  = (1 << 0);
	TIM2->SR   = 0;
	TIM2->CR1 |= (1 << 0);
	__asm__ volatile ("wfi");
	TIM2->CR1 &= ~(1 << 0);
}


typedef struct {
	unsigned char data[128];
	unsigned int  len;
	bool          data_ready;
} SmartBuffer;

volatile SmartBuffer usart_rx = {0};


void USART1_IRQHandler(void) {
	if (!(USART1->SR & USART_SR_RXNE)) return;

	unsigned char c = USART1->DR;

	if (c == '\n' || c == '\r' || c == '\0') {
		if (!usart_rx.data_ready) {
			usart_rx.data[usart_rx.len] = '\0';
			usart_rx.data_ready = true;
		}
		return;
	}

	if (usart_rx.data_ready) {
		usart_rx.len        = 0;
		usart_rx.data_ready = false;
	}

	if (usart_rx.len < sizeof(usart_rx.data) - 1)
		usart_rx.data[usart_rx.len++] = c;
}

void TIM2_IRQHandler(void) {
	if (TIM2->SR & (1 << 0))
		TIM2->SR &= ~(1 << 0);
}


force_inline void usart1_send_byte(char c) {
    while(!(USART1->SR & USART_SR_TXE));
    USART1->DR = c;
}

force_inline void usart1_send_str(const char *buffer) {
	int idx = 0;
	while (buffer[idx])
		usart1_send_byte(buffer[idx++]);
}


int main(void) {
	RCC->APB2ENR |= RCC_APB2ENR_USART1EN |
	                RCC_APB2ENR_IOPAEN   |
	                RCC_APB2ENR_IOPCEN;
	RCC->APB1ENR |= RCC_APB1ENR_TIM2EN;

	GPIOA->CRL = 0x00;
	GPIOC->CRL = 0x00;
	gpioCOutputSet(13);

	TIM2->PSC  = 7999;
	TIM2->DIER = (1 << 0);
	TIM2->CR1  = 0;

	// PA9 = TX
	GPIOA->CRH &= ~(0xF << 4);
	GPIOA->CRH |=  (0x9 << 4);

	// PA10 = RX
	GPIOA->CRH &= ~(0xF << 8);
	GPIOA->CRH |=  (0x4 << 8);

	// HC-05 a 38400 baud
	USART1->BRR = 208;
	USART1->CR1 = USART_CR1_TE   |
	              USART_CR1_RE   |
	              USART_CR1_UE   |
	              USART_CR1_RXNEIE;

	NVIC->ISER[0] |= (1 << 28);
	NVIC->ISER[1] |= (1 << 5);
	__asm__ volatile ("cpsie i");

    usart1_send_str("Oi mãe!\n");

	while (1) {
		if (!usart_rx.data_ready) continue;

		if (usart_rx.data[0] == '1')
			GPIOC->ODR &= ~(1 << 13);
		else if (usart_rx.data[0] == '2')
			GPIOC->ODR |= (1 << 13);

		usart_rx.data_ready = false;
		usart_rx.len        = 0;
	}
}