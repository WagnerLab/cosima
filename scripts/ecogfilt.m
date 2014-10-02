function dataout = ecogfilt(data,fs,flow,fhigh,notch)

% note that flow>fhigh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ecog Filt
% Created by Alex Gonzalez
% Stanford Memory Lab
% Oct 23, 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%conversion to normalized frequency
freqconv  = 2/fs;
% filter order
% N = 1000;
N = 1000;%floor(50/3);
Nhp = N*2; %N if using low order filt

%% create filter for high pass
% uses interpolated FIR filter
if exist('fhigh','var')
    if ~isempty(fhigh)
        f0 = fhigh*freqconv;
        %df = f0*freqconv;
        %%w = [1e-5 1e3];
        %hp=firls(Nhp,[0 f0-df/2 f0+df/2 1],[0 0 1 1],w);
        hp=fir1(Nhp,f0,'high',window(@hann,Nhp+1));
    else
        hp =[];
    end
else
    hp =[];
end
%% create filter for low pass
% uses FIR least squares filter
if exist('flow','var')
    if ~isempty(flow)
        f0 = flow*freqconv;
        %df = (f0/10)*freqconv;
        %lp=firls(N,[0 f0-df/2 f0+df/2 1],[1 1 0 0]);
        lp = fir1(N,f0,window(@hann,N+1));
    else
        lp =[];
    end
else
    lp =[];
    
end
%% create filter for notch filter
% uses FIR least squares filter
if exist('notch','var')
    if ~isempty(notch)
        f0 = notch*freqconv;
        %df = (f0/5)*freqconv;
        %h=firls(N,[0 f0-df/2 f0+df/2 1],[1 1 0 0]);
        h = fir1(N,f0,window(@hann,N+1));
        nf = 2*h - ((0:N)==(N/2));
    else
        nf = [];
    end
else
    nf = [];
end
%% use filtfilt with fir filters for now phase effects

% assume data is by row
n = size(data,1);
dataout = zeros(size(data));

for i = 1:n
    
    x = double(data(i,:));
    %highpass
    if ~isempty(hp)
        x = filtfilt(hp,1,x);
    end
    % lowpass
    if ~isempty(lp)
        x = filtfilt(lp,1,x);
    end
    % notch
    if ~isempty(nf)
        x = filtfilt(nf,1,x);
    end
    dataout(i,:) = single(x);
    
end

return


