Avorion Dedicated Server Container Image
========================================

This Dockerfile builds a container image for running an Avorion dedicated server.
It is shitty and you should probably not use it.

I am making it public with deep shame.

Ways in which it is shitty:
---------------------------

- Embeds steamcmd with no cache bursting for the actual install part.
  Can only be updated by clearing cache and rebuilding.
- Runtime UID/GIDs are baked in the image and can only be changed by rebuilding
- No multi stage build, so the resultant image has a ton of unecessary cruft
- Does not actually setups the 'backups' directory in the data volume

Ways in which it's alright:
----------------------------

- Single volume at /data for all data
- Simply wraps `server.sh` as entrypoint

Quickstart
----------

- Step 1: don't
