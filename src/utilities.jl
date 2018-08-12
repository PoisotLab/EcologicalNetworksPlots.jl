function scale_value(k::T1, from::NTuple{2,T2}, to::NTuple{2,T3}) where {T1 <: Number, T2 <: Number, T3 <: Number}
    m, M = from
    l, U = to
    inter = (k-m)/(M-m)
    return inter*(U-l)+l
end
