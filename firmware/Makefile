TRIPLE = riscv64-unknown-elf-
GCC = $(TRIPLE)gcc
OBJCOPY = $(TRIPLE)objcopy
OBJDUMP = $(TRIPLE)objdump
QEMU = qemu-system-riscv32

DEFINES = -DPRINTF_DISABLE_SUPPORT_FLOAT -DPRINTF_DISABLE_SUPPORT_EXPONENTIAL \
          -DPRINTF_DISABLE_SUPPORT_LONG_LONG
CFLAGS = -fno-builtin -nostdlib -nostdinc -static -Wl,--gc-sections,--print-gc-sections -O2 -Wall \
         -Iinclude -Ilookup $(DEFINES) -march=rv32i -mabi=ilp32 -mstrict-align -DRV32 -g
LDFLAGS = -z separate-code -g

LOOKUP=lookup/lookup.o lookup/memhelper.o lookup/debug.o

override EN_BITMANIP ?= n
ifeq ($(EN_BITMANIP), y)
	TRIPLE = /opt/riscv64b/bin/riscv64-unknown-elf-
	CFLAGS += -DENABLE_BITMANIP
	LDFLAGS += -march=rv32ib
	LOOKUP += lookup/pcnt.s
endif

-include Makefile.config

override EN_UART16550 ?= y
ifeq ($(EN_UART16550), y)
	CFLAGS += -DENABLE_UART16550
endif

override EN_VGA ?= n
ifeq ($(EN_VGA), y)
	CFLAGS += -DENABLE_VGA
endif

override EN_ROUTE_SUM ?= y
ifeq ($(EN_ROUTE_SUM), y)
	CFLAGS += -DENABLE_ROUTE_SUM
endif

override ON_BOARD ?= y
ifeq ($(ON_BOARD), y)
	CFLAGS += -DON_BOARD
endif

override DISABLE_TIMER ?= n
ifeq ($(DISABLE_TIMER), y)
	CFLAGS += -DDISABLE_TIMER
endif

override DEBUG ?= n
ifeq ($(DEBUG), y)
	CFLAGS += -D_DEBUG
endif

override TIME_DEBUG ?= n
ifeq ($(TIME_DEBUG), y)
	CFLAGS += -DTIME_DEBUG
endif

override BOARD ?= S
ifeq ($(BOARD), 0)
	CFLAGS += -DTEST_DEFINENATION
	CFLAGS += -DBOARD_0
else ifeq ($(BOARD), 1)
	CFLAGS += -DTEST_DEFINENATION
	CFLAGS += -DBOARD_1
else ifeq ($(BOARD), 2)
	CFLAGS += -DTEST_DEFINENATION
	CFLAGS += -DBOARD_2
else ifeq ($(BOARD), S)
	CFLAGS += -DTEST_DEFINENATION
	CFLAGS += -DSINGLE_TEST
else ifeq ($(BOARD), G)
	CFLAGS += -DTEST_DEFINENATION
	CFLAGS += -DGROUP_TEST
endif

override CONTINOUS_ADDR ?= y
ifeq ($(CONTINOUS_ADDR), y) 
	CFLAGS += -DCONTINOUS_ADDR
endif

HEADERS=$(wildcard include/*.h)
SOURCES=$(wildcard *.c *.S)
OBJECTS=$(patsubst %.c,%.o,$(wildcard *.c)) $(patsubst %.S,%.o,$(wildcard *.S))
TARGET=kernel.elf

.PHONY: all
all: $(OBJECTS) $(TARGET) kernel.bin

.PHONY: viasm
viasm: $(TARGET)
	$(OBJDUMP) -xd $< | vi -

.PHONY: inst
inst: $(TARGET)
	$(OBJDUMP) -Mno-aliases -d $< | ./inst.py

%.asm: %.elf
	$(OBJDUMP) -xd $< > $@

%.bin: %.elf
	$(OBJCOPY) -S --adjust-vma -0x00000000 -O binary $< $@

%.o: %.c $(HEADERS)
	$(GCC) $(CFLAGS) -c $< -o $@

%.o: %.S $(HEADERS)
	$(GCC) $(CFLAGS) -c $< -o $@

lookup/%.o: lookup/%.c $(HEADERS)
	$(GCC) $(CFLAGS) -c $< -o $@

$(TARGET): $(OBJECTS) linker.ld $(LOOKUP)
	$(GCC) -Tlinker.ld $(CFLAGS) $(LDFLAGS) $(OBJECTS) $(LOOKUP) -lgcc -o $@

.PHONY: sim
sim: $(TARGET)
	$(QEMU) -machine virt -nographic -m 8M -kernel $(TARGET) -s -bios none -serial tcp::6666,server

.PHONY: debug
debug: $(TARGET)
	$(QEMU) -machine virt -nographic -m 8M -kernel $(TARGET) -S -s -bios none

.PHONY: clean
clean:
	-rm -f *.o *.elf *.bin *.asm $(TARGET) $(LOOKUP)
