#!/bin/bash
set -eu

function usage(){ echo "Usage: $(basename $0) <build|push>" && exit 1; }
[ $# -lt 1 ] && usage;

realpath() { [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"; }
SCRIPT_DIR=`dirname $(realpath $0)` # without ending /

repo=dodopizza/nginx-config-generator
tag=$(cd "${SCRIPT_DIR}"; git branch | sed -n '/\* /s///p')

action=${1:-'build'}

echo "[~] Tag '${tag}'"

case "${action}" in
    build )
            cd "${SCRIPT_DIR}"
            docker build --rm -f "Dockerfile" -t ${repo}:${tag} .
            ;;
    push  )
            docker push ${repo}:${tag}
            ;;
    *     )
            usage
            ;;
esac

echo "[.] All Done"