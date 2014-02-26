#!/bin/sh
# Kosmo.sh
cd /usr/lib/Kosmo-3.0/bin
KOSMO_LIBS_PATH="../libs"
export PROJ_LIB="./crs/data"

if [ -n "$LD_LIBRARY_PATH" ]; then
	export LD_LIBRARY_PATH=$KOSMO_LIBS_PATH:$LD_LIBRARY_PATH
else
	export LD_LIBRARY_PATH=$KOSMO_LIBS_PATH
fi
java -Djava.library.path=/usr/lib:"../libs" -Dsun.java2d.d3d=false -cp .:./kosmo_desktop.jar:./libs/jai_codec-1.1.3.jar:./libs/jai_core-1.1.3.jar:./jai_imageio-1.1.3.jar -Xmx800M com.vividsolutions.jump.workbench.JUMPWorkbench -plug-in-directory ./ext

