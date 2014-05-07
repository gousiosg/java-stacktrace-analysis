#!/usr/bin/env bash

mkdir -p repo

cat repos.txt|
cut -f5,6 -d'/'|
while read repo; do
  repout=`echo $repo|tr '/' '@'`
  git clone https://github.com/$repo.git repos/$repout
  java -cp metrics.jar br.ufrn.exminer.sourcecode.metrics.CalculateEHMetrics repos/$repout $repout-result.txt
done
