function out=upsample(in,factor)

dim = size(in);
factor = fix(factor);

out = zeros(dim.*factor);
for i =  1 : 1 : factor
    for j = 1 : 1 : factor
        out(i:factor:end,j:factor:end) = in;
    end
    
end