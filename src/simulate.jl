function simEpidemic(Nt::Int, θ::NamedTuple, θt::NamedTuple,
    compartments::NamedTuple, transitions::Vector, evolutions::Vector)
    n = 1
    nComp = length(compartments)
    nLoc = length(compartments[1])
    counts = Array{Float64}(undef, Nt, nLoc, nComp)
    nθt = length(θt)
    par = Array{Float64}(undef, Nt, nLoc, nθt)

    epid = Dict()
    for l = eachindex(compartments)
        init = compartments[l]
        array = [Array{compartment}(undef, 1) for _ in 1:Nt]
        array[1] = [compartment(l, init, zeros(nLoc))]
        push!(epid, l => array)
    end

    parameters = Dict()
    for l = eachindex(θt)
        init = θt[l]
        array = [Array{parameter}(undef, 1) for _ in 1:Nt]
        array[1] = [parameter(l, init)]
        push!(parameters, l => array)
    end

    params_tn = Dict()

    for t = 1:(Nt-1)
        #  create the epidemic
        for key in keys(parameters)
            push!(params_tn, key => parameters[key][t][n])
        end
        for trans in transitions
            UpdateCounts!(trans, epid, params_tn, θ, t, n, nLoc)
        end
        for e in evolutions
            UpdateParameters!(e, params_tn, parameters, θ, t, n, nLoc)
        end
    end
    tmpC = collect(values(epid))
    tmpP = collect(values(parameters))
    Threads.@threads for comp = eachindex(tmpC)
        for i in 1:Nt
            cnt = getfield.(tmpC[comp][i], :count)
            for l in 1:nLoc
                counts[i, l, comp] = cnt[1][l]
            end
        end
    end
    Threads.@threads for p in eachindex(tmpP)
        for i in 1:Nt
            pr = getfield.(tmpP[p][i], :val)
            for l in 1:nLoc
                par[i, l, p] = pr[1][l]
            end
        end
    end
    return counts, par, epid
end