CXX ?= g++
CXXFLAGS ?= --std=c++11 -g -I. -DLOOKUP_ONLY
LDFLAGS ?= -g

override TRACE ?= n
ifeq ($(TRACE), y)
	CXXFLAGS += -DTRACE
endif

.PHONY: all clean grade
all: lookup

clean:
	rm -f *.o lookup lookup_bf

grade: lookup lookup_bf
	python3 grade.py

forsim: lookup lookup_bf
	rm -f data/test*
	python grade.py gen_forsim
	./lookup m < data/forsim_input.txt > data/forsim_answer.txt
	cp mem.txt data/forsim_mem.txt

	./lookup < data/direct_route.txt
	cp mem.txt data/direct_route_mem.txt


%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $^ -o $@

%.o: %.c
	$(CXX) $(CXXFLAGS) -c $^ -o $@

lookup: main.o lookup.o memhelper.o debug.o
	$(CXX) $^ -o $@ $(LDFLAGS)

lookup_bf: lookup_bf.o main.o
	$(CXX) $^ -o $@ $(LDFLAGS) 

