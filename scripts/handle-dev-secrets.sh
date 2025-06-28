#!/bin/bash

cp key.txt rendered-template/llm_in_a_box/
cd rendered-template/llm_in_a_box
make secrets-decrypt
cd ../../