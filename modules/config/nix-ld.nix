{ pkgs, ... }:
{
  # nix-ld provides a fake dynamic linker so that unpatched binaries (e.g., downloaded
  # pre-built executables) can run on NixOS without requiring patchelf.
  # Ref: https://qiita.com/syoshika_/items/435a2183265b23bc73fa
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # Required by air (R language formatter) which ships as a pre-built binary
      libgcc
      glibc

      # Required by Chromium downloaded by Playwright (`npx playwright install chromium`)
      alsa-lib
      at-spi2-core
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libdrm
      libgbm
      libxkbcommon
      nspr
      nss
      pango
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
    ];
  };
}
