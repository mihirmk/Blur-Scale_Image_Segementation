function [out]=CheckOutOfBounds(n,m,y1,y2,x1,x2)
if sum(find(y1 < 1))~=0 || sum(find(y1 > n))~=0 || sum(find(y2 < 1))~=0 || sum(find(y2 > n))~=0 || sum(find(x1 < 1))~=0 || sum(find(x1 > m))~=0 || sum(find(x2 < 1))~=0 || sum(find(x2 > m))~=0
    out = 1;
else
    out = 0;
end