#!/bin/bash

set -Eeo pipefail
declare TEST_DIR=""


cleanup(){
  if [[ -d "${TEST_DIR}" && "${TEST_DIR}" != '' ]]; then
    rm -fr "${TEST_DIR}"
  fi
}


err_report(){
  echo "Error on $0 line $1" >&2
  exit 1
}


display_banner(){
  local line=''
  while read -r line; do
    echo -e "$line"
  done < "$SCRIPT_TEST_DIR/banner.ansi"
}


trap 'err_report $LINENO' ERR
trap cleanup INT TERM EXIT

#Starting date
echo -n "Start unit testing: "
date
echo

SCRIPT_TEST_DIR=$(readlink -f "$(dirname "$0")")

#make temporary directory
TEST_DIR=$(mktemp -d 'test_annotwg_XXXX')
TEST_DIR=$(readlink -f "$TEST_DIR")
pushd "${TEST_DIR}"

#logo
display_banner

#symlink to data?? usefull?
#ln -s examples_annotFile.bcf examples_annotFile.bcf
#ln -s examples_toAnnotate_full.vcf.gz examples_toAnnotate_full.vcf.gz
#... or a data_test dir

#display help
annotwg -h

#ability to reanotate the complete annotation set
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -t 2
#diff <(bcftools annotate --no-version -a "${SCRIPT_TEST_DIR}/examples_annotFile.bcf" -c +CG_rate,+CpG_rate,+GERP_N,+GERP_S,+CADD_RawScore,+CADD_PHRED "${SCRIPT_TEST_DIR}/examples_toAnnotate_full.vcf.gz" | grep -v ^#) <(bcftools view -H --no-version "${SCRIPT_TEST_DIR}/examples_annotFile.bcf")

#no parallel
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf"

#very parallel
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -t 10

#test out file
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -t 9 -o test_outfile.vcf.gz

#test relative path
annotwg -v ../tests/examples_toAnnotate_full.vcf.gz -r ../tests/example.fasta -a ../tests/examples_annotFile.bcf -t 8

#custom prefix annotation
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -t 7 -o test_custom_annot.vcf.gz -p cadd_

#tmp dir in /tmp
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -d /tmp -t 6 -o test_tmp.vcf.gz

#in memory tmp
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -d /dev/shm -t 5 -o test_shm.vcf.gz

#ability to annotate InDels
annotwg -v "$SCRIPT_TEST_DIR/examples_toAnnotate_full-2.vcf.gz" -r "$SCRIPT_TEST_DIR/example.fasta" -a "$SCRIPT_TEST_DIR/examples_annotFile.bcf" -t 10 -o test_bigindels.vcf.gz

echo -n "Unit testing completed: "
date
exit 0
