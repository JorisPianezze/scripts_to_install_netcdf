#!/bin/bash

# ###################################
#          J. Pianezze
#          (27.10.2023)
#         ~~~~~~~~~~~~~~
#   Download AEC, HDF5 and NETCDF
#           librairies
#         ~~~~~~~~~~~~~~
# ###################################

export version_libaec='1.1.2'
export version_hdf5='1.14.2'
export version_netcdf_c='4.9.0'
export version_netcdf_fortran='4.6.1'

# version_netcdf_c='4.9.2': pblme with curl, xml2

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download libaec-${version_libaec}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ ! -e libaec-${version_libaec}.tar.gz ]]
then
  wget --no-check-certificate https://github.com/MathisRosenhauer/libaec/releases/download/v${version_libaec}/libaec-${version_libaec}.tar.gz
else
  echo 'libaec-'${version_libaec}' already downloaded'
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download hdf5-${version_hdf5}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ ! -e hdf5-${version_hdf5}.tar.gz ]]
then
  wget --no-check-certificate https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${version_hdf5:0:4}/hdf5-${version_hdf5}/src/hdf5-${version_hdf5}.tar.gz
else
  echo 'hdf5-'${version_hdf5}' already downloaded'
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download netcdf-c-${version_netcdf_c}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ ! -e v${version_netcdf_c}.tar.gz ]]
then
  wget --no-check-certificate https://github.com/Unidata/netcdf-c/archive/refs/tags/v${version_netcdf_c}.tar.gz
else
  echo 'netcdf-c-'${version_netcdf_c}' already downloaded'
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Download netcdf-fortran-${version_netcdf_fortran}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if [[ ! -e v${version_netcdf_fortran}.tar.gz ]]
then
  wget --no-check-certificate https://github.com/Unidata/netcdf-fortran/archive/refs/tags/v${version_netcdf_fortran}.tar.gz
else
  echo 'netcdf-fortran-'${version_netcdf_fortran}' already downloaded'
fi
