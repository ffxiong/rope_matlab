function out = delay(in, shift)
num_rows = size(in,1);
num_values = length(shift);
num_zeros = max(abs(shift));
in = [zeros(num_rows,num_zeros),in,zeros(num_rows,num_zeros)];
out = zeros(num_rows*num_values,size(in,2));
for j=1:num_values
    out((1+(j-1)*num_rows):(num_rows+(j-1)*num_rows),:) = circshift(in, [0 shift(j)]);
end
out = out(:,1+num_zeros:end-num_zeros);
end