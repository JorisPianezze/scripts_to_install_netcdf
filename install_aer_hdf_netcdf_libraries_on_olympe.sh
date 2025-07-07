#!/bin/bash

# ###################################
#           J. Pianezze
#          (01.04.2024)
#         ~~~~~~~~~~~~~~
#   Install AEC, HDF5 and NETCDF
#     librairies on Olympe
#         ~~~~~~~~~~~~~~
# ###################################

source /users/p20024/p20024pj/models_IANOS/env_cpl_mnh551_ww3_croco_oa5.sh

export version_libaec='1.1.2'
export version_hdf5='1.14.2'
export version_netcdf_c='4.9.2'
export version_netcdf_fortran='4.6.1'

export dir_to_install=${PWD}/build_netcdf-${version_netcdf_fortran}

if [[ -d "$dir_to_install" ]]
then
  echo "$dir_to_install directory exists."
else
  mkdir $dir_to_install
fi

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install libaec-${version_libaec}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ${dir_to_install}/..
if [[ ! -d libaec-${version_libaec} ]]
then
  if [[ ! -e libaec-${version_libaec}.tar.gz ]]
  then
    echo 'You need to download libaec-'${version_libaec}'.tar.gz'
    echo 'stop'
    exit
  else
    tar xvfz libaec-${version_libaec}.tar.gz
  fi
fi

cd ${dir_to_install}/../libaec-${version_libaec}
./configure --disable-shared               \
            --prefix=${dir_to_install}     \
            --libdir=${dir_to_install}/lib \
            CC="cc" CFLAGS="-fPIC"
make
make install
make clean

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install hdf5-${version_hdf5}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ${dir_to_install}/..
if [[ ! -d hdf5-${version_hdf5} ]]
then
  if [[ ! -e hdf5-${version_hdf5}.tar.gz ]]
  then
    echo 'You need to download hdf5-'${version_hdf5}'.tar.gz'
    echo 'stop'
    exit
  else
    tar xvfz hdf5-${version_hdf5}.tar.gz
  fi
fi

cd ${dir_to_install}/../hdf5-${version_hdf5}
./configure --enable-fortran                                             \
            --disable-shared                                             \
            --prefix=${dir_to_install}                                   \
            --libdir=${dir_to_install}/lib                               \
            --with-szlib=${dir_to_install}/include,${dir_to_install}/lib \
            CC="cc" CFLAGS="-fPIC"                                       \
	    FC="ifort" FCFLAGS="-fPIC"                                   \
            LDFLAGS="-L${dir_to_install}/lib" LIBS="-lsz -laec -lz"
make
make install
make clean

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-c-${version_netcdf_c}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ${dir_to_install}/..
if [[ ! -d netcdf-c-${version_netcdf_c} ]]
then
  if [[ ! -e netcdf-c-${version_netcdf_c}.tar.gz ]]
  then
    echo 'You need to download netcdf-c-'${version_netcdf_c}'.tar.gz'
    echo 'stop'
    exit
  else
    tar xvfz netcdf-c-${version_netcdf_c}.tar.gz
  fi
fi

cd ${dir_to_install}/../netcdf-c-${version_netcdf_c}
./configure --disable-shared \
            --prefix=${dir_to_install} \
            --libdir=${dir_to_install}/lib \
            --disable-dap --disable-libxml2 --disable-byterange \
            CC="cc" CFLAGS="-fPIC"                              \
            CPPFLAGS="-I${dir_to_install}/include"  \
            LDFLAGS="-L${dir_to_install}/lib" \
            LIBS="-lhdf5_hl -lhdf5 -lsz -laec -lz -ldl"
make
make install
make clean

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-fortran-${version_netcdf_fortran}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ${dir_to_install}/..
if [[ ! -d netcdf-fortran-${version_netcdf_fortran} ]]
then
  if [[ ! -e netcdf-fortran-${version_netcdf_fortran}.tar.gz ]]
  then
    echo 'You need to download netcdf-fortran-'${version_netcdf_fortran}'.tar.gz'
    echo 'stop'
    exit
  else
    tar xvfz netcdf-fortran-${version_netcdf_fortran}.tar.gz
  fi
fi

cd ${dir_to_install}/../netcdf-fortran-${version_netcdf_fortran}
./configure --disable-shared \
            --prefix=${dir_to_install} \
            --libdir=${dir_to_install}/lib \
            CC="cc" CFLAGS="-fPIC" \
	    FC="ifort" FCFLAGS="-fPIC" FFLAGS="-fPIC"  \
            CPPFLAGS="-I${dir_to_install}/include" \
            LDFLAGS="-L${dir_to_install}/lib" \
            LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lsz -laec -lz -ldl"
make
make install
make clean
