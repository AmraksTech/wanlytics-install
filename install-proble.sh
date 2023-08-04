#!/usr/bin/env bash

# Function to detect the OS type
get_os_type() {
  local os_type
  case "$(uname -s)" in
    Linux*)   os_type=linux;;
    Darwin*)  os_type=darwin;;
    CYGWIN*)  os_type=windows;;
    MINGW*)   os_type=windows;;
    *)        os_type=unknown;;
  esac
  echo "$os_type"
}

# Function to detect the architecture
get_architecture() {
  local arch
  case "$(uname -m)" in
    x86_64)  arch=amd64;;
    i686)    arch=386;;
    armv7l)  arch=arm;;
    aarch64) arch=arm64;;
    arm64) arch=arm64;;
    *)       arch=unknown;;
  esac
  echo "$arch"
}

# Function to download and install the binary
install_binary() {
  local os_type=$1
  local arch=$2
  local binary_url="https://installer.wanlytics.io/wanprobe_${os_type}_${arch}"

  echo "Downloading myapp binary for $os_type ($arch)..."
  if command -v curl &>/dev/null; then
    curl -o wanprobe -L "$binary_url"
  elif command -v wget &>/dev/null; then
    wget -O wanprobe "$binary_url"
  else
    echo "Error: Neither 'curl' nor 'wget' found. Please install either of them."
    exit 1
  fi

  chmod +x wanprobe
  echo "Installing probe..."
  sudo mv wanprobe /usr/local/bin wanprobe
  echo "Installation completed successfully!"
}

main() {
  local os_type=$(get_os_type)
  local arch=$(get_architecture)

  if [ "$os_type" = "unknown" ]; then
    echo "Error: Unsupported operating system. Unable to install."
    exit 1
  fi

  if [ "$arch" = "unknown" ]; then
    echo "Error: Unsupported architecture. Unable to install."
    exit 1
  fi

  install_binary "$os_type" "$arch"
}

main
