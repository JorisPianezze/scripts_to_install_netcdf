#!/bin/bash
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#SBATCH --job-name=compile
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH -o netcdf.eo%j
#SBATCH -e netcdf.eo%j
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ###################################
#          J. Pianezze
#          (27.10.2023)
#         ~~~~~~~~~~~~~~
#   Install AEC, HDF5 and NETCDF
#     librairies with sbatch
#         ~~~~~~~~~~~~~~
# ###################################

export version_libaec='1.1.2'
export version_hdf5='1.14.2'
export version_netcdf_c='4.9.0'
export version_netcdf_fortran='4.6.1'

# version_netcdf_c='4.9.2': pblme with curl, xml2

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Config for belenos
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module purge &> /dev/null
module load gcc/9.2.0 intel/2018.5.274 openmpi/intel/4.0.2.2 &> /dev/null
export OMPI_CC=icc
export OMPI_CXX=icpc
export OMPI_FC=ifort
export OMPI_F77=ifort
export OMPI_F90=ifort
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export dir_to_install=${PWD}/build_icc-2018.5.274_ompi-4.0.2.2

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
            CC="mpicc" CFLAGS="-fPIC"
make -j 8
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
./configure --enable-fortran \
            --disable-shared \
            --enable-parallel \
            --prefix=${dir_to_install} \
            --libdir=${dir_to_install}/lib \
            --with-szlib=${dir_to_install}/include,${dir_to_install}/lib \
            CC="mpicc" CFLAGS="-fPIC" FC="mpifort" FCFLAGS="-fPIC" \
            LDFLAGS="-L${dir_to_install}/lib" LIBS="-lsz -laec -lz"
make -j 8
make install
make clean

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-c-${version_netcdf_c}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ${dir_to_install}/..
if [[ ! -d netcdf-c-${version_netcdf_c} ]]
then
  if [[ ! -e v${version_netcdf_c}.tar.gz ]]
  then
    echo 'You need to download netcdf-c-'${version_netcdf_c}'.tar.gz'
    echo 'stop'
    exit
  else
    tar xvfz v${version_netcdf_c}.tar.gz
  fi
fi

cd ${dir_to_install}/../netcdf-c-${version_netcdf_c}
./configure --disable-shared \
            --prefix=${dir_to_install} \
            --libdir=${dir_to_install}/lib \
            CC="mpicc" CFLAGS="-fPIC" \
            CPPFLAGS="-I${dir_to_install}/include" \
            LDFLAGS="-L${dir_to_install}/lib" \
            LIBS="-lhdf5_hl -lhdf5 -lsz -laec -lz -ldl"
make -j 8
make install
make clean

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#   Install netcdf-fortran-${version_netcdf_fortran}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ${dir_to_install}/..
if [[ ! -d netcdf-fortran-${version_netcdf_fortran} ]]
then
  if [[ ! -e v${version_netcdf_fortran}.tar.gz ]]
  then
    echo 'You need to download netcdf-fortran-'${version_netcdf_fortran}'.tar.gz'
    echo 'stop'
    exit
  else
    tar xvfz v${version_netcdf_fortran}.tar.gz
  fi
fi

cd ${dir_to_install}/../netcdf-fortran-${version_netcdf_fortran}
./configure --disable-shared \
            --prefix=${dir_to_install} \
            --libdir=${dir_to_install}/lib \
            CC="mpicc" CFLAGS="-fPIC" FC="mpifort" FCFLAGS="-fPIC" FFLAGS="-fPIC"  \
            CPPFLAGS="-I${dir_to_install}/include" \
            LDFLAGS="-L${dir_to_install}/lib" \
            LIBS="-lnetcdf -lhdf5_hl -lhdf5 -lsz -laec -lz -ldl"
make -j 8
make install
make clean
