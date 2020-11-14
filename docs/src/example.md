using PAPI
X = rand(10000)
function mysum(X)
  x = zero(eltype(X))
  for v in X
    x += v
  end
  x
end

