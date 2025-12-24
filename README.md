![Lenovo WiFi Whitelist Remover](assets/banner.png)

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-support-%23FFDD00?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/socal370xs)
[![Lenovo](https://img.shields.io/badge/Lenovo-ThinkPad-red?logo=lenovo&logoColor=white)](https://www.lenovo.com)
[![ThinkPad](https://img.shields.io/badge/Model-T440p-black)](https://psref.lenovo.com)
[![BIOS](https://img.shields.io/badge/BIOS-Modding-orange)](#)
[![Linux](https://img.shields.io/badge/Linux-Supported-yellow?logo=linux)](https://www.kernel.org)
[![License](https://img.shields.io/badge/license-MIT-purple)](/LICENSE)

[![Buy Me a Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-support-%23FFDD00?logo=buymeacoffee&logoColor=black)](https://buymeacoffee.com/socal370xs)

# Lenovo Wi-Fi Whitelist Remover
### For ThinkPad T440p, W540, and T540 only  
Remove Lenovo’s restrictive Wi-Fi whitelist and unlock full Wi-Fi card compatibility.
---
## What This Script Does

- Patches your dumped BIOS to remove the Wi-Fi whitelist
- Signs the modified BIOS using ThinkPad RSA keys
- Flashes the patched BIOS back using CH341A + SOIC8 clip
  - Amazon affiliate link: https://amzn.to/4j7jXC2
- Provides a **Restore Option** in case of failure

---

## ⚠️ WARNING (Read This Carefully)

> **This tool flashes your BIOS externally. A failed flash can brick your system if you do not follow instructions.**  
> - Only use this on **T440p**, **W540**, or **T540**
> - **Always unplug the USB programmer before clipping/unclipping the SOIC8**
> - **Remove batteries including yellow coin-cell CMOS battery**

---

## Required Tools

- CH341A USB SPI Programmer (Black/Gold preferred) + SOIC8 Clip
  - Amazon affiliate link: https://amzn.to/4j7jXC2
  
- Linux system (tested with Ubuntu/Kali on t440p)

---

## 1. Clone this repo
```bash
git clone https://github.com/socalit/lenovo-wifi-whitelist-remover-t440p.git
cd lenovo-wifi-whitelist-remover-t440p
```
## 2. Make the script executable
```bash
chmod +x remove_whitelist.sh
```
## 3. Run the script
```bash
./remove_whitelist.sh
```
---

## Menu Options (Script Workflow)

When you run the script, you'll see this menu:
```
1. Patch, Sign, and Flash BIOS (Whitelist Removed)
2. Restore Original BIOS (bios1.img)
3. Exit
```

---

## Download Dependencies

- [UEFIPatch 0.28.0 Linux x86_64](https://github.com/LongSoft/UEFITool/releases/download/0.28.0/UEFIPatch_0.28.0_linux_x86_64.zip)
- [thinkpad-uefi-sign](https://github.com/thrimbor/thinkpad-uefi-sign)

Both are automatically handled by the script.

## Download Folder: `/home/USER/thinkpad_flash/`
```
├── UEFIPatch               → UEFI patcher binary (v0.28.0)
├── bios1.img               → Verified original BIOS dump
├── bios_patched.img        → Patched + signed BIOS
├── bios2.img               → Second dump for diff check (auto-deleted if match)
├── xx40_patches_v5.txt     → Patch file: whitelist + advanced menu
├── venv/                   → Python venv with pycryptodome
└── thinkpad-uefi-sign/     → Signature tool repo
```
---

---

## Credits

Thanks to the incredible open-source BIOS modding community:
- `LongSoft` – UEFITool and UEFIPatch  
- `thrimbor` – ThinkPad UEFI signing scripts  
- BIOS hacking knowledge shared by dozens of reverse engineers  
- Script packaged by **SoCal IT** (https://github.com/socalit)

---

## Legal

This is for **educational use only**. You are responsible for your own hardware.  
Lenovo® and ThinkPad® are trademarks of Lenovo.

## Support

### ⭐ **Star the GitHub repo**  
### Share it with communities  
### Open issues or request features  

If this project saved you time or solved a problem, consider supporting development:

[![Buy Me a Coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&slug=socal370xs&button_colour=FFDD00&font_colour=000000&font_family=Arial&outline_colour=000000&coffee_colour=ffffff)](https://buymeacoffee.com/socal370xs)
