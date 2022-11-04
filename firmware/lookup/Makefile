CXX ?= g++
CXXFLAGS ?= --std=c++11
LDFLAGS ?=

.PHONY: all clean grade
all: lookup

clean:
	rm -f *.o lookup std

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

lookup: main.o lookup.o common.o memhelper.o
	$(CXX) $^ -o $@ $(LDFLAGS)

lookup_bf: lookup_bf.o main.o common.o
	$(CXX) $^ -o $@ $(LDFLAGS) 

std: std.o main.o common.o
	$(CXX) $^ -o $@ $(LDFLAGS) 
