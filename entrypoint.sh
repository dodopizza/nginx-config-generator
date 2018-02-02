#!/bin/sh
set -e
BUILD_DIR="/data/_build"

[[ ! -f "data.yml" ]] && echo "[E] No data.yml file presented." && echo '[!] Try to run container with mount option, eg: docker run --rm -v "$(pwd)":/data docker-jinja2' && exit 1;

echo "[~] Cleanup _build directory"
rm -rf ${BUILD_DIR}/* &2> /dev/null

for template in $( find . -name '*.build.j2' -not -path "${BUILD_DIR}/*" ) ; do
    echo "[~] Generating ${template} to ${template%.build.j2}.conf"
    install -d $( dirname "${BUILD_DIR}/${template%.build.j2}.conf" )
    python /pj.py "${template}" > "${BUILD_DIR}/${template%.build.j2}.conf"
done

for extra_file in $( find . -name '*.conf' -not -path "${BUILD_DIR}/*" ) ; do
    echo "[~] Copying ${extra_file}"
    install -d $( dirname "${BUILD_DIR}/${extra_file}" )
    cp -f "${extra_file}" "${BUILD_DIR}/${extra_file}"
done
echo "[.] Done"