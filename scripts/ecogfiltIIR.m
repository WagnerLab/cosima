function dataout = ecogfiltIIR(data,fs,flow,fhigh,notch)

% quick for CNS theta analysis 2014.

N= 6;
% filter coefficients for lowpass
[lpZeros,lpPoles] = ellip(N,2,10,flow/(fs/2),'low');
% filter coefficients for lowpass
[hpZeros, hpPoles] = ellip(N,2,10,fhigh/(fs/2),'high');

% assume data is by row
n = size(data,1);
dataout = zeros(size(data));

for i = 1:n
    
    x = double(data(i,:));
    %highpass
    if ~isempty(hpZeros)
        x = filtfilt(hpZeros,hpPoles,x);
    end
    % lowpass
    if ~isempty(lpZeros)
        x = filtfilt(lpZeros,lpPoles,x);
    end

    dataout(i,:) = single(x);
    
end
