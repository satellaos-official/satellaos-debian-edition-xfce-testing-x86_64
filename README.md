# SatellaOS Debian Edition (Testing)

The experimental Debian edition of SatellaOS aims to provide a lightweight system while remaining fully compatible with Linux standards through Systemd.

> [!WARNING]
>
> This GitHub repository is the **official testing repository** for SatellaOS Debian Edition.
>
> Everything in this repository may change or break at any time. **Use it at your own risk.**
>
> If you are looking for a stable Linux experience, please download SatellaOS from the official stable repository instead.

---

## Architecture

This version of SatellaOS Debian Edition is developed for the x86_64 architecture.

---

## Why SatellaOS?

### Foundation

SatellaOS is built on top of the Debian Netinst base. Its goal is to combine Debian's solid foundation with a polished and reliable user experience. It currently targets the latest release, Debian 13 (Trixie).

### Lightweight

By default, SatellaOS ships with a very small number of installed `dpkg` packages. The total package count may increase depending on the software selected during installation.

### Modern Appearance

Unlike many XFCE-based Linux distributions, SatellaOS aims to give XFCE a modern look while maintaining its low resource usage.

### Minimal Bloatware

SatellaOS is designed to include as little bloatware as possible. Users are **not forced** to install software such as office suites, media players, or web browsers. The choice is entirely yours.

### Ecosystem

SatellaOS has its own growing ecosystem. For example, it includes `satella-appmenu-plugin` and `satella-shelf-plugin`. More tools will be added over time.

### Script-Based Installation

Unlike traditional Linux distributions, SatellaOS does **not** build or distribute ISO images.

Instead, it transforms an existing Debian Netinst installation using a collection of installation scripts. This allows development time to be spent improving the operating system instead of maintaining ISO builds.

---

## ⚠️ Warnings

### Touchscreen Support

We currently do not own any touchscreen hardware for testing. As a result, touchscreen-related issues may occur.

### Gaming

Gaming on Linux has improved significantly thanks to Proton. However, compatibility issues may still occur depending on the game or hardware configuration.

### Adobe Users

SatellaOS is a Linux distribution and therefore **does not provide official support for Adobe software.**

Some open-source alternatives are available, although they may differ in features and workflow.

You may consider the following alternatives:

> - Adobe Photoshop → GIMP
> - Adobe Illustrator → Inkscape
> - Adobe InDesign → Scribus
> - Adobe Premiere Pro → Kdenlive
> - Adobe After Effects → Blender
> - Adobe Lightroom → darktable
> - Adobe Acrobat → Okular / PDF Arranger
> - Adobe Audition → Audacity
> - Adobe XD → Penpot
> - Adobe Animate → Synfig Studio


We recommend trying these alternatives before completely switching from Windows.

---

## Installing SatellaOS

Before you start, make sure you have a clean Debian netinstall installation **without any desktop environment** (see [System Requirements](#system-requirements)).

### 1. Get sudo privileges

Skip this step if `sudo` already works for your user.

If you did not set a root password during the base installation, Debian installs the `sudo` package and grants your user sudo privileges by default, so you can skip this step.

```
su -
```

```
apt install -y sudo
```

```
usermod -aG sudo <your-username>
```

```
exit
```

Then log out and log back in so the group change takes effect.

### 2. Install dependencies

```
sudo apt install --no-install-recommends -y wget curl git
```

### 3. Install SatellaOS

```
git clone https://github.com/satellaos-official/satellaos-debian-edition-xfce-testing-x86_64.git $HOME/satellaos-install
```

```
sudo bash ~/satellaos-install/setup.sh
```

---

## System Requirements

### Installation Requirements

* **Base system:** A clean Debian 13 (Trixie) netinst installation
* **No desktop environment:** Do NOT select any desktop environment during the base installation. Pre-installed desktop packages and recommended extras will make the system heavy and slow.
* **Internet connection:** Required during installation (`setup.sh` downloads packages)
* **Privileges:** `setup.sh` must be run as root (see [Get sudo privileges](#1-get-sudo-privileges))
* **Boot mode:** UEFI and Legacy BIOS are both supported by the base installer
* **Installation media:** A USB drive for the Debian netinst image

### Minimum

* **CPU:** 64-bit Dual-Core 1.5 GHz+ (e.g., Intel Core i3-2310M)
* **GPU:** Any GPU supporting 1024x768 resolution
* **RAM:** 1 GB (idle usage is around 430 MB)
* **Storage:** 15 GB available space (a fresh installation uses about 6.5 GB; additional applications, updates, and cache will increase this)

### Recommended

* **CPU:** 64-bit Dual-Core 2.0 GHz+ (e.g., Intel Core i5-4300U)
* **GPU:** Integrated or dedicated GPU with OpenGL 3.3+ support
* **RAM:** 2 GB (4 GB or more for comfortable multitasking and web browsing)
* **Storage:** 40 GB available space (SSD strongly recommended)
* **Display:** 1366x768 or higher

### Tested On

* **Physical:** Lenovo ThinkPad X250 (Intel Core i5-5300U, Intel HD Graphics 5500, 8 GB DDR3L, 250 GB SSD)
* **Physical:** Intel Pentium B970, NVIDIA GeForce GT 630M (Nouveau driver), 4 GB DDR3 1333 MHz, 500 GB SATA hard drive
* **Virtual machine:** 1 GB RAM, 1 core / 1 thread, runs smoothly

---

## Project Status

SatellaOS is currently developed and maintained by a single developer.

Although development may progress at a different pace compared to larger projects, this allows the project to stay focused on its core goals.

---

## Philosophy

SatellaOS is **not** about providing the largest number of features.

Its goal is to give users as much control over their system as possible.

The project's core principles are:

- Lightweight Design
- User Freedom
- Simplicity
- Modern Appearance

SatellaOS aims to stay out of the user's way and allow them to build the system they actually want.

---

## Stable Release

This repository contains **experimental testing builds**.

For the stable and recommended version of SatellaOS, please visit:

**https://github.com/satellaos-official/satellaos-debian-edition-xfce-stable-x86_64**

---

## License

This project is licensed under the **MIT License**.

You are free to use, modify, distribute, and redistribute the software, provided that the original copyright notice and license text are included.

For more information, please see the `LICENSE` file included in this repository.