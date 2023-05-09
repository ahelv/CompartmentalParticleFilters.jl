# custom structs

# vectorized Poisson distribution
struct MultPoisson{T<:Real}
    λ::Vector{T}
end

Distributions.pdf(d::MultPoisson, x::Vector{T}) where {T<:Real} = prod(pdf.(Poisson.(d.λ), x))
Distributions.logpdf(d::MultPoisson, x::Vector{T}) where {T<:Real} = sum(logpdf.(Poisson.(d.λ), x))
Distributions.rand(rng::AbstractRNG, d::MultPoisson) = [rand(rng, Poisson(λ_i)) for λ_i in d.λ]
Distributions.mean(d::MultPoisson) = d.λ
Distributions.var(d::MultPoisson) = d.λ

# disease compartment (S, E, I, R, etc.)
mutable struct compartment
    const name::Symbol
    count::Vector
    change::Vector
end

# epidemic parameter
mutable struct parameter
    const name::Symbol
    val::Vector
end

# transition function for movement between compartments 
struct transition
    trans::Function
    outComp::Symbol
    inComp::Symbol
end

# parameter evolutions for time varying parameters 
struct evolve
    evolution::Function
    param::Symbol
end