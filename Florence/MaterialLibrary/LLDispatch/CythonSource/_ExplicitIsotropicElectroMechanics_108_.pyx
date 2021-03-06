#cython: profile=False
#cython: infer_types=True
#cython: boundscheck=False
#cython: wraparound=False
#cython: nonecheck=False

import numpy as np
cimport numpy as np

ctypedef double Real


cdef extern from "_ExplicitIsotropicElectroMechanics_108_.h" nogil:
    cdef cppclass _ExplicitIsotropicElectroMechanics_108_[Real]:
        _ExplicitIsotropicElectroMechanics_108_() except +
        _ExplicitIsotropicElectroMechanics_108_(Real mu1, Real mu2, Real lamb, Real eps_2) except +
        void SetParameters(Real mu1, Real mu2, Real lamb, Real eps_2) except +
        void KineticMeasures(Real *Dnp, Real *Snp, int ndim, int ngauss, const Real *Fnp, const Real *Enp) except +



def KineticMeasures(material, np.ndarray[Real, ndim=3, mode='c'] F, np.ndarray[Real, ndim=2] E):

    cdef int ndim = F.shape[2]
    cdef int ngauss = F.shape[0]
    cdef np.ndarray[Real, ndim=3, mode='c'] D, stress

    D = np.zeros((ngauss,ndim,1),dtype=np.float64)
    stress = np.zeros((ngauss,ndim,ndim),dtype=np.float64)

    cdef _ExplicitIsotropicElectroMechanics_108_[Real] mat_obj = _ExplicitIsotropicElectroMechanics_108_()
    mat_obj.SetParameters(material.mu1,material.mu2,material.lamb,material.eps_2)
    mat_obj.KineticMeasures(&D[0,0,0], &stress[0,0,0], ndim, ngauss, &F[0,0,0], &E[0,0])

    return D, stress