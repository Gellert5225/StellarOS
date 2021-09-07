# directory setup
SRC_DIR := src
ISO_DIR := iso
BIN_DIR := bin

# compilers
CC = gcc
LD = ld
FASM = fasm

# compile flags
CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-pie -no-pie
LFLAGS = -m32
FASMFLAGS = -f bin -o

# source
C_SRC := $(wildcard $(SRC_DIR)/*.c)
BOOT_SRC := $(wildcard $(SRC_DIR)/boot/*.S)

BOOT_PROG = $(patsubst %.S,%,$(BOOT_SRC))

# make targets
all: build run

$(BOOT_PROG): | $(ISO_DIR) $(BIN_DIR)

%: %.S
	$(FASM) $< $(BIN_DIR)/$(@F).bin

build: $(BOOT_PROG)
	cat $(BIN_DIR)/*.bin > $(ISO_DIR)/os.iso

run: 
	qemu-system-i386 -drive format=raw,file=$(ISO_DIR)/os.iso

clean:
	rm -rf bin/* iso/*

# make dir if does not exist
$(ISO_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@
