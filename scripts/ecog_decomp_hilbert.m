function [decomp_signal] = ecog_decomp_hilbert(data, freqs, srate)
% Function for decomposing time series data into time-frequency
% representation (spectral decomposition) using Hilbert transform. Employs 
% band-pass / hilbert method to the obtain analytic signal for specified 
% frequencies.
% Inputs:
% data - vector of time series to be decomposed
% freqs - two column vector of band range (in Hz), low-high pairs 
% srate - sample rate (in Hz)
% 
% Calls:
% channel_filt.m - currently uses this function for band pass filter
%
% Brett Foster, Stanford Memory Lab, Feb. 2015

%% Variables
%sample rate
srate = round(srate);

%% Decompose
% Decomposition iterates through each frequency; where the bandpass signal
% is then passed to the hilbert transform.

%initialize variables
tmp_amplitude = zeros(length(freqs(:,1)),length(data));
tmp_phase = zeros(length(freqs(:,1)),length(data));

%loop through frequencies
for fi=1:length(freqs(:,1))
    
    %initialize variables
    tmp_bandpass = zeros(size(data));
    tmp_bandpass_analytic = zeros(size(data));
    
        %bandpass data - use function channel_filt.m for bandpass.
        tmp_bandpass = channel_filt(data, srate, freqs(fi,2), freqs(fi,1), []);
        
        %hilbert transform, obtain analytic signal
        tmp_bandpass_analytic = hilbert(tmp_bandpass);

    %extract amplitude and phase data
    %BF: apply amplitude normalization in function?
    tmp_amplitude(fi,:) = abs(tmp_bandpass_analytic); %amplitude
    tmp_phase(fi,:) = angle(tmp_bandpass_analytic); %phase
        
end %end frequency loop

%% collect data
decomp_signal.amplitude = tmp_amplitude;
decomp_signal.phase = tmp_phase;

%finish
