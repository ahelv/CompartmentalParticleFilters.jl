# resampling methods 

# multinomial resampling
function resample(ω)
    N = length(ω)
    O = rand(Multinomial(N, exp.(ω)), 1)
    index = []
    for i = 1:N
        if O[i] > 0
            index = vcat(index, fill(i, O[i]))
        end
    end
    return index
end