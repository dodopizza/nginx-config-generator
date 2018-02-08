#!/bin/sh
set -e
BUILD_DIR="/data/_build"

echo "[!] $(python --version)"
echo "[!] Jinja2 $(pip show Jinja2 | grep Version)"

[[ ! -f "data.yml" ]] && echo "[E] No data.yml file presented." && echo '[!] Try to run container with mount option, eg: docker run --rm -v "$(pwd)":/data docker-jinja2' && exit 1;

echo "[~] Cleanup _build directory"
rm -rf "${BUILD_DIR}" 2> /dev/null || true

for template in $( cd /data/ && find . -name '*.build.j2' | grep -v "./_build" ) ; do
    echo "[~] Generating ${template} to ${template%.build.j2}.conf"
    install -d $( dirname "${BUILD_DIR}/${template%.build.j2}.conf" )
    python /pj.py "${template}" > "${BUILD_DIR}/${template%.build.j2}.conf"
done

for extra_file in $( cd /data/ && find . -name '*.conf' | grep -v "./_build" ) ; do
    echo "[~] Copying ${extra_file}"
    install -d $( dirname "${BUILD_DIR}/${extra_file}" )
    cp -f "${extra_file}" "${BUILD_DIR}/${extra_file}"
done

echo "[.] Done"
