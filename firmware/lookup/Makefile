CXX ?= g++
CXXFLAGS ?= --std=c++11
LDFLAGS ?=

.PHONY: all clean grade
all: lookup

clean:
	rm -f *.o lookup std

grade: lookup lookup_bf
	./lookup < data/direct_route.txt
	cp mem.txt ../../tanlabs/tanlabs.srcs/sim_1/new/mem.txt
	python3 grade.py

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
