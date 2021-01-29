MODULE ReadWriteNETCDF
    
        USE netcdf    
        !Read the background (initial condition) from a NETCDF file
        !The domain is a square
            
        IMPLICIT NONE
        
        CONTAINS 
        
        SUBROUTINE readNETCDF(Q,N)
        
        INTEGER, INTENT(IN)::N
        DOUBLE PRECISION, INTENT(INOUT)::Q(N,N)
        character (len = *), parameter :: FILE_NAME = "QG.nc"
        INTEGER::stat,ncid,varid

        !The vorticity is read on Q
        stat = nf90_open(FILE_NAME, NF90_NOWRITE, ncid)

        PRINT *, trim(nf90_strerror(stat))
        
        stat = nf90_inq_varid(ncid, "VOR", varid) 

        PRINT *, trim(nf90_strerror(stat))

        stat = nf90_get_var(ncid, varid, Q) 

        PRINT *, trim(nf90_strerror(stat))

        END SUBROUTINE

        !Read the background (output analysis) to a NETCDF file
        SUBROUTINE writeNETCDF(Q,N)
       
        INTEGER, INTENT(IN)::N
        DOUBLE PRECISION, INTENT(IN)::Q(N,N)
        INTEGER::stat,ncid,varid,xid,yid
        INTEGER, PARAMETER::NDIM = 2
        INTEGER::dids(NDIM)
        character (len = *), parameter :: FILE_NAME = "QG_out.nc"

        stat = nf90_create(FILE_NAME, NF90_CLOBBER, ncid) 

	! Define the dimensions. NetCDF will hand back an ID for each. 
        stat =  nf90_def_dim(ncid, "x", N, xid) 
        stat =  nf90_def_dim(ncid, "y", N, yid) 

	! The dimids array is used to pass the IDs of the dimensions of
	! the variables. Note that in fortran arrays are stored in
	! column-major format.
        dids =  (/ yid, xid /)
	! Define the variable. The type of the variable in this case is
  	! NF90_INT (4-byte integer).
        stat = nf90_def_var(ncid, "VOR", NF90_DOUBLE, dids, varid) 
  	! End define mode. This tells netCDF we are done defining metadata.
        stat =  nf90_enddef(ncid)
        stat = nf90_put_var(ncid, varid, Q)
        stat = nf90_close(ncid)  

        END SUBROUTINE
END MODULE
