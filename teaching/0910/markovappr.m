function [Tran,s,probst,alambda,asigmay]=markovappr(lambda,sigma,m,N)
% the simple case of approximating first-order 
% autoregressive process with Markov chain

% y_t = lambda * y_(t-1) + u_t

% u_t is a Gaussian white noise process with standard deviation sigma.

% m determines the width of discretized state space, Tauchen uses m=3
% ymax=m*vary,ymin=-m*vary, ymax and ymin are two boundary points

% N is the number of possible states chosen to approximate
% the y_t process, usually N=9 should be fine

% Tran is the transition matrix of the Markov chain

% s is the discretized state space of y_t

% alambda is the theoretical first order autoregression coefficient 
% for Markov chain

% asigma is the theoretical standard deviation for Markov chain Y_t

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% discretize the state space

stvy = sqrt(sigma^2/(1-lambda^2)); % standard deviation of y_t

ymax = m*stvy;                     % upper boundary of state space
ymin = -ymax;                      % lower boundary of state space

w = (ymax-ymin)/(N-1);             % length of interval 

s = ymin:w:ymax;                   % the discretized state space


% calculate the transition matrix

for j=1:N;
   
   for k=2:N-1;
      
      Tran(j,k)= normcdf(s(k)-lambda*s(j)+w/2,0,sigma)...
         - normcdf(s(k)-lambda*s(j)-w/2,0,sigma);
      
   end
   
   Tran(j,1) = normcdf(s(1)-lambda*s(j)+w/2,0,sigma);
   Tran(j,N) = 1 - normcdf(s(N)-lambda*s(j)-w/2,0,sigma);
   
end

if sum(Tran') ~= ones(1,N)
   
   str = find(Tran'-ones(1,N));  % find rows not adding up to one
   disp('error in transition matrix');
   disp(['rows ',num2str(str),' does not sum to one']);
   
end


% calculate the invariant distribution of Markov chain

Trans= Tran';
probst = (1/N)*ones(N,1); % initial distribution of states
test = 1;

  while test > 10^(-8);
      probst1 = Trans*probst;
      test=max(abs(probst1-probst));
      probst = probst1;   
   end
   
   meanm = s*probst;             % mean of invariant distribution
   varm = ((s-meanm).^2)*probst;  % variance of invariant distribution
    
   midaut1 = (s-meanm)'*(s-meanm); % cross product of deviation from the
                                   % mean of y_t and y_t-1
                                   
   probmat = probst*ones(1,N);     % each column is invariant distribution   
   
   
   midaut2 = Tran.*probmat.*midaut1; % product of the first two terms is 
                                     % the joint distribution of (Y_t-1,Y_t)
                                                                      
   autcov1 = sum(sum(midaut2));      % first-order auto-covariance
   
   
   % calculate the asymptotic second moments of Markov chain
   
   
   disp('lambda of original process v.s that of Markov chain')
   lambda
   
   disp('')
   alambda = autcov1/varm            % theoretical lambda
   
   disp('standard deviation of true process v.s that of Markov chain')
   stvy
   
   disp('')
   asigmay = sqrt(varm)
   
   
   






