function data=dataDecompose(data,bandName)
% function loads data and subjects preprocessed data: re-referenced and
% bandpassed and filters in to bands of interests, outputting the amplitude
% and phase of that band.
% Alex Gonzalez May 2013

%% Parameters for decomposition.
% band limits and name
bands         = [1 4;4 8;8 12;12 30; 30 80;80 180; 30 180; 30 35; 3 4; 7 8]; % in Hz
bandNames    = {'delta','theta','alpha','beta','lgam','hgam','bb','lgam_scalp', 'theta_lo', 'theta_hi'};
bandID = strcmp(bandNames,bandName);
bandLims = bands(bandID,:);
lp = bandLims(2);
hp = bandLims(1);
SR = data.SR;

amp = zeros(size(data.signal));
phase = zeros(size(data.signal));

data.band = bandName;
data.bandLims = bandLims;

X = data.signal; data.signal = [];
for ch = 1:data.nChans
    channel = num2str(ch);
    display(['Processing Channel ' channel])
    x = X(ch,:);
    [amp(ch,:),phase(ch,:)] = ecog_bandpass(x, lp, hp,SR);
    
end
data.amp = amp;
data.phase = phase;
