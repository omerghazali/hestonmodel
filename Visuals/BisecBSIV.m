function y = BisecBSIV(S,K,r,q,T,a,b,MktPrice,Tol,MaxIter)

% Function for the Black Scholes call and put
BSC = @(s,K,r,q,v,T) (s*exp(-q*T)*normcdf((log(s/K) + (r-q+v^2/2)*T)/v/sqrt(T)) - K*exp(-r*T)*normcdf((log(s/K) + (r-q+v^2/2)*T)/v/sqrt(T) - v*sqrt(T)));

lowCdif  = MktPrice - BSC(S,K,r,q,a,T);
highCdif = MktPrice - BSC(S,K,r,q,b,T);

if lowCdif*highCdif > 0
	y = -1;
else
	for x=1:MaxIter
		midP = (a+b)/2;

		midCdif = MktPrice - BSC(S,K,r,q,midP,T);

		if abs(midCdif)<Tol
			break
		else
			if midCdif>0
				a = midP;
			else
				b = midP;
			end
		end
	end
	y = midP;
end
