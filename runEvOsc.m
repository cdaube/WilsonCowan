function [pcmEv,pcmOsc,ev,osc,evF,oscF,evA,oscA,stimF,stimA,phaseDiffEv,phaseDiffOsc] = runEvOsc(f,fs,nTarget,intensity)
% quick and dirty function that gives evoked and Wilson-Cowan responses for
% different frequencies and intensities of input
%
% Christoph Daube, Glasgow 2019
% christoph.daube@gmail.com

    % helper functions
    halve = @(x) x(1:end-round(size(x,1)/2),:,:,:);
    unitStep = @(x) (x-min(x))./(max(x-min(x)));

    % determine analysis filters
    [b,a] = butter(3,[f-1 f+1].*2/fs,'bandpass');

    % get stimuli with a bit of decay (works better with ode solvers)
    kernDecay = [0; flipud(halve(hamming(20)))];
    kernelF1 = [1; zeros(round(fs/f)-1,1)];
    stim = conv(repmat(kernelF1,round(nTarget/numel(kernelF1)),1),kernDecay,'same');

    % determine barbarically simplistic response kernel
    kernSharp = [zeros(4,1);1;zeros(10,1)];

    % get evoked responses as convolution of kernel and stimulus
    ev = conv(stim,kernSharp);
    ev(numel(stim)+1:end) = [];
    
    % generate time vector
    tGiven = 0:1/fs:numel(stim)/fs-1/fs;
    
    % get oscillator response
    osc = myWilsonCowan(unitStep(stim).*intensity,tGiven);
    osc = osc(:,1);

    % filter evoked responses
    evF = filtfilt(b,a,ev);
    % filter oscillator responses
    oscF = filtfilt(b,a,osc);
    % filter stimulus 
    stimF = filtfilt(b,a,stim);

    % get evoked response angles
    evA = angle(hilbert(evF));
    % get oscillator response angles
    oscA = angle(hilbert(oscF));
    % trim edge artifacts
    evA([1:1000,end-1000:end]) = [];
    oscA([1:1000,end-1000:end]) = [];

    % get stimulus angles
    stimA = angle(hilbert(stimF));
    % trim edge artifacts
    stimA([1:1000,end-1000:end]) = [];

    % get phase differences
    phaseDiffEv = stimA-evA;
    phaseDiffOsc = stimA-oscA;

    % get mean phase angle (= sum of complex value)
    pcmEv = angle(sum(exp(i*phaseDiffEv)));
    pcmOsc = angle(sum(exp(i*phaseDiffOsc)));
end