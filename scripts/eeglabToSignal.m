function data = eeglabToSignal(eeglab_ALLEEG, sampling_rate, subj_num, condition, shockcondition, channel_name)

% Transform subject's EEGLAB data into data.signal structure for dataDecompose.m

%%%%%%% Example
%
% data = eeglabToSignal(ALLEEG, 500, 8, 'CR', 'safe', {'E62'});
%
% i = 1;
% sampling_rate = 500;
% eeglab_ALLEEG = ALLEEG; % from eeglab study
% subj_num = 8;
% condition = 'HIT';
% shockcondition = 'safe';
% channel_name = {'E62'}; % can be >1
%
%%%%%%%

data.SR = sampling_rate;
data.nChans = length(channel_name);

for i=1:length(eeglab_ALLEEG)
    
    % get trial info
    filename = [eeglab_ALLEEG(i).datfile];
    [sub, remain] = strtok(filename,'_');
    [~, remain] = strtok(remain,'_');
    [shockcond, remain] = strtok(remain,'_');
    [memtype, remain] = strtok(remain,['_', '.']);
    
    % check if meets criteria
    if str2double(sub) == subj_num
        if strcmp(memtype,condition) && strcmp(shockcond, shockcondition)
            ch_ind = [];
            % get channel inds
            for j = 1:length(eeglab_ALLEEG(i).chanlocs)
                if strcmp(eeglab_ALLEEG(i).chanlocs(j).labels,channel_name)
                    ch_ind = j;
                end
            end
            
            data.signal = eeglab_ALLEEG(i).data;
            data.nSamples = size(data.signal,2);
            data.nTrials = size(data.signal,3);
            data.signal = reshape(data.signal(ch_ind,:,:),1,[]);
        end
    end
end