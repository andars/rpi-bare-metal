TOOLCHAIN = arm-none-eabi
BUILD = build
SOURCE = src
TARGET = kernel.bin
LIST = kernel.list
MAP = kernel.map
LINKER = link.ld
OBJECTS := $(patsubst $(SOURCE)/%.s, $(BUILD)/%.o, $(wildcard $(SOURCE)/*.s))

all: $(TARGET) $(LIST)

$(LIST) : $(BUILD)/kernel.elf
	$(TOOLCHAIN)-objdump -d $(BUILD)/kernel.elf > $(LIST)

kernel.bin: $(BUILD)/kernel.elf
	$(TOOLCHAIN)-objcopy $(BUILD)/kernel.elf -O binary $(TARGET) 

# Rule to make the elf file.
$(BUILD)/kernel.elf : $(OBJECTS) $(LINKER)
	$(TOOLCHAIN)-ld --no-undefined $(OBJECTS) -Map $(MAP) -o $(BUILD)/kernel.elf -T $(LINKER)

# Rule to make the object files.
$(BUILD)/%.o: $(SOURCE)/%.s $(BUILD)/
	$(TOOLCHAIN)-as -I $(SOURCE)/ $< -o $@

$(BUILD)/:
	mkdir $@

# Rule to clean files.
clean : 
	-rm -rf $(BUILD)/
	-rm -f $(TARGET)
	-rm -f $(LIST)
	-rm -f $(MAP)
