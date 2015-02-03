function [outliers] = art_detect(wave, n_sd, type)

switch type
    
    case {'signal'}
        
        thresh = n_sd * std(wave);
        outliers = or(wave > mean(wave) + thresh, wave < mean(wave) - thresh);
        
    case {'gradient'}
        
        grad = [0 wave(2:end) - wave(1:(end-1))];
        thresh = n_sd * std(grad);
        outliers = or(grad > mean(grad) + thresh, grad < mean(grad) - thresh);
        
    otherwise
        
        error('Artifact rejection method not recognized, should be signal or gradient')
    
end