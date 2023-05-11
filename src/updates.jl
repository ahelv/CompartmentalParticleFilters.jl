# functions to update the states and parameters in the particle filter

# updating the compartment counts 
function updatecounts!(transition, compartments, parameters, θ, t, n, Nloc)
    comps = Dict()
    for key in keys(compartments)
        push!(comps, key => reduce(vcat, compartments[key][t][n].count))
    end
    params = Dict()
    for key in keys(parameters)
        push!(params, key => reduce(vcat, parameters[key].val))
    end
    change = rand.(transition.trans(; comps..., params..., θ...))
    # store change
    compartments[transition.outComp][t][n].change .-= change
    compartments[transition.inComp][t][n].change .+= change
    if isassigned(compartments[transition.outComp][t+1], n)
        compartments[transition.outComp][t+1][n].count .-= change
        comps[transition.outComp] .-= change
    else
        compartments[transition.outComp][t+1][n] =
            compartment(transition.outComp,
                comps[transition.outComp] .- change, zeros(Nloc))
        comps[transition.outComp] .-= change
    end
    if isassigned(compartments[transition.inComp][t+1], n)
        compartments[transition.inComp][t+1][n].count .+= change
        comps[transition.inComp] .+= change
    else
        compartments[transition.inComp][t+1][n] =
            compartment(transition.inComp,
                comps[transition.inComp] .+ change, zeros(Nloc))
        comps[transition.inComp] .+= change
    end
end

# evolution for time varying parameters
function evolveparameters!(evolve, params, parameters, θ, t, n, nLoc)
    parameters[evolve.param][t+1][n] = parameter(evolve.param,
        evolve.evolution(params, θ, t, nLoc))
end

# propose new values for unknown parameters 
function proposeparameters!(propose, params, parameters, θ, t, n, nLoc)
    parameters[propose.param][t+1][n] = parameter(propose.param,
        propose.proposal(params, θ, t, nLoc))
end


