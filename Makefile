# Makefile for dtv-scan-tables (26 May 2014)
# Copyright 2014 Jonathan McCrohan <jmccrohan@gmail.com>

# The vast majority of the DVB scan files contained in this repository
# are DVBv3 scan files. This format has been deprecated in favor of the
# DVBv5 scan format.
#
# Use this makefile to convert the existing DVBv3 scan files to DVBv5
# scan files until such time as DVBv5 scan format is in widespread use.
#
# Requires dvb-format-convert from v4l-utils.

MKDIR = mkdir -p
DVBFORMATCONVERT = dvb-format-convert

DVBV3DIRS = atsc dvb-c dvb-s dvb-t
DVBV5DIRS = $(DVBV3DIRS) isdb-t

DVBV3CHANNELFILES = $(foreach dir,$(DVBV3DIRS),$(wildcard $(dir)/*))

DVBFORMATCONVERT_CHANNEL_DVBV5 = -ICHANNEL -ODVBV5
DVBFORMATCONVERT_CHANNEL_DVBV3 = -IDVBV5 -OCHANNEL

DVBV3OUTPUTDIR = dvbv3
DVBV5OUTPUTDIR = dvbv5

PHONY := clean dvbv3 dvbv5

ifeq ($(PREFIX),)
PREFIX = /usr/local
endif

ifeq ($(DATADIR),)
DATADIR = $(PREFIX)/share
endif

ifeq ($(DVBV5DIR),)
DVBV5DIR = dvbv5
endif

ifeq ($(DVBV3DIR),)
DVBV3DIR = dvbv3
endif

dvbv3:
	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV3OUTPUTDIR)/$(var);)
	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV3) $(var) $(DVBV3OUTPUTDIR)/$(var);)


dvbv5: $(DVBV3OUTPUTDIR)
	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV5OUTPUTDIR)/$(var);)
	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV5) $(DVBV3OUTPUTDIR)/$(var) $(DVBV5OUTPUTDIR)/$(var);)

install:
	@mkdir -p $(DATADIR)/$(DVBV5DIR)
	$(foreach var,$(DVBV5DIRS), install -d -p $(DATADIR)/$(DVBV5DIR)/$(var); install -D -p -m 644 $(var)/* $(DATADIR)/$(DVBV5DIR)/$(var);)

install_v3:
	@mkdir -p $(DATADIR)/$(DVBV3DIR)
	$(foreach var,$(DVBV3DIRS), install -d -p $(DATADIR)/$(DVBV3DIR)/$(var); install -D -p -m 644 $(DVBV3OUTPUTDIR)/$(var)/* $(DATADIR)/$(DVBV3DIR)/$(var);)

clean:
	rm -rf $(DVBV3OUTPUTDIR)/ $(DVBV5OUTPUTDIR)/
