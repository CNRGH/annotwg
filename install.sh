#!/usr/bin/env bash

err_report() {
  echo "Error on ${BASH_SOURCE[0]} line $1" >&2
  exit 1
}

trap 'err_report $LINENO' ERR
set -eo pipefail

declare NAME
NAME="$(basename "$0")"
readonly NAME


display_usage(){
  echo "
USAGE:
${NAME} [options]
  -p, --prefix          Set prefix directory to install annotwg. Default: /usr/local
  -d, --destdir         Set destdir directory for a staged build. Default: ''
      --home-install    User installation in ${HOME}/.local (Incompatible with --prefix and --destdir options)
  -h, --help            Print this help message

DECRIPTION
${NAME} is for the installation of AnnotWG.

"
}


install_annotwg(){
  local script
  for script in bin/*; do
    install -m755 "${script}" "${destdir}/${prefix}/bin"
  done
  #cp -r share "${destdir}/${prefix}"
}


main(){
  local prefix='/usr/local'
  local destdir
  if (( $# == 0 )); then
    echo 'Error any parameters provided!' 1>&2
    display_usage
    exit 1
  fi
  while (( $# > 0 )); do
    case "$1" in
      --home-install)
        prefix="${HOME}/.local";;
      -p|--prefix) prefix="$2"; shift ;;
      -d|--destdir) destdir=$(readlink -m "$2"); shift ;;
      -h|--help) display_usage; exit 0;;
      *)
        echo 'Error unknown parameter: '"$1" 1>&2
        display_usage
        exit 1 ;;
    esac
    shift
  done
  for dir_system in bin; do
    if [[ ! -d "${destdir}/${prefix}/${dir_system}" ]]; then
      mkdir -p "${destdir}/${prefix}/${dir_system}"
    fi
  done
  #export CFLAGS+='-O3  -g -Wall -Wformat-security -Wp,-D_GLIBCXX_ASSERTIONS -fPIC -fexceptions -fstack-protector-strong -grecord-gcc-switches -fasynchronous-unwind-tables'
  #export LD_LIBRARY_PATH="${destdir}/${prefix}/lib64/:${LD_LIBRARY_PATH}"
  export PATH="${destdir}/${prefix}/bin:${PATH}"
  echo   '======================      Build and install AnnotWG      ======================'
  install_annotwg
  if [[ -n ${destdir} ]]; then
    echo '======================           File Hierarchy            ======================'
    tree "${destdir}";
  fi
  echo   '======================        Environment variables        ======================'
  #echo -e "\tLD_LIBRARY_PATH: ${prefix}/lib64/"
  echo -e "\tPATH: ${prefix}/bin"
}


main "$@"

