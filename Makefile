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

DVBFORMATCONVERT_CHANNEL_DVBV5 = -ICHANNEL -ODVBV5

DVBV3DIRS = atsc dvb-c dvb-s dvb-t
DVBV3CHANNELFILES = $(foreach dir,$(DVBV3DIRS),$(wildcard $(dir)/*))

DVBV5OUTPUTDIR = dvbv5

makedvbv5:
	@$(foreach var,$(DVBV3DIRS), $(MKDIR) $(DVBV5OUTPUTDIR)/$(var);)
	@$(foreach var,$(DVBV3CHANNELFILES), $(DVBFORMATCONVERT) $(DVBFORMATCONVERT_CHANNEL_DVBV5) $(var) $(DVBV5OUTPUTDIR)/$(var);)
