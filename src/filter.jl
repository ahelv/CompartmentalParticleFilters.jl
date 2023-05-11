# particle filtering algorithm 

function filter(y::Vector, N::Int, θ::NamedTuple, θt::NamedTuple, g::Function,
    compartments::NamedTuple, transitions::Vector, evolutions::Vector)

    # check if the number of locations is the same for each compartment
    @assert equallength(compartments) raw"All compartments must have the same number of spatial locations."
    Nloc = length(compartments[1])
    Nthresh = 0.25 * N # threshold for effective sample size
    T = length(y)
    particles = Dict()
    Threads.@threads for l = eachindex(compartments)
        init = compartments[l]
        array = [Array{Compartment}(undef, N) for _ in 1:T]
        array[1] = [compartment(l, init, zeros(Nloc)) for _ in 1:N]
        push!(particles, l => array)
    end
    parameters = Dict()
    for l = eachindex(θt)
        init = θt[l]
        array = [Array{Parameter}(undef, N) for _ in 1:T]
        array[1] = [parameter(l, init) for _ in 1:N]
        push!(parameters, l => array)
    end

    params_tn = Dict()

    w_mat = Array{Float64}(undef, T, N)
    w = log.(1 / N * ones(N))
    w0 = copy(w)
    w += g(y, particles, θ, parameters, 1)
    w = log_normalize(w)
    w_mat[1, :] = w
    for t = 1:(T-1)
        Neff = 1 / sum((exp.(w)) .^ 2)
        # resample?
        if Neff < Nthresh
            # resample
            j = resample(w) # add resample function as a parameter so choices other than multinomial?
            for key in keys(particles)
                setfield!.(particles[key][t], :count, getfield.(particles[key][t], :count)[j])
            end
            wT = copy(w0)
        else # do not resmaple 
            wT = copy(w)
        end

        # propogate particles forward in time
        Threads.@threads for n in 1:N
            for key in keys(parameters)
                push!(params_tn, key => parameters[key][t][n])
            end
            for trans in transitions
                updatecounts!(trans, particles, params_tn, θ, t, n, Nloc)
            end
            for p in proposals
                proposeparameters!(p, params_tn, parameters, θ, t, n, Nloc)
            end
            for e in evolutions
                evolveparameters!(e, params_tn, parameters, θ, t, n, Nloc)
            end
        end
        # # measurement update 
        w = log_normalize(wT + g(y, particles, θ, parameters, t))
        @assert !any(isnan.(w)) "NaN present in weights"
        # store weights
        w_mat[t+1, :] = w
    end
    return particles, parameters, transpose(exp.(w_mat))
end
