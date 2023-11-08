# ABRY
## Auto-Bootstrapper and Resource Yoke

###Description:

At this point this repo shouldn't be more than an installer: a little script to wrap up some lines for a swifter first moment after a clean installation.

After trying many distros I decided to turn back to one of my roots, Debian, since there are a lot of resources
and software I need to deploy on demand and really fast to keep on my team's track.

The main packages this script installs are now hardcoded but eventually will be listed on a different file.

It follows this steps in order to get it running:
- apt-get update, install, remove and upgrade.
- git clone (dwm, st)
- fonts download, not actually, I'm stepping aside from some cosmetic details.
- _make_ and _make clean install_ downloaded repos.
- _reboot_

### Considerations:
- I'm moving to Debian 12 standard on my laptop. Packages started turning quite heavy for every distro.
- The *standard* part of the name is necesary, no default desktop environment at all.
- The same way I did with previous commits of this repo, just use it as a reference. On every machine I have
- modified it a little to fit what I wanted to deploy, I even ditched out the suckless things and installed xfce.
- No games in mind.

### Links:
https://dwm.suckless.org/patches/alpha/
https://dwm.suckless.org/patches/pango/
https://tools.suckless.org/slstatus/
https://dwm.suckless.org/patches/tatami/
