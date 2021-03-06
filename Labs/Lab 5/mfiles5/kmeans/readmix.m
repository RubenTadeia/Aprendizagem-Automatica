function mix = readmix(fname)
% mix = readmix(fname) 
%  Reads the parameters of a mixture of gaussians from file specified
%  by string  fname and builds up the cell array mix with the relevant 
%  parameters.
%
%  The format of the mixture file is the following:
%
%  [Number of dimensions]
%  [Number of gaussians]
%  [Prior-gaussian-1 Prior-gaussian-2 ... Prior-gaussian-n]
%  [Mean of gaussian  1]
%  [Generating matrix 1]
%  [Mean of gaussian  2]
%  [Generating matrix 2]
% ...
%  [mean of gaussian  n]
%  [Generating matrix n]
%
%   The generating matrix defines the transformation required for
%   generating samples of a given class. If s is a vector of 
%   gaussian uncorrelated samples of 0 mean and unitary variance,
%   and A is a generation matrix for a given class, data x this class
%   can be generated by
%
%   x = A s
% 
%   Note that the covariance matrix Rxx is related with A by
%
%    Rxx = E[xx^T] = E[A s s^T A^T] = A E[ s s^T] A^T = A A^T 
%
% The cell array mix has the following components:
%
%  mix{1} - Number of gaussians
%  mix{2} - Vector of Priors
%  mix{3} ...  mix{K+2}...mix{NG+2} Parameter 
%             data for gaussian   1...K...NG 
%  Each gaussian cell G=mix{k} includes the following parameters:
%
%    G{1} - Mean
%    G{2} - Generation matrix
%    G{3} - Covariance matrix
%    G{4} - Inverse of covariance matrix
%    G{5} - Determinant of covariance matrix
%
% Author: Fernando M. Silva
%         Instituto Superior T'ecnico
%         fcr@inesc.pt
%
  fid = fopen(fname,'r');

  dim = fscanf(fid,'%d',1);
  ng  = fscanf(fid,'%d',1);
  p=fscanf(fid,'%f',ng);

  mix{1} = ng;
  mix{2} = p;

  for i=1:ng,
    m=fscanf(fid,'%f',dim);
    lg=fscanf(fid,'%f',[dim,dim]);
    rxx = lg*lg';
    drxx = det(rxx);
    c = {m,lg,rxx,inv(rxx),drxx};
    mix{i+2} = c;
  end

  th(1)=p(1);
  for k=2:ng,
    th(k) = th(k-1) + p(k);
  end;
  if(abs(th(ng) - 1) > 1e-6),
    fprintf(1,'Error in priors');
    th
    a(-1)=-1;
  end
  mix{ng+3} = th;
  fclose(fid);
  return
  

