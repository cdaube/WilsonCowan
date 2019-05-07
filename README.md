# WilsonCowan

I wrote down my understanding of Doelling etal's (PNAS 2019) description of their Wilson-Cowan oscillator model.
Happy to learn what I did wrong -- please let me know :)!

#### myWilsonCowan.m 
implements the model as specified by Doelling etal (or at least as I understand it!).

#### WilsonCowanAtRest.m 
calls myWilsonCowan with the driving force set to 0 to check if it indeed has a 4 Hz resting activity. Doelling et al describe that for the parameters they chose, this should be the case.
![alt text](https://github.com/cdaube/WilsonCowan/blob/master/Figures/Figure_WilsonCowanAtRest.png)
As we see in the figure above, this seems to be the case.

#### doellingIntuition.m 
runs a simple periodic input with some decay into the oscillator model and a barbarically simple evoked model. I am checking if I can reproduce their figure 1 intuition (i.e. a variable phase difference between stimulus and response for constant lag LTI model and a constant phase difference with a variable time lag for the oscillator model). 
I would have liked to see the filtered responses in the figure by Doelling etal!
![alt text](https://github.com/cdaube/WilsonCowan/blob/master/Figures/Figure_EvOscDoellingIntuition.png)
As far as I can see in the figure above, in this simple setup, everything seems to work more or less as expected.

#### frequenciesIntensities.m 
runs more frequencies at different intensities into the evoked and oscillator model (calling runEvOsc.m which is a quick and dirty function copy-pasted from doellingIntuition.m). I didn't find any information on how Doelling et al set the intensity of their input, i.e., whether they normalised and/or rescaled their input, and was wondering if the output depends on the input intensity.
![alt text](https://github.com/cdaube/WilsonCowan/blob/master/Figures/Figure_PhaseDiff_freqInt_evOsc.png)
We see here the phase differences (stimulus vs response) for evoked (left) and oscillatory responses (right). 
As expected, the evoked responses show a variable phase difference across frequencies, and we see they aren't much impressed by the intensities.
We then also see that the oscillatory model has a more or less constant phase difference (as described by Doelling et al) across frequencies for intensities around 1 --3. For other intensities however, the angle is more variable.
I guess the point is that this model has the *potential* to have a stable phase difference.

