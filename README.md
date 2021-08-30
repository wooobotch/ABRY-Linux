At this point this repo shouldn't be more than an installer: a little script to wrap up some lines for a swifter first moment after a clean installation.

After trying many distros I decided to turn back to one of my roots, Ubuntu, since there are a lot of resources
and software I need to deploy on demand and really fast to keep on my team's track.

The main packages this script installs are now hardcoded but eventually will be listed on a different file.

It follows this steps in order to get it running:
- apt-get update, install, remove and upgrade.
- git clone (dwm, st)
- fonts download
- _make_ and _make clean install_ downloaded repos.
- _sudo reboot_
