module CompartmentalParticleFilters

## change function names and struct names to comply with julia naming conventions ##

## dependencies ##
using Random
using LinearAlgebra
using Plots
using Distributions
using Base.Threads
using StatsBase

## My Contributions ##
# filter.jl
include("filter.jl")
export filter

# structs.jl
include("structs.jl")
export MultPoisson, Compartment, Parameter, Transition, Evolve

# resample.jl
include("resample.jl")
export resample

# normalize.jl
include("normalize.jl")
export log_normalize

# updates.jl
include("updates.jl")
export updatecounts!, updateparameters!

# checks.jl
include("checks.jl")
export equallength

# genfuncs.jl
include("genfuncs.jl")
export maketrans, maketrans_spatial

# simulate.jl
include("simulate.jl")
export simulate_epidemic

# neighbors.jl
include("neighbors.jl")
export distmat
end
