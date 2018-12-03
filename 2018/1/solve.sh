#!/bin/bash

(tr -d '\n' < input.txt; echo ) | bc
