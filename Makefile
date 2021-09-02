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
BOOT_SRC := $(wildcard $(SRC_DIR)/boot.S)

OBJ := $(C_SRC:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

# make targets
all: build run 

build: boot $(ISO_DIR)
	cat $(BIN_DIR)/boot.bin $(BIN_DIR)/kernel.bin > $(ISO_DIR)/os.iso
#	dd status=noxfer conv=notrunc if=$(BIN_DIR)/boot.bin of=$(ISO_DIR)/boot.bin

boot: $(BIN_DIR) $(SRC_DIR)
	$(FASM) src/boot.S $(BIN_DIR)/boot.bin
	$(FASM) src/kernel.S $(BIN_DIR)/kernel.bin

run: 
	qemu-system-i386 -drive format=raw,file=$(ISO_DIR)/os.iso

clean:
	rm -rf bin/* iso/*

# make dir if does not exist
$(ISO_DIR):
	mkdir -p $@

$(BIN_DIR):
	mkdir -p $@
