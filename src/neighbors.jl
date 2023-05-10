# functions for generating distance matrices 

function distmat(nLoc)
    dim = Int(sqrt(nLoc))
    idxmat = reshape(1:nLoc, dim, dim)
    D = zeros(Float64, nLoc, nLoc)
    # rows
    for i in 1:dim
        # cols
        for j in 1:dim
            D_idx = idxmat[i, j]
            if (i > 1)
                D[D_idx, idxmat[i-1, j]] = 1
            end
            if (i < dim)
                D[D_idx, idxmat[i+1, j]] = 1
            end
            if (j > 1)
                D[D_idx, idxmat[i, j-1]] = 1
            end
            if (j < dim)
                D[D_idx, idxmat[i, j+1]] = 1
            end
        end
    end
    D
end
