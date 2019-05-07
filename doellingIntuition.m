
% helper functions
halve = @(x) x(1:end-round(size(x,1)/2),:,:,:);
unitStep = @(x) (x-min(x))./(max(x-min(x)));

% parameters
f1 = 4; % slow frequency
f2 = 10; % fast frequency
fs = 100;

% determine analysis filters
[bSlow,aSlow] = butter(3,[f1-1 f1+1].*2/fs,'bandpass');
[bFast,aFast] = butter(3,[f2-1 f2+1].*2/fs,'bandpass');

nTarget = 25000;
% get stimuli with a bit of decay (works better with ode solvers)
kernDecay = [0; flipud(halve(hamming(20)))];
kernelF1 = [1; zeros(fs/f1-1,1)]; % quick and dirty!
kernelF2 = [1; zeros(fs/f2-1,1)]; % quick and dirty!
stimSlow = conv(repmat(kernelF1,nTarget/numel(kernelF1),1),kernDecay,'same');
stimFast = conv(repmat(kernelF2,nTarget/numel(kernelF2),1),kernDecay,'same');

% determine simplistic response kernel
kernSharp = [zeros(4,1);1;zeros(10,1)];

% get evoked responses as convolution of kernel and stimulus
evSlow = conv(stimSlow,kernSharp);
evSlow(nTarget+1:end) = [];
evFast = conv(stimFast,kernSharp);
evFast(nTarget+1:end) = [];

% get oscillator response
tGiven = 0:1/fs:numel(stimSlow)/fs-1/fs;
oscSlow = myWilsonCowan(unitStep(stimSlow).*1,tGiven);
oscFast = myWilsonCowan(unitStep(stimFast).*1,tGiven);
% arbitraily choose excitatory output (what did Doelling et al choose??)
oscSlow = oscSlow(:,1);
oscFast = oscFast(:,1);

% filter evoked responses
evSlowF = filtfilt(bSlow,aSlow,evSlow);
evFastF = filtfilt(bFast,aFast,evFast);
% filter oscillator responses
oscSlowF = filtfilt(bSlow,aSlow,oscSlow);
oscFastF = filtfilt(bFast,aFast,oscFast);
% filter stimulus 
stimSlowF = filtfilt(bSlow,aSlow,stimSlow);
stimFastF = filtfilt(bFast,aFast,stimFast);

% get evoked response angles
evSlowA = angle(hilbert(evSlowF));
evFastA = angle(hilbert(evFastF));
% get oscillator response angles
oscSlowA = angle(hilbert(oscSlowF));
oscFastA = angle(hilbert(oscFastF));
% trim edge artifacts
evSlowA([1:1000,end-1000:end]) = [];
evFastA([1:1000,end-1000:end]) = [];
oscSlowA([1:1000,end-1000:end]) = [];
oscFastA([1:1000,end-1000:end]) = [];

% get stimulus angles
stimSlowa = angle(hilbert(stimSlowF));
stimFasta = angle(hilbert(stimFastF));
% trim edge artifacts
stimSlowa([1:1000,end-1000:end]) = [];
stimFasta([1:1000,end-1000:end]) = [];

% get phase differences
phaseDiffEvSlow = stimSlowa-evSlowA;
phaseDiffEvFast = stimFasta-evFastA;
phaseDiffOscSlow = stimSlowa-oscSlowA;
phaseDiffOscFast = stimFasta-oscFastA;

% get mean phase angle (= sum of complex value)
pdEvSlow = angle(sum(exp(i*phaseDiffEvSlow)));
pdEvFast = angle(sum(exp(i*phaseDiffEvFast)));

pdOscSlow = angle(sum(exp(i*phaseDiffOscSlow)));
pdOscFast = angle(sum(exp(i*phaseDiffOscFast)));

%% plotting

tSel = 1000:1200;
tVec = 1/fs:1/fs:numel(tSel)/fs;
figure(1)
subplot(5,2,1)
    plot(tVec,stimSlow(tSel))
    hold on
    plot(tVec,evSlow(tSel))
    plot(tVec,evSlowF(tSel))
    plot(tVec,stimSlowF(tSel))
    hold off
    legend('stimulus','evoked response','filtered evoked response','filtered stimulus')
    xlim([tVec(1) tVec(end)])
    title('Evoked Slow')
subplot(5,2,3)
    plot(tVec,stimSlowa(tSel))
    hold on
    plot(tVec,evSlowA(tSel))
    hold off
    legend('phase stimulus','phase response')
    xlim([tVec(1) tVec(end)])
subplot(5,2,5)
    polarplot([pdEvSlow pdEvSlow],[0 1],[pdEvFast pdEvFast],[0 1])
    legend('average \Delta \Phi slow','average \Delta \Phi fast')
subplot(5,2,7)
    plot(tVec,stimFast(tSel))
    hold on
    plot(tVec,evFast(tSel))
    plot(tVec,evFastF(tSel))
    plot(tVec,stimFastF(tSel))
    hold off
    legend('stimulus','evoked response','filtered evoked response','filtered stimulus')
    xlim([tVec(1) tVec(end)])
    title('Evoked Fast')
subplot(5,2,9)
    plot(tVec,stimFasta(tSel))
    hold on
    plot(tVec,evFastA(tSel))
    hold off
    legend('phase stimulus','phase response')
    xlim([tVec(1) tVec(end)])
    
subplot(5,2,2)
    plot(tVec,stimSlow(tSel))
    hold on
    plot(tVec,unitStep(oscSlow(tSel)))
    plot(tVec,unitStep(oscSlowF(tSel)))
    plot(tVec,stimSlowF(tSel))
    hold off
    legend('stimulus','oscillatory response','filtered oscillatory response','filtered stimulus')
    xlim([tVec(1) tVec(end)])
    title('Oscillatory Slow')
subplot(5,2,4)
    plot(tVec,stimSlowa(tSel))
    hold on
    plot(tVec,oscSlowA(tSel))
    hold off
    legend('phase stimulus','phase response')
    xlim([tVec(1) tVec(end)])
subplot(5,2,6)
    polarplot([pdOscSlow pdOscSlow],[0 1],[pdOscFast pdOscFast],[0 1])
    legend('average \Delta \Phi slow','average \Delta \Phi fast')
subplot(5,2,8)
    plot(tVec,stimFast(tSel))
    hold on
    plot(tVec,unitStep(oscFast(tSel)))
    plot(tVec,unitStep(oscFastF(tSel)))
    plot(tVec,stimFastF(tSel))
    hold off
    legend('stimulus','oscillatory response','filtered oscillatory response','filtered stimulus')
    xlim([tVec(1) tVec(end)])
    title('Oscillatory Fast')
subplot(5,2,10)
    plot(tVec,stimFasta(tSel))
    hold on
    plot(tVec,oscFastA(tSel))
    hold off
    legend('phase stimulus','phase response')
    xlim([tVec(1) tVec(end)])

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 40 40];
fig.PaperSize = [40 40];
print(fig,'-dpng','-r300',['Figure_EvOscDoellingIntuition.png'])