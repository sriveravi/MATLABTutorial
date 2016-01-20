function res = fact( N )


res = 1;
for idx = N:-1:1
    res = res*idx;
end