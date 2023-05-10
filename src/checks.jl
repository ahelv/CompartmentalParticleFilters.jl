# functions to check validity of user inputs 

function equallength(nt::NamedTuple)
    first_length = length(nt[1])
    for i in 2:length(nt)
        if length(nt[i]) != first_length
            return false
        end
    end
    return true
end