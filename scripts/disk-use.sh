#!/bin/bash
df -h -x tmpfs -x devtmpfs -x efivarfs --output=source,target,pcent,avail |
	tail --lines=+2 |
	tr -s " "
