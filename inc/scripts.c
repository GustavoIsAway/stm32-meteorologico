#include "scripts.h"

void gpioAOutputSet(unsigned char pin) {
  if (pin < 8){
    GPIOA_CRL &= ~(0b1111U << (4 * pin));
    GPIOA_CRL |= (0b0011U << (4 * pin));
  } else {
    unsigned char normalizedPin = pin - 8;
    GPIOA_CRH &= ~(0b1111U << (4 * normalizedPin));
    GPIOA_CRH |= (0b0011U << (4 * normalizedPin));
  }    
}


void gpioBOutputSet(unsigned char pin) {
  if (pin < 8){
    GPIOB_CRL &= ~(0b1111U << (4 * pin));
    GPIOB_CRL |= (0b0011U << (4 * pin));
  } else {
    unsigned char normalizedPin = pin - 8;
    GPIOB_CRH &= ~(0b1111U << (4 * normalizedPin));
    GPIOB_CRH |= (0b0011U << (4 * normalizedPin));
  }    
}


void gpioCOutputSet(unsigned char pin) {
  if (pin < 8){
    GPIOC_CRL &= ~(0b1111U << (4 * pin));
    GPIOC_CRL |= (0b0011U << (4 * pin));
  } else {
    unsigned char normalizedPin = pin - 8;
    GPIOC_CRH &= ~(0b1111U << (4 * normalizedPin));
    GPIOC_CRH |= (0b0011U << (4 * normalizedPin));
  }    
}


/* Função de delay simples */
void delayBurro(uint32_t count) {

  count *= 2000000;
  while(count--) {
    __asm__("nop");
  }
}



void sleep_ms() {
  __asm__ volatile ("wfi");
}