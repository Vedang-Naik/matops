@echo off
nvcc -c matops.cu -Wno-deprecated-gpu-targets
nvcc -c tester.c -Wno-deprecated-gpu-targets
nvcc tester.obj matops.obj -Wno-deprecated-gpu-targets
a