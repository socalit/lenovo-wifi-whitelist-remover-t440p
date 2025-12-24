#!/bin/bash

# ========================================================================
# ███████╗ ██████╗  ██████╗ █████╗ ██╗     ██╗████████╗
# ██╔════╝██╔═══██╗██╔════╝██╔══██╗██║     ██║╚══██╔══╝
# ███████╗██║   ██║██║     ███████║██║     ██║   ██║
# ╚════██║██║   ██║██║     ██╔══██║██║     ██║   ██║
# ███████║╚██████╔╝╚██████╗██║  ██║███████╗██║   ██║
# ╚══════╝ ╚═════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚═╝   ╚═╝
#
# ThinkPad xx40 BIOS Tool (Patch / Restore)
# Author: SoCal IT | https://github.com/socalit
# Based on Wolfgang's guide: https://notthebe.ee/blog/removing-the-wifi-whitelist/
# ========================================================================

set -e
set -u

# ========= CONFIG =========
WORKDIR="$HOME/thinkpad_flash"
VENV_DIR="$WORKDIR/venv"
PATCH_FILE="xx40_patches_v5.txt"
BACKUP_BIOS="bios1.img"
PATCHED_BIOS="bios_patched.img"
CHIP_MODEL="W25Q32FV"  # Change if your BIOS chip is different

UEFIPATCH_VERSION="0.28.0"
UEFIPATCH_ZIP="UEFIPatch_${UEFIPATCH_VERSION}_linux_x86_64.zip"
UEFIPATCH_URL="https://github.com/LongSoft/UEFITool/releases/download/${UEFIPATCH_VERSION}/${UEFIPATCH_ZIP}"
UEFIPATCH_BIN="$WORKDIR/UEFIPatch"

SIGN_REPO="https://github.com/thrimbor/thinkpad-uefi-sign.git"
SIGN_DIR="$WORKDIR/thinkpad-uefi-sign"
SIGN_TOOL="$SIGN_DIR/sign.py"
VERIFY_TOOL="$SIGN_DIR/verify.py"

# ========= MENU =========
clear
echo "======================================================"
echo "   SoCal IT - ThinkPad BIOS Patch Tool (xx40) v1.2   "
echo "======================================================"
echo "1. Patch, Sign, and Flash Modded BIOS"
echo "2. Restore Original BIOS (bios1.img)"
echo "3. Exit"
echo "======================================================"
read -p "Select an option [1-3]: " CHOICE

# ========= COMMON SETUP =========
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[*] Installing dependencies..."
sudo apt update
sudo apt install -y flashrom git python3 python3-venv unzip curl

# ========= PYTHON VENV =========
if [ ! -d "$VENV_DIR" ]; then
  echo "[*] Creating isolated Python virtual environment..."
  python3 -m venv "$VENV_DIR"
fi

echo "[*] Installing Python dependencies inside venv..."
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install pycryptodome

# ========= DOWNLOAD UEFIPatch =========
if [ ! -f "$UEFIPATCH_BIN" ]; then
  echo "[*] Downloading UEFIPatch v${UEFIPATCH_VERSION}..."
  TMPDIR=$(mktemp -d)
  curl -L "$UEFIPATCH_URL" -o "$TMPDIR/$UEFIPATCH_ZIP"
  unzip "$TMPDIR/$UEFIPATCH_ZIP" -d "$TMPDIR"
  chmod +x "$TMPDIR/UEFIPatch"
  mv "$TMPDIR/UEFIPatch" "$UEFIPATCH_BIN"
  rm -rf "$TMPDIR"
fi

# ========= CLONE SIGNING TOOL =========
if [ ! -d "$SIGN_DIR" ]; then
  echo "[*] Cloning thinkpad-uefi-sign..."
  git clone "$SIGN_REPO" "$SIGN_DIR"
fi

# ========= OPTION 1: PATCH & FLASH =========
if [[ "$CHOICE" == "1" ]]; then

  echo "[*] Writing patch file..."
  cat <<'EOF' > "$PATCH_FILE"
# T440p / T540 / W540 Wi-Fi whitelist removal
79E0EDD7-9D1D-4F41-AE1A-F896169E5216 10 P:0bc841390b0f8468010000:0bc841390be96901000000
79E0EDD7-9D1D-4F41-AE1A-F896169E5216 10 P:41390b7517:41390b7500
79E0EDD7-9D1D-4F41-AE1A-F896169E5216 10 P:41394b04741b:41394b04eb1b

# Enable advanced BIOS menu
32442D09-1D11-4E27-8AAB-90FE6ACB0489 10 P:04320B483CC2E14ABB16A73FADDA475F:778B1D826D24964E8E103467D56AB1BA
EOF

  echo
  echo "======================================================"
  echo " HARDWARE SAFETY CHECK"
  echo " - REMOVE laptop battery"
  echo " - REMOVE CMOS coin-cell battery"
  echo " - ATTACH SOIC8 clip FIRST"
  echo " - THEN plug in CH341A"
  echo "======================================================"
  read -p "Press Enter to continue..."

  echo "[*] Dumping BIOS..."
  sudo flashrom -p ch341a_spi -c "$CHIP_MODEL" -r bios1.img
  sudo flashrom -p ch341a_spi -c "$CHIP_MODEL" -r bios2.img

  echo "[*] Verifying dump..."
  if diff bios1.img bios2.img >/dev/null; then
    rm -f bios2.img
    echo "[+] BIOS dump verified."
  else
    echo "[ERROR] BIOS dumps differ. Reseat clip and retry."
    exit 1
  fi

  echo "[*] Patching BIOS..."
  "$UEFIPATCH_BIN" bios1.img "$PATCH_FILE" -o "$PATCHED_BIOS"

  echo "[*] Signing BIOS..."
  "$VENV_DIR/bin/python" "$SIGN_TOOL" "$PATCHED_BIOS" -o "$PATCHED_BIOS"
  "$VENV_DIR/bin/python" "$VERIFY_TOOL" "$PATCHED_BIOS"

  echo
  echo "======================================================"
  echo " READY TO FLASH PATCHED BIOS"
  echo "======================================================"
  read -p "Plug CH341A back in and press Enter to flash..."

  sudo flashrom -p ch341a_spi -c "$CHIP_MODEL" -w "$PATCHED_BIOS"

  echo
  echo "SUCCESS!"
  echo " - Reconnect CMOS battery"
  echo " - Reinstall main battery"
  echo " - Power on and press F1"
  echo " - Wi-Fi whitelist removed"
  exit 0
fi

# ========= OPTION 2: RESTORE BIOS =========
if [[ "$CHOICE" == "2" ]]; then

  if [ ! -f "$BACKUP_BIOS" ]; then
    echo "[ERROR] bios1.img not found!"
    exit 1
  fi

  echo
  echo "======================================================"
  echo " RESTORE ORIGINAL BIOS"
  echo "======================================================"
  read -p "Type YES to continue: " CONFIRM
  [[ "$CONFIRM" == "YES" ]] || exit 0

  echo "Remove batteries and unplug USB before attaching clip."
  read -p "Attach clip and plug in CH341A. Press Enter to restore..."

  sudo flashrom -p ch341a_spi -c "$CHIP_MODEL" -w "$BACKUP_BIOS"

  echo "Original BIOS restored. Reassemble and reboot."
  exit 0
fi

echo "Exiting..."
exit 0
