!! Copyright (C) 2008 Pavel Sakov
!! 
!! This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
!! LICENSE for details.

! File:           qg.f90
!
! Created:        24/05/2007
!
! Last modified:  08/02/2008
!
! Author:         Pavel Sakov
!                 CSIRO Marine and Atmospheric Research
!                 NERSC
! 
! Purpose:        Runs QG model.
!
! History:        24 May 2007: Downloaded the original code from 
!                 http://www.seas.harvard.edu/climate/eli/Downloads/QG200205011455.tar.gz
!
! Description:   The solved equation represents ocean circulation driven by a
!                specified wind stress, showing in a time average two gyres
!                with a "Gulf Stream" on the left side of the domain:
!      
!\documentclass[intlimits,fleqn, 12pt]{article}
!\usepackage{amsmath}
!\newcommand{\mb} {\mathbf}
!\begin{document}
!\begin{align*}
!  q_t = - \psi_x - r J(\psi, q) - rkb \zeta + rkh \nabla^2 \zeta 
!  - rkh2 \nabla^4 \zeta + 2 \pi \sin(2\pi y),
!\end{align*}
!where
!\begin{align*}
!  &q = \zeta - F \psi \ & &\text{is the potential vorticity},\\
!  &\zeta = \nabla^2 \psi & &\text{-- the relative corticity},\\
!  &J(q, \psi) = q_x \psi_y - q_y \psi_x,\\
!  &r & &\text{-- a multiple for the nonlinear advection term,}\\
!  &&& \text{\ \ "sort of Rossby number"},\\
!  &rkb & &\text{-- bottom friction},\\
!  &rkh & &\text{-- horizontal friction},\\
!  &rkh2 & &\text{-- biharmonic horizontal friction},\\
!  &F & &\text{-- Froud number}.
!\end{align*}
!\end{document}

program qg

  use parameters_mod
  use qgstep_mod
  use ReadWriteNETCDF

  implicit none

  character(STRLEN) :: prmfname,nstepss
!  character (len = *), parameter :: prmfname = "prm.txt"
  real(8), dimension(N, M) :: Q, PSI, PSIGUESS
  real(8) :: t
  real(8) :: qmax
  integer :: nstep, step

  call getarg(1, prmfname)
  call getarg(2, nstepss)

  call parameters_read(prmfname)

   print *, 'starting the model:'
   print *, '  N x M =', N, 'x', M

  read(nstepss,*) nstep

  !Read the NC file holding the initial condition (PSI)

  call readNETCDF(PSI,N)
  call laplacian(PSI, dx, dy, Q)
  Q = Q - F * PSI

  PSIGUESS = PSI
  ! main cycle
  !
  do step = 1, nstep

     qmax = maxval(Q)
     if (qmax > 1.0e+20) then
        print *, '  qg: error: qmax > 1.0e+20 at t =', t
        stop
     end if

  call qg_step_rk4(t, PSIGUESS, Q)

  end do

  call calc_psi(PSIGUESS, Q, PSI)
  call writeNETCDF(PSI,N)
  !Write the NC file (PSI)

end program qg
