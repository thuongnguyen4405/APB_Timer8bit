#!/usr/bin/env bash
# Example environment helper. QuestaSim must already be available in PATH.
if ! command -v vsim >/dev/null 2>&1; then
    echo 'QuestaSim not found in PATH. Load the EDA environment on your server.'
else
    echo "QuestaSim found: $(command -v vsim)"
fi
