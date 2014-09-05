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

DVBV3CHANNELFILES = $(foreach dir,$(DVBV3DIRS),$(wildcard $(dir)/*))

DVBFORMATCONVERT_CHANNEL_DVBV5 = -ICHANNEL -ODVBV5
DVBFORMATCONVERT_CHANNEL_DVBV3 = -IDVBV5 -OCHANNEL

DVBV3OUTPUTDIR = dvbv3
DVBV5OUTPUTDIR = dvbv5

PHONY := clean dvbv3 dvbv5

dvbv3:
	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV3OUTPUTDIR)/$(var);)
	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV3) $(var) $(DVBV3OUTPUTDIR)/$(var);)


dvbv5: $(DVBV3OUTPUTDIR)
	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV5OUTPUTDIR)/$(var);)
	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV5) $(DVBV3OUTPUTDIR)/$(var) $(DVBV5OUTPUTDIR)/$(var);)


clean:
	rm -rf $(DVBV3OUTPUTDIR)/ $(DVBV5OUTPUTDIR)/
