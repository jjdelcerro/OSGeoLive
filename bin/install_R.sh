#!/bin/sh
#################################################
# 
# Purpose: Installation of R and R-spatial packages
# Author:  Massimo Di Stefano <info@geofemengineering.it>
#
#################################################
# Copyright (c) 2010-2018 Open Source Geospatial Foundation (OSGeo) and others.
# Copyright (c) 2009 GeofemEngineering 
#
# Licensed under the GNU LGPL.
# 
# This library is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 2.1 of the License,
# or any later version.  This library is distributed in the hope that
# it will be useful, but WITHOUT ANY WARRANTY, without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU Lesser General Public License for more details, either
# in the "LICENSE.LGPL.txt" file distributed with this software or at
# web page "http://www.fsf.org/licenses/lgpl.html".
##################################################
#
# About:
# =====
# This script will install : R and spatial packages
#
# Running:
# =======
# sudo ./install_R.sh

./diskspace_probe.sh "`basename $0`" begin
BUILD_DIR=`pwd`
####

if [ -z "$USER_NAME" ] ; then
   USER_NAME="user"
fi
USER_HOME="/home/$USER_NAME"

#Install packages from debs if available
# cp ../sources.list.d/cran.list /etc/apt/sources.list.d/

#new key as of 2/2011, package manager changed
# apt-key adv --keyserver keyserver.ubuntu.com --recv-key E084DAB9

#Apparently subkeys.pgp.net decided to refuse requests from the vm for a few hours
# TODO: if key import fails switch to another keyserver
# pgp.mit.edu keyserver.ubuntu.com

apt-get -q update

#Plugin interaction with R
apt-get --assume-yes install r-base r-recommended

if [ $? -ne 0 ] ; then
   echo 'ERROR: Package install failed! Aborting.'
   exit 1
fi

#Required for QGIS plugins - Switching to apt above
apt-get --assume-yes install python-rpy2 r-cran-rcolorbrewer

# This is replaced with the following line which installs packages from our repository:
# Not yet available for Bionic
# apt-get --assume-yes install r-cran-classint r-cran-dcluster r-cran-deldir\
#  r-cran-geor r-cran-gstat r-cran-maptools r-cran-randomfields r-cran-raster\
#  r-cran-rcolorbrewer r-cran-rgdal r-cran-sp r-cran-spatstat r-cran-spdep\
#  r-cran-splancs r-cran-rgeos r-cran-ncdf4 r-cran-rsaga r-cran-rgrass7

#Calls R script to do install with feedback to stdout
# mkdir -p /usr/local/share/jupyter/kernels
# R --no-save < ../app-conf/R/installRpackages.r
# mv /roots/.local/share/jupyter/kernels/ir /usr/local/share/jupyter/kernels/ir

# add user to the staff group so that they can install system-wide packages
adduser "$USER_NAME" staff

#Add Desktop shortcut
if [ ! -e /usr/share/applications/r.desktop ] ; then
   cat << EOF > /usr/share/applications/r.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=R Statistics
Comment=R Statistical Package
Categories=Application;Education;Geography;
Exec=R
Icon= /usr/share/R/doc/html/logo.jpg
Terminal=true
StartupNotify=false
EOF
else
  echo "Icon already present."
fi

cp -a /usr/share/applications/r.desktop "$USER_HOME/Desktop/"
chown "$USER_NAME.$USER_NAME" "$USER_HOME/Desktop/r.desktop"

#Remove build libraries
# apt-get --assume-yes remove libxml2-dev \
#    tcl8.5-dev tk8.5-dev libgl1-mesa-dev \
#    libglu1-mesa-dev libsprng2-dev
#libgdal-dev libnetcdf-dev libgeos-dev libproj-dev

#cleanup leftovers
# apt-get --assume-yes autoremove


## fix for broken PDFs, fixed in upstream SVN Aug 2011  (bug #769)
# mkdir /tmp/build_R
# cd /tmp/build_R
# wget -N --progress=dot:mega \
#    "http://download.osgeo.org/livedvd/data/R/spgrass6_pdf.zip"
# unzip spgrass6_pdf.zip
# cp *.pdf /usr/lib/R/site-library/spgrass6/doc/


# link sample data to central location
mkdir -p /usr/local/share/data/vector
ln -s /usr/lib/R/site-library/rgdal/vectors \
   /usr/local/share/data/vector/R

####
"$BUILD_DIR"/diskspace_probe.sh "`basename $0`" end
