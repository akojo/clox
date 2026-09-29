CLOX := clox

all_sources = $(wildcard *.c)
all_objects = $(subst .c,.o,$(all_sources))

$(CLOX): $(all_objects)
	@echo LINK $@
	$(quiet)$(LINK.c) $^ $(LDLIBS) -o $@

CLOX_TEST = test/clox_test

test_sources = $(wildcard test/*.cpp)
test_objects = $(subst .cpp,.o,$(test_sources))

$(CLOX_TEST): LDLIBS = -lCppUTest
$(CLOX_TEST): $(test_objects) $(filter-out main.o,$(all_objects))
	@echo LINK $@
	$(quiet)$(LINK.cc) $^ $(LDLIBS) -o $@

test: $(CLOX_TEST)
	$(CLOX_TEST)

clean:
	rm -f $(CLOX) $(all_objects) $(call to-deps,$(all_sources)) \
		$(CLOX_TEST) $(test_objects) $(call to-deps,$(test_sources))

.PHONY: test clean

quiet := $(if $V,,@)

CPPFLAGS := -I.

define to-deps
$(join $(dir $1),$(addprefix .,$(addsuffix .d,$(notdir $1))))
endef

define make-compile-command
%.o: %.$1
	@echo COMPILE.$1 $$<
	$(quiet)$$(COMPILE.$1) -MM -MF $$(call to-deps,$$<) -MP -MT $$@ $$<
	$(quiet)$$(COMPILE.$1) $$(OUTPUT_OPTION) $$<
endef

$(foreach ext,c cpp cc C,\
	$(eval $(call make-compile-command,$(ext))))

ifneq "$(MAKECMDGOALS)" "clean"
-include $(call to-deps,$(all_sources))
endif
