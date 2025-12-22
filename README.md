# Lenovo Wi-Fi Whitelist Remover
### For ThinkPad T440p, W540, and T540 only  
Remove Lenovo’s restrictive Wi-Fi whitelist and unlock full Wi-Fi card compatibility.

---

## What This Script Does

- Patches your dumped BIOS to remove the Wi-Fi whitelist
- Signs the modified BIOS using ThinkPad RSA keys
- Flashes the patched BIOS back using CH341A + SOIC8 clip
- Provides a **Restore Option** in case of failure

---

## WARNING (Read This Carefully)

> **This tool flashes your BIOS externally. A failed flash can brick your system if you do not follow instructions.**  
> - Only use this on **T440p**, **W540**, or **T540**
> - **Always unplug the USB programmer before clipping/unclipping the SOIC8**
> - **Remove the yellow coin-cell CMOS battery** before flashing

---

## Required Tools

- CH341A USB SPI Programmer (Black/Gold preferred)
- SOIC8 Clip (for external BIOS access)
- Linux system (tested on Ubuntu/Kali)

---

## Menu Options (Script Workflow)

When you run the script, you'll see this menu:

1. Patch, Sign, and Flash BIOS (Whitelist Removed)
2. Restore Original BIOS (bios1.img)
3. Exit


---

## Download Dependencies

- [UEFIPatch 0.28.0 Linux x86_64](https://github.com/LongSoft/UEFITool/releases/download/0.28.0/UEFIPatch_0.28.0_linux_x86_64.zip)
- [thinkpad-uefi-sign](https://github.com/thrimbor/thinkpad-uefi-sign)

Both are automatically handled by the script.

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

## 🚀 Stay Updated

Follow github.com/SoCalIT for more hardware unlock tools and BIOS utilities.
