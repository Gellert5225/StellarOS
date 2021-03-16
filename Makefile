SRC_DIR := src
ISO_DIR := iso
BIN_DIR := bin

CC = gcc
LD = ld
NASM = nasm

CFLAGS = -fno-pic -static -fno-builtin -fno-strict-aliasing -O2 -Wall -MD -ggdb -m32 -Werror -fno-omit-frame-pointer -fno-pie -no-pie
LFLAGS = -m32
NASMFLAGS = -f bin -o

EXE := $(BIN_DIR)/boot
C_SRC := $(wildcard $(SRC_DIR)/*.c)
BOOT_SRC := $(wildcard $(SRC_DIR)/boot.S)

OBJ := $(C_SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

all: build run 

build: boot $(ISO_DIR)
	dd status=noxfer conv=notrunc if=$(BIN_DIR)/boot.bin of=$(ISO_DIR)/boot.iso

boot: $(BIN_DIR) $(BOOT_SRC)
	$(NASM) $(NASMFLAGS) $(BIN_DIR)/boot.bin $(BOOT_SRC)

run: 
	qemu-system-i386 -fda $(ISO_DIR)/boot.iso

clean:
	rm -rf bin/* iso/*

$(ISO_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@
