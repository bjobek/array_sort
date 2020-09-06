@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Sun Sep 06 09:13:14 +0200 2020
REM SW Build 2960000 on Wed Aug  5 22:57:20 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 55c9f3813b2342b8b7e66549125deb3d --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot ram_tb_behav xil_defaultlib.ram_tb -log elaborate.log"
call xelab  -wto 55c9f3813b2342b8b7e66549125deb3d --incr --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot ram_tb_behav xil_defaultlib.ram_tb -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
