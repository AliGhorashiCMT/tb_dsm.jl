module TBDSM
#Dependencies
using PyCall, PyPlot, LinearAlgebra, DelimitedFiles, DocStringExtensions

const pb = PyNULL()
const pb_repo = PyNULL()
const pb_graphene = PyNULL()
const pb_mos2 = PyNULL()
const pb_model = PyNULL()
const pb_solver = PyNULL()
const pb_lattice = PyNULL()

const pyintegrate = PyNULL()
const interpol = PyNULL()
export pb, pb_repo, pb_graphene, pb_model, pb_solver, pb_lattice, pb_mos2, pyintegrate, interpol

function __init__()
    copy!(pb, pyimport_conda("pybinding", "pybinding", "conda-forge"))
    copy!(pb_repo, pyimport_conda("pybinding.repository", "pybinding", "conda-forge"))
    copy!(pb_graphene, pyimport_conda("pybinding.repository.graphene", "pybinding", "conda-forge"))
    copy!(pb_mos2, pyimport_conda("pybinding.repository.group6_tmd", "pybinding", "conda-forge").monolayer_3band("MoS2"))
    copy!(pb_model, pb.Model)
    copy!(pb_solver, pb.solver.lapack)
    copy!(pb_lattice, pb.Lattice)
    copy!(pyintegrate, pyimport_conda("scipy.integrate", "scipy"))
    copy!(interpol, pyimport_conda("scipy.interpolate", "scipy"))
    
    #copy!(pb, pyimport("pybinding"))
    #copy!(pb_repo, pyimport("pybinding.repository"))
    #copy!(pb_graphene, pyimport("pybinding.repository.graphene"))
    #copy!(pb_mos2, pyimport("pybinding.repository.group6_tmd").monolayer_3band("MoS2"))
    #copy!(pb_model, pb.Model)
    #copy!(pb_solver, pb.solver.lapack)
    #copy!(pb_lattice, pb.Lattice)
    #copy!(pyintegrate, pyimport("scipy.integrate"))
    #copy!(interpol, pyimport("scipy.interpolate"))
end

include("tb_model.jl")
export make_lattice, plot_bands

include("tb_2d_dielectric.jl")
export impol_2d, realeps_2d

include("tb_3d_dielectric.jl")
export impol_3d, realeps_3d

include("tb_specific_examples.jl")
export graphene_bands, bilayer_graphene_bands, tmd_mo_s2, graphene_impol, graphene_realeps, 
read_grapheneplasmon, read_grapheneplasmonline, read_levitov_tbgrapheneplasmon

end # module
