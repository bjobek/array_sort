#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Wed Sep 09 14:56:20 CEST 2020
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto b4cc3ee3887e48439332261a96738a9b --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot mux_block_tb_behav xil_defaultlib.mux_block_tb -log elaborate.log"
xelab -wto b4cc3ee3887e48439332261a96738a9b --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot mux_block_tb_behav xil_defaultlib.mux_block_tb -log elaborate.log

