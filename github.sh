#!/bin/bash
git add .
read -p "Description: " desc  
git commit -m "$desc"
git push -u origin master
