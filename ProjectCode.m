%read in EMG file
%All EMG trials are 1 minute worth of data
clear all
clc
close (gcf)

%Create file name for indexing
name_index = 1;



%create an area with each file name as a string - MATLAB will not read it
%unless it is in a string
for name = ["C1.xlsx","C2.xlsx","C3.xlsx"]
    
    %Create index for every sheet, create string
    sheet_index = 1;
    for sheet = ["t1", "t2",  "t3","t4","t5","t6","t7","t8"]
       
        %Read in data and sheet name    
        data = xlsread(name,sheet);

        emg_data = data(:, 3:6); 
        
        %plot(emg_data)
        
        %pause
        %rectify EMG data -> full wave rectify signal
        
        emg_data = rmmissing(emg_data);
        
        
        %remove NaN values
         
        %Butterworth bandpass filter, set to cutoff of 30-500 HZ
        %Nyquist frequency = 2000/2 - normalize signal
        [row_emg,column_emg] = size(emg_data);
        %plot(emg_data)
        
        %hold on
        
        
        filter_index = 1;
        for muscle_sensor = (1:column_emg)
            emg_data(:,muscle_sensor) = emg_data(:,muscle_sensor) - mean(emg_data(:,muscle_sensor)); %demean / remove dc bias
            
            if muscle_sensor == 1
                name_muscle = "Rectus Femoris";
            elseif muscle_sensor == 2
                name_muscle = "Biceps Femoris";
            elseif muscle_sensor ==3
                name_muscle = "Gastrocnemius";
            elseif muscle_sensor == 4
                name_muscle = "Tibialis Anterior";
            end
            
            %emg_data(:,muscle_sensor) = abs(emg_data(:,muscle_sensor)); %rectify
            plot(emg_data(1:20000,muscle_sensor),'k') %visualize raw data
            title(name_muscle)
            pause
            hold on
            
            filter_emg_data(1:20000,muscle_sensor) = my_filt(emg_data(1:20000,muscle_sensor), 30, 2000, 2); %high pass
            plot(filter_emg_data,'g')
            title(name_muscle)
            pause
            hold on
            %filter_emg_data = abs(filter_emg_data);
            
            filter_emg_data(1:20000,muscle_sensor) = my_filt(filter_emg_data(1:20000,muscle_sensor),500,2000,1); %low pass
            plot(filter_emg_data,'r')
            title(name_muscle)
            pause
            hold on
            
            
            filter_emg_data = abs(filter_emg_data);
            plot(filter_emg_data,'b')
            title(name_muscle)
            pause
            hold off
            
            %fs = 2000; %sampling frequency
            %fn = 1000; %Nyquist frequency
            %f_low = 15;
            %f_high = 500;
            
            %wp = [30 495]/fn; %passband frequency in radians
            %ws = [28 498]/fn; %stopband frequency in radians
            
            %rp = 1; %passband ripple (dB)
            %rs = 130; %stopband attenuation (dB)
            
            %[n,wp] = ellipord(wp,ws,rp,rs);                                  % Calculate Filter Order
            %[z,p,k] = ellip(n,rp,rs,wp,'bandpass');                         % Default Here Is A Lowpass Filter
            %[sos,g] = zp2sos(z,p,k);                                         % Use Second-Order-Section Implementation For Stability
            
            %[bb,aa] = butter(2,f_low/(fs/2));
            %[b,a] = butter(4, [30 500]/(2000/2));
            %freqz(sos,2^14,fs); % Bode plot of filter
            %filter_emg_data = filtfilt(sos,g,emg_data(1:20000,ii));
            
            %plot(filter_emg_data)
            %pause  
            
            
            
            filter_vals (1:20000, (name_index-1)*8+(sheet_index-1)*4+filter_index) = filter_emg_data(:,muscle_sensor);
            
            
            
            %plot(filter_vals(1:20000,ii),'g') %visualize filtered data
            %pause
            %hold off
            %(name_index-1)*8+filter_index+sheet_index)
            filter_index = filter_index+1;
        end
        
        
        
        %f_low = 30;
        %f_high = 500;
        %fs = 2000; 
        %[b,a] = butter(2,f_low/(fs/2));
        %[b,a] = butter(4, [f_low f_high]/(fs/2), 'bandpass');
        %freqz(b,a,[],fs);

        
       
        
        %Create time column
        EMGhz = 2000;
        %convert from frames to time for c1
        timeLength = length(emg_data(:,1));
        time = 0:1/EMGhz:(timeLength-1)/EMGhz;
        %transpose
        time = time';


        %obtain maximal value to normalize across trial for each subject/muscle
        %15 - RF, 16 - BF, 17 - GC, 18 - TA
        [row_max, column_max] = size(filter_emg_data);
        for max_val_loop = (1:column_max)
            filter_data_column = filter_emg_data(:,max_val_loop);
            %variable name for storage
            normEMG = max_val_loop;

            maxData = max(filter_data_column);


            %8 sheets, keeps it from over writing sheets values
            %1-1 = 0; row are trials: 1-8 c1, row 9-16 c2, 17-24 c3
            %Columns of EMG_vals are seperate files
            EMG_max_vals ((name_index-1)*8+sheet_index,normEMG) = maxData;
            

        end
        sheet_index = sheet_index+1;
    end
    
    name_index = name_index+1;

end
 %normalize to maximal value across trial for each subject/muscle
        %Column1;15 - RF, Column2;16 - BF, Column3;17 - GC, Column4;18 - TA

%Raw data plotted for 10 seconds   
%visualize = filter_emg_data(1:20000,:);
%visual_t = time(1:20000,:);
%subplot(1,1,1), plot(visual_t, visualize)



col_index = 1;


[column_max,d] = size(filter_vals);

C1_EMG_max_vals = EMG_max_vals(1:8,:);
C2_EMG_max_vals = EMG_max_vals(9:16,:);
C3_EMG_max_vals= EMG_max_vals(17:24,:);


test = filter_vals(:,1)./(EMG_max_vals(1,1));

for k = (1:d)
    
    col_data = k;
    
    for m = (1:column_max)
        row_max = m;
        for j = (1:y)
            emg = j;
            
    
    
            norm_data = filter_vals(:,k)./EMG_max_vals(j,k);
        
    
            EMG_store(col_index,col_data) = norm_data;
        
           
        
         
        end
    end
   
   
    
    col_index = col_index+1; 
end

%plot(time(1:20000,:),norm_data(1:20000,:))
