CXX ?= g++
CXXFLAGS ?= --std=c++11 -g
LDFLAGS ?= -g

RV ?= riscv64-unknown-elf-gcc
RVFLAGS ?= -march=rv32i -mabi=ilp32 -nostdlib -nostdinc -g
RVLDFLAGS ?= -march=rv32i -mabi=ilp32 -Wl,-Ttext,0x0

.PHONY: all clean grade
all: lookup

clean:
	rm -f *.o lookup lookup_bf lookup_rv32i 

grade: lookup lookup_bf
	python3 grade.py

forsim: lookup lookup_bf
	rm -f data/test*
	python grade.py gen_forsim
	./lookup < data/forsim_input.txt > data/forsim_answer.txt
	cp mem.txt data/forsim_mem.txt

	./lookup < data/direct_route.txt
	cp mem.txt data/direct_route_mem.txt

	cp -r data/ ../../tanlabs/tanlabs.srcs/sim_1/new/

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $^ -o $@

%.o: %.c
	$(CXX) $(CXXFLAGS) -c $^ -o $@

%_r.o: %.c
	$(RV) $(RVFLAGS) -c $^ -o $@

uart_r.o: uart.s
	$(RV) $(RVFLAGS) -c $^ -o $@

lookup_rv32i.elf: main_rv32i_r.o lookup_r.o memhelper_r.o uart_r.o
	$(RV)  $^ -o $@ $(RVLDFLAGS)
%.bin: %.elf
	riscv64-unknown-elf-objcopy -j .text -O binary -S $< $@

lookup: main.o lookup.o memhelper.o debug.o
	$(CXX) $^ -o $@ $(LDFLAGS)

lookup_bf: lookup_bf.o main.o
	$(CXX) $^ -o $@ $(LDFLAGS) 

