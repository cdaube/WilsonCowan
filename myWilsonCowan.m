function xQ = myWilsonCowan(externalInput,tGiven,varargin)
% implementation of Wilson-Cowan oscillator model as defined in Doelling
% etal, PNAS 2019
% solves differential equations using ode45 solver, returns excitatory and
% inhibitory output
%
% needs
%  externalInput - columns vector, time series of driving force on oscillator
%  tGiven - column vector, time information of externalInput; output will
%    be interpolated on this
%
% optional inputs
%  startValues - row vector with 2 elements, defines the starting values of
%    excitatory and inhibitory output (default is [0 0])
%  tSpan - row vector with 2 elements [start stop], defines the time span
%    of which model output is returned (default corresponds to start and
%    stop of tGiven)
%  rhoE, rhoI, a, b, c, d, kappa, tauE, tauI - parameters of Wilson-Cowan
%    model (cf Doelling etal for details and default settings)
%
% gives
%  xQ - matrix with two columns describing excitatory and inhibitory output
%
% Christoph Daube, Glasgow May 2019
% christoph.daube@gmail.com

    fixedArgs = 2;
    if nargin >= fixedArgs+1
        for ii = fixedArgs+1:2:nargin
            switch varargin{ii-fixedArgs}
                case 'startValues'
                    startValues = varargin{ii-(fixedArgs-1)};
                case 'tSpan'
                    tSpan = varargin{ii-(fixedArgs-1)};
                case 'rhoE'
                    rhoE = varargin{ii-(fixedArgs-1)};
                case 'rhoI'
                    rhoI = varargin{ii-(fixedArgs-1)};
                case 'a'
                    a = varargin{ii-(fixedArgs-1)};
                case 'b'
                    b = varargin{ii-(fixedArgs-1)};
                case 'c'
                    c = varargin{ii-(fixedArgs-1)};
                case 'd'
                    d = varargin{ii-(fixedArgs-1)};
                case 'kappa'
                    kappa = varargin{ii-(fixedArgs-1)};
                case 'tauE'
                    tauE = varargin{ii-(fixedArgs-1)};
                case 'tauI'
                    tauI = varargin{ii-(fixedArgs-1)};
            end
        end
    end

    % set defaults
    if ~exist('startValues','var'); startValues = [0 0]; end
    if ~exist('tSpan','var'); tSpan = [tGiven(1) tGiven(end)]; end
    if ~exist('rhoE','var'); rhoE = 2.3; end
    if ~exist('rhoI','var'); rhoI = -3.2; end
    if ~exist('a','var'); a = 10; end
    if ~exist('b','var'); b = 10; end
    if ~exist('c','var'); c = 10; end
    if ~exist('d','var'); d = -2; end
    if ~exist('kappa','var'); kappa = 1.5; end
    if ~exist('tauE','var'); tauE = .066; end
    if ~exist('tauI','var'); tauI = .066; end

    % helper functions
    % sample digitally sampled vector of input at any t
    sampleInput = @(t) interp1(tGiven,externalInput,t);
    % sigmoid function
    sigmoid = @(x) 1./(1+exp(-x));
    
    % define 2D differential equations
    wilsCow = @(t,ei) [(-ei(1) + sigmoid(rhoE + c.*ei(1) - a.*ei(2) + kappa.*sampleInput(t)))./tauE; ...
                   (-ei(2) + sigmoid(rhoI + b.*ei(1) - d.*ei(2)))./tauI];
           
    % solve differential equations
    [t,xa] = ode45(wilsCow,tSpan,startValues);
    % interpolate on queried time points
    xQ = interp1(t,xa,tGiven);

end