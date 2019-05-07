% parameters
fs = 100;
n = 10000;
tGiven = 1/fs:1/fs:n/fs;

% zero driving input
externalInput = zeros(n,1);
% obtain oscillator responses
xQ = myWilsonCowan(externalInput,tGiven);

% plot
tSel = 50:250;
plot(tGiven(tSel),xQ(tSel,:))
legend('excitatory output','inhibitory output')
title('Doelling et al''s Wilson-Cowan model at rest')
ylabel('Amplitude [a.u.]')
xlabel('Time [s]')

fig = gcf;    
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 15 10];
fig.PaperSize = [15 10];
print(fig,'-dpng','-r300',['Figure_WilsonCowanAtRest.png'])