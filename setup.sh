#!/bin/bash
cd src
# This first run is just in case the data folder doesn't get generated fast, therefore we have a pre-runtime generation
./serv.sh
./serv.sh setup