module CompartmentalParticleFilters

## change function names and struct names to comply with julia naming conventions ##

## dependencies ##
using CSV
using Random
using LinearAlgebra
using Plots
using Distributions
using Base.Threads
using StatsBase

## My Contributions ##
# filter.jl
include("filter.jl")
export pf

# structs.jl
include("structs.jl")
export MultPoisson, compartment, parameter, transition, evolve

# resample.jl
include("resample.jl")
export resample

# normalize.jl
include("normalize.jl")
export log_normalize

# updates.jl
include("updates.jl")
export UpdateCounts!, UpdateParameters!

# checks.jl
include("checks.jl")
export equalLength

# genfuncs.jl
include("genfuncs.jl")
export makeTrans, makeTransSpatial

# simulate.jl
include("simulate.jl")
export simEpidemic

end
