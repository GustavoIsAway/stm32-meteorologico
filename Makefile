TARGET = blink

CMSIS_INC     = Drivers/CMSIS/Include
CMSIS_DEV_INC = Drivers/CMSIS/Device/ST/STM32F1xx/Include
HAL_INC       = Drivers/STM32F1xx_HAL_Driver/Inc
HAL_SRC       = Drivers/STM32F1xx_HAL_Driver/Src

HAL_SRCS = \
    $(HAL_SRC)/stm32f1xx_hal.c \
    $(HAL_SRC)/stm32f1xx_hal_cortex.c \
    $(HAL_SRC)/stm32f1xx_hal_gpio.c \
    $(HAL_SRC)/stm32f1xx_hal_rcc.c

HAL_OBJS = $(patsubst $(HAL_SRC)/%.c, obj/hal/%.o, $(HAL_SRCS))

OBJS = obj/main.o obj/startup.o obj/scripts.o obj/system_stm32f1xx.o $(HAL_OBJS)

CC      = clang
LD      = ld.lld
OBJCOPY = llvm-objcopy

INCLUDES = \
    -Iinc \
    -I$(CMSIS_INC) \
    -I$(CMSIS_DEV_INC) \
    -I$(HAL_INC)

DEFINES = -DSTM32F100xB -DUSE_HAL_DRIVER

CFLAGS = \
    --target=arm-none-eabi -mcpu=cortex-m3 -mthumb \
    -nostdlib -ffreestanding -Wall -Os \
    -fno-exceptions -fno-unwind-tables -fno-asynchronous-unwind-tables \
    $(INCLUDES) $(DEFINES)

ASFLAGS = --target=arm-none-eabi -mcpu=cortex-m3 -mthumb

LIBGCC_PATH = /usr/lib/gcc/arm-none-eabi/14.2.1/thumb/v7-m/nofp
LDFLAGS = -T linker.ld -Map=$(TARGET).map -L$(LIBGCC_PATH) -lgcc

all: $(TARGET).bin

obj/main.o: src/main.c
	$(CC) $(CFLAGS) -c $< -o $@

obj/scripts.o: inc/scripts.c
	$(CC) $(CFLAGS) -c $< -o $@

obj/startup.o: src/startup.s
	$(CC) $(ASFLAGS) -c $< -o $@

obj/system_stm32f1xx.o: Drivers/CMSIS/Device/ST/STM32F1xx/Source/Templates/system_stm32f1xx.c
	$(CC) $(CFLAGS) -c $< -o $@

obj/hal/%.o: $(HAL_SRC)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

$(TARGET).elf: $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $@

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

$(OBJS): | obj/ obj/hal/

obj/:
	mkdir -p obj

obj/hal/:
	mkdir -p obj/hal

clean:
	rm -f obj/*.o obj/hal/*.o *.elf *.bin *.map

flash: all
	st-flash write $(TARGET).bin 0x8000000

.clangd:
	@echo "CompileFlags:" > .clangd
	@echo "  Add:" >> .clangd
	@echo "    - --target=arm-none-eabi" >> .clangd
	@echo "    - -mcpu=cortex-m3" >> .clangd
	@echo "    - -mthumb" >> .clangd
	@echo "    - -nostdlib" >> .clangd
	@echo "    - -ffreestanding" >> .clangd
	@echo "    - -DSTM32F100xB" >> .clangd
	@echo "    - -DUSE_HAL_DRIVER" >> .clangd
	@echo "    - -I$(CURDIR)/inc" >> .clangd
	@echo "    - -I$(CURDIR)/Drivers/CMSIS/Include" >> .clangd
	@echo "    - -I$(CURDIR)/Drivers/CMSIS/Device/ST/STM32F1xx/Include" >> .clangd
	@echo "    - -I$(CURDIR)/Drivers/STM32F1xx_HAL_Driver/Inc" >> .clangd
	@echo "  Remove:" >> .clangd
	@echo "    - -fno-exceptions" >> .clangd
	@echo "    - -fno-unwind-tables" >> .clangd
	@echo "    - -fno-asynchronous-unwind-tables" >> .clangd