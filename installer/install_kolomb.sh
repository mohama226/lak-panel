#!/bin/bash


BASE="/opt/lak-panel"


source $BASE/installer/functions.sh



title "Installing Kolomb Script"



mkdir -p $BASE/kolomb



cat > $BASE/kolomb/README.txt <<EOF

Kolomb Script Placeholder

Install your kolomb scripts here.

Path:

$BASE/kolomb

EOF



success "Kolomb installed"
