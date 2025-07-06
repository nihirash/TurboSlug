BINARY:=TSLUG
# Recursive wildcard macros
rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

DISK_NAME:=dist/turboslug.po
PRODOS_DISK:=prodos.po

SRC := $(call rwildcard,src,*.s *.i)
ASM:=xa
ASM_FLAGS:=-l labels.list -o $(BINARY).SYSTEM -Isrc
ACX:=java -jar tools/acx.jar 

all: $(DISK_NAME)

$(DISK_NAME): $(BINARY).SYSTEM
	mkdir -p dist
	rm -f $(DISK_NAME)
	$(ACX) create --prodos -f tools/$(PRODOS_DISK) --disk $(DISK_NAME)
	$(ACX) rm -f BASIC.SYSTEM --disk $(DISK_NAME)
#	$(ACX) copy --from "tools/$(PRODOS_DISK)" BITSY.BOOT QUIT.SYSTEM BASIC.SYSTEM --disk $(DISK_NAME)
	$(ACX) put "$(BINARY).system" -a 0x2000 --type=SYS --disk $(DISK_NAME)
	
	$(ACX) rename-disk $(BINARY) --disk $(DISK_NAME)


$(BINARY).SYSTEM: $(SRC)
	$(ASM) $(ASM_FLAGS) src/main.s

clean:
	rm -f $(BINARY).SYSTEM labels.list $(DISK_NAME)