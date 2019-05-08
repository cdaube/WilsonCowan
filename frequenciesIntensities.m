pMap = colorcet('C8'); % colorcet function by Peter Kovesi ("Good Colour Maps: How to Design Them". arXiv:1509.03700 [cs.GR] 2015)

% parameters
fs = 100;
nTarget = 10000;
intensities = -1:.125:2;
frequencies = 2:.5:14;

% obtain phase differences of stimulus and output
pdEv = zeros(numel(intensities),numel(frequencies));
pdOsc = zeros(numel(intensities),numel(frequencies));
for ii = 1:numel(intensities)
    disp(['ii ' num2str(ii)]);
    parfor ff = 1:numel(frequencies)
        [pdEv(ii,ff),pdOsc(ii,ff)] = runEvOsc(frequencies(ff),fs,nTarget,10.^intensities(ii));
    end
end

% plot
subplot(1,2,1)
    imagesc(pdEv)
    axis image
    axis xy
    set(gca,'YTick',1:numel(intensities),'YTickLabel',num2str(10.^intensities',3));
    set(gca,'XTick',1:numel(frequencies),'XTickLabel',num2str(frequencies'));
    colorbar
    ylabel('Intensity of Driving Input')
    xlabel('Frequency of Driving Input [Hz]')
    title('\Delta \Phi stimulus - evoked response (radians)')
subplot(1,2,2); 
    imagesc(pdOsc); 
    axis image
    axis xy
    colormap(hsv);
    set(gca,'YTick',1:numel(intensities),'YTickLabel',num2str(10.^intensities',3));
    set(gca,'XTick',1:numel(frequencies),'XTickLabel',num2str(frequencies'));
    colorbar
    ylabel('Intensity of Driving Input')
    xlabel('Frequency of Driving Input [Hz]')
    title('\Delta \Phi stimulus - oscillatory response (radians)')
colormap(pMap)
    
fig = gcf;    
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 60 30];
fig.PaperSize = [60 30];
print(fig,'-dpng','-r300',['Figures/Figure_PhaseDiff_freqInt_evOsc.png'])