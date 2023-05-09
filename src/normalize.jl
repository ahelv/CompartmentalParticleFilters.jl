# normalize log weights 
function log_normalize(log_ω)
    i = findmax(log_ω)[2]
    log_norm_ω = log_ω .- (log_ω[i] .+ log.(sum(exp.(log_ω .- log_ω[i]))))
    return log_norm_ω
end