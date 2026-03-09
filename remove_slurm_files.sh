#!/bin/bash
find . -name "*.out" -type f -print0 | xargs -0 rm
