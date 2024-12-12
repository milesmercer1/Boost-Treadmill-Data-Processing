%read in EMG file
%All EMG trials are 1 minute worth of data
clear all
clc
close (gcf)

%Create file name for indexing
name_index = 1;
%constants for indexing
%change subject number for initial fprint and for filenames - line 190
fprintf('Participant 1\n')
    
%create an area with each file name as a string - MATLAB will not read it
%unless it is in a string  
for name = ["noBWS.xlsx", "0% BWS.xlsx","20% BWS.xlsx"]
    %display file name to keep track
    fprintf(name)
    %Create index for every sheet, create string
    sheet_index = 1;
    for sheet = ["t1", "t2",  "t3","t4","t5","t6"]
        %display sheet name to keep track
        fprintf(sheet) 
        %Read in data and sheet name    
        data = xlsread(name,sheet);

        emg_data_raw = data(2:end, [2 7]); 

        accelerometer_data_TA = data (2:end, 3:5);
        
        
        %plot(emg_data)
           
        %pause
        %rectify EMG data -> full wave rectify signal
        
        %emg_data_raw = rmmissing(emg_data_raw);
        [data_row, data_col] = size(emg_data_raw);
        
        %data_row = 140000;
        
            
        %if data_row > 120000
         %   emg_data_raw = emg_data_raw(1:120000,:);
            
        %elseif data_row < 120000
         %   emg_data_raw = emg_data_raw;
            
        %end
        
        
        %emg_data_raw = emg_data_raw(1:120000,:);
        
        
       
            
        
        
        
        
         
        %Butterworth bandpass filter, set to cutoff of 30-500 HZ
        %Nyquist frequency = 2000/2 - normalize signal
        [row_emg,column_emg] = size(emg_data_raw);
        %plot(emg_data)
        
        %hold on
        
        
        filter_index = 1;
        %Will filter each column from BF > RF > GC > TA
        for muscle_sensor = (1:column_emg)
            %muscle_emg = emg_data(:,muscle_sensor);
            
            
            %first 10 seconds, last 10 seconds of EMG data
            %first_10_emg = emg_data_raw(1:20000,muscle_sensor);
            
            
            %Grab the last 30 seconds of each minute for analysis
            emg_data = emg_data_raw(end-59999:end,muscle_sensor);
            
            %emg_reshape = [first_10_emg, last_10_emg];
            %emg_data = reshape(emg_reshape, [], 1);
            
            
            
            
            mean_muscle = mean(emg_data);
            emg_data_muscle(:,1) = emg_data(:,1) - mean_muscle; %demean / remove dc bias
            plot(emg_data_muscle)
            title('demeaned EMG data')
            pause
            hold on
            
            
            if muscle_sensor == 1
                name_muscle = "Tibialis Anterior";
            elseif muscle_sensor == 2
                name_muscle = "Gastrocnemius";
            end
            
            
            
            emg_data_muscle(:,1) = abs(emg_data_muscle(:,1)); %rectify
            plot(emg_data_muscle(:,1),'k') %visualize raw data
            title(name_muscle)
            x0=10;
            y0=10;
            width=2000;
            height=400;
            set(gcf,'position',[x0,y0,width,height])
            hold on
            pause
            hold on
            %close gcf
            
            
            %examine raw data
            filter_emg_data(:,1) = my_filt(emg_data_muscle(:,1), 20, 2000, 2); %high pass
            plot(filter_emg_data,'g')
            title(name_muscle)
            x0=10;
            y0=10;
            width=2000;
            height=400;
            set(gcf,'position',[x0,y0,width,height])
            pause
            hold on
            filter_emg_data = abs(filter_emg_data);
            
            
            
             
            filter_emg_data(:,1) = my_filt(filter_emg_data(:,1),500,2000,1); %low pass
            plot(filter_emg_data,'r')
            title(name_muscle)
            x0=10;
            y0=10;
            width=2000;
            height=400;
            set(gcf,'position',[x0,y0,width,height])
            pause
            hold on
            close gcf
           
            
            
            
            
            
            
               
            
           %96 total rows, every 4 muscles per sheet, 8 sheets per file = 96 columns of data
           %sheet1(TA > GC > BF > RF) / sheet2( TA > GC > BF >RF) 
           %raw data entered
           raw_vals (:,(name_index-1)*32+(sheet_index-1)*4+filter_index) = emg_data_muscle(:,1); 
           %index variables need to be within the loop at the end to allow for indexing 
           filter_index = filter_index+1;                          
           
        end
        
           
           
           
           
           sheet_index = sheet_index+1;
    end
            
            
            
            
            
            
            
            %plot(filter_vals(1:20000,ii),'g') %visualize filtered data
            %pause
            %hold off
            %(name_index-1)*8+filter_index+sheet_index)
            

        
        
                  

        
    name_index = name_index+1;
    
end
    
  






%RMS to finish linear envelope
[filterval_rows, filterval_col] = size(raw_vals);
RMS_index =  1;
for RMS = 1:filterval_col
    
    filt_vals_for_RMS = mean(raw_vals(:,RMS).^2);
    RMS_EMG_vals = filt_vals_for_RMS.^.5;
    
    
    processed_RMS (1, (RMS_index-1)+1) = RMS_EMG_vals;
    
    RMS_index = RMS_index+1;
end
%extract RMS for TA vals; 1st data points and every 4th
%8 rows : c1
%8 rows : c2
%8 rows : c3
TA_RMS_EMG = processed_RMS(:,1:4:end);
TA_RMS_EMG = TA_RMS_EMG';
%extract RMS for TA vals; 2nd data points and every 4th
GC_RMS_EMG = processed_RMS(:,2:4:end);
GC_RMS_EMG = GC_RMS_EMG';
%extract RMS for TA vals; 3rd data points and every 4th
BF_RMS_EMG = processed_RMS(:,3:4:end);
BF_RMS_EMG = BF_RMS_EMG';
%extract RMS for TA vals; 4th data points and every 4th
RF_RMS_EMG = processed_RMS(:,4:4:end);
RF_RMS_EMG = RF_RMS_EMG';

%Change subject number 
filename = 'subject16_TA_RMSdata.xlsx';  
writematrix(TA_RMS_EMG, filename, 'Sheet',1,'Range','A1')
   
filename = 'subject16_GC_RMSdata.xlsx';
writematrix(GC_RMS_EMG, filename, 'Sheet',1,'Range','A1')

filename = 'subject16_BF_RMSdata.xlsx';
writematrix(BF_RMS_EMG, filename, 'Sheet',1,'Range','A1')  

filename = 'subject16_RF_RMSdata.xlsx';
writematrix(RF_RMS_EMG, filename, 'Sheet',1,'Range','A1')


