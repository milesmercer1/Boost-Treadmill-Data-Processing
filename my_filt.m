%Fourth Order Zero lag Butterworth Filter
%
%Function called as:
%[smooth_data] = my_filt(rawdata, fc, fs, type)
%
%where
%fc = cutoff frequency
%fs = sample frequency
%type = type of filter
%	1 = low pass filter
%	2 = high pass filter
%==================================================

function [smoothed_data] = my_filt(raw_data,fc, fs, type)

warning off

%calculate wn
wn = 2*fc/fs;

%calculate butterworth coefficients (2nd order)
if type == 1
   [B,A]=butter(2,wn);
end
if type == 2
   [B,A]=butter(2,wn,'high');
end

%calculate smoothed data using a zero-phase lag routine
smoothed_data=filtfilt(B,A,raw_data);

warning on
