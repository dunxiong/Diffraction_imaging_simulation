function out = ItohPhaseUnwrap(in)
%Unwrap the image using the Itoh algorithm: the method is performed
%by first sequentially unwrapping the all rows, one at a time.
out = in;
dim=size(in);
for i=1:dim(1)
 out(i,:) = unwrap(out(i,:));
end
%Then sequentially unwrap all the columns one at a time
for i=1:dim(2)
 out(:,i) = unwrap(out(:,i));
end