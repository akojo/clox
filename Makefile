all_sources = $(wildcard *.c)
all_objects = $(subst .c,.o,$(all_sources))

clox: $(all_objects)
	@echo LINK $@
	$(quiet)$(LINK.c) $^ $(LDLIBS) -o $@

clean:
	rm -f clox $(all_objects) $(call to-deps,$(all_sources))

.PHONY: clean

quiet := $(if $V,,@)

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
