function [map] = getRBColormap(m)
%RBCOLORMAP Creates red-blue colormap with m levels

    n = fix(m/2); 
    x = n~=(m/2); 
    r = [(0:1:n-1)/n,ones(1,n+x)]; 
    g = [(0:1:n-1)/n,ones(1,x),(n-1:-1:0)/n]; 
    b = [ones(1,n+x),(n-1:-1:0)/n]; 
    map = [r(:),g(:),b(:)];

end

