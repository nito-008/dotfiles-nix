{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Lightweight and flexible command-line JSON processor
    jq
    # HTTP/HTTPS download tool
    curl
    # Non-interactive downloader for HTTP, HTTPS, and FTP
    wget
    # Shows all files currently opened by a process (useful for debugging)
    lsof
    # System information tool - modern replacement for neofetch
    fastfetch
    # Interactive process viewer - next-gen replacement for top
    htop
    # Cross-platform resource monitor TUI (CPU, memory, disk, network)
    bottom
    # Modern ls replacement with colors, icons, and Git integration
    eza
    # Fast and user-friendly alternative to find
    fd
    # Syntax-highlighted file viewer - modern replacement for cat
    bat
    # Side-by-side diff viewer with syntax highlighting - modern replacement for diff
    delta
    # Disk partitioning CLI
    parted
    # Disk partitioning GUI
    gparted
    # Archive tools
    zip
    unzip
    rar
    unrar
    # PDF utilities
    poppler-utils # Includes pdftotext for extracting text from PDFs
    tesseract # OCR tool
    tdf
    # Video, Image utility
    ffmpeg
    # Terminal File Manager
    yazi
    # Character encoding and newline code converter (useful for Japanese text files)
    nkf
    # Nix fetcher helper - generates fetchFromGitHub hashes and revs
    # Ref: https://github.com/nix-community/nurl
    nurl
    # Prefetch dependencies from npm
    prefetch-npm-deps
    # Internet connection speed test CLI
    ookla-speedtest
    # Terminal clock
    tty-clock
    # CPU monitoring and stress test TUI
    s-tui
    # Terminal audio spectrum visualizer
    cava
    # Fun / joke commands
    sl # Animated ASCII steam locomotive (anti-typo for `ls`)
    cmatrix # Matrix-style falling characters animation
    cowsay # Mow
    bastet # Tetris clone for the terminal
    lolcat # wao
  ];
}
