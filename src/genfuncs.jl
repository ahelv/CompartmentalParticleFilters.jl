# functions to auto-generate required particle filtering functions 

# transition functions
function maketrans(ODE, outComp, inComp)
    transition((; args...) -> (Binomial.(args[outComp], 1 .- exp.(-1 .* ODE(; args...)))), outComp, inComp)
end

# spatial transition function
function maketrans_spatial(ODE, D, ρ, outComp, inComp)
    transition((; args...) -> (Binomial.(args[outComp], 1 .- exp.(-1 .* (ODE(; args...) .+ (ρ .* D * ODE(; args...)))))), outComp, inComp)
end