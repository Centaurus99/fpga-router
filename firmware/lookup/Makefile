CXX ?= g++
CXXFLAGS ?= --std=c++11
LDFLAGS ?=

.PHONY: all clean grade
all: lookup

clean:
	rm -f *.o lookup std

grade: lookup lookup_bf
	python3 grade.py

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $^ -o $@

%.o: %.c
	$(CXX) $(CXXFLAGS) -c $^ -o $@

lookup: lookup.o main.o common.o memhelper.o
	$(CXX) $^ -o $@ $(LDFLAGS)

lookup_bf: lookup_bf.o main.o common.o
	$(CXX) $^ -o $@ $(LDFLAGS) 

std: std.o main.o common.o
	$(CXX) $^ -o $@ $(LDFLAGS) 
