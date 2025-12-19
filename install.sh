#!/bin/bash

# QuickGrep Installation Script

set -e

echo "🔨 Building QuickGrep..."

if ! command -v gcc &> /dev/null; then
    echo "❌ Error: gcc is not installed. Please install gcc and try again."
    exit 1
fi

./build.sh

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
else
    echo "❌ Build failed."
    exit 1
fi

INSTALL_DIR="$(pwd)"
SHELL_NAME=$(basename "$SHELL")
RC_FILE=""

if [ "$SHELL_NAME" = "zsh" ]; then
    RC_FILE="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
    if [ -f "$HOME/.bash_profile" ]; then
        RC_FILE="$HOME/.bash_profile"
    else
        RC_FILE="$HOME/.bashrc"
    fi
else
    echo "⚠️  Unsupported shell: $SHELL_NAME"
    echo "You need to manually add the following line to your shell configuration:"
    echo "export PATH=\$PATH:$INSTALL_DIR"
    exit 0
fi

# Check if already in PATH/RC_FILE
if grep -q "$INSTALL_DIR" "$RC_FILE"; then
    echo "ℹ️  $INSTALL_DIR is already in $RC_FILE"
else
    echo "📝 Adding $INSTALL_DIR to $RC_FILE..."
    echo "" >> "$RC_FILE"
    echo "# QuickGrep" >> "$RC_FILE"
    echo "export PATH=\$PATH:$INSTALL_DIR" >> "$RC_FILE"
    echo "✅ Added to PATH."
fi

echo ""
echo "🎉 Installation complete!"
echo "Please restart your terminal or run the following command to use 'gg' immediately:"
echo "source $RC_FILE"
