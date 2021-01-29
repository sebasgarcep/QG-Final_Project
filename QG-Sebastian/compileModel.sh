#Variables specification
export MODEL=" ReadWriteNETCDF.f90 utils.f90 parameters.f90 calc.f90 helmholtz.f90 qgflux.f90 qgstep.f90 qg.f90"
export FLAGS=" -static "
export LIBS=" -I/usr/local/include -L/usr/local/lib -lnetcdff -L/usr/local/lib -lnetcdf"


#Remove already compiled models
rm *.mod

#Compilation of the model QGmodel is the executable
gfortran $FLAGS $MODEL -o QGmodel $LIBS
