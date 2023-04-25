%read in EMG file
%All EMG trials are 1 minute worth of data
clear all
clc
close (gcf)

%Create file name for indexing
name_index = 1;
%constants for indexing
%change subject number for initial fprint and for filenames - line 190
fprintf('subject 3\n')

GRFHz = 100; 
%create an area with each file name as a string - MATLAB will not read it
%unless it is in a string  
for name = ["s3_100.xlsx","s3_80","s3_60.xlsx"]
    %display file name to keep track
    fprintf(name)
    %Create index for every sheet, create string
    sheet_index = 1;
    for sheet = ["t1", "t2",  "t3","t4","t5","t6","t7","t8"]
        %display sheet name to keep track
        fprintf(sheet) 
        %Read in data and sheet name    
        data = xlsread(name,sheet);

        loadsol_data = data(:, 1:4); 
        
        
        [data_row, data_col] = size(loadsol_data);
        
        plot(loadsol_data(:,1),loadsol_data(:,4))
        title('Loadsol Data 60 seconds')
        hold on
        pause
        hold off
        
        %plot out first 10 seconds/last 10 seconds
        first10_GRF = loadsol_data(1:1000,4);
        plot(first10_GRF)
        title('First 10 seconds of Loadsol GRF')
        hold on
        pause
        hold off
        
        
        
        last10_GRF = loadsol_data(end-999:end,4); 
        plot(last10_GRF)
        title('Last 10 seconds of Loadsol GRF')
        hold on
        pause
        hold off
        GRF_reshape = [first10_GRF, last10_GRF];
        GRF_data = reshape(GRF_reshape, [], 1);
        plot(GRF_data)
        title('First and Last 10 seconds of Loadsol GRF')
      
        Stance = 20;
        StanceGRF_1st = find(first10_GRF>Stance);
        StanceGRF_Last = find(last10_GRF>Stance);
        
        GRFstance1st = first10_GRF(first10_GRF>Stance);
        GRFstanceLast = last10_GRF(last10_GRF>Stance);
        
        %plot(GRFstance1st)
        %pause
        %hold off
        
        %plot(GRFstanceLast)
        %pause 
        %hold off
        
        timeLength = length(GRF_data);
        time = 0:1/GRFHz:(timeLength-1)/GRFHz;
        time = time';
        
        
        
        numberofstrides = input('     How many strides? ');
        fprintf(1,'\n');
        for i = 1:numberofstrides
            
            
            
        plot(time, GRF_data)
        title('Pick the first 5 and the last 5')
        xlabel('time')
        ylabel('force')
        x0=10;
        y0=10;
        width=2000;
        height=400;
            set(gcf,'position',[x0,y0,width,height])
            hold on
         %brings up graphs to click for the peak
            fprintf('Click on the Impact Peak')
            searchwindow = 30;
            [xpos,ypos] = ginput(1);
            GRF_time = round(xpos*GRFHz);
            start = GRF_time - searchwindow;
                if (start <1)
                   start = 1;
                end
            vGRFmax = max(GRF_data(start:GRF_time+searchwindow))
            
            Stance = GRF_data(start:GRF_time+searchwindow);
            
           
            
            
            
            %threshold for selecting stance data = 20N
            determine_stance = Stance(Stance(:,1)>20,:);
            
            %Time that max GRF occurs
            maxtime = GRF_time*.001;
            
            %determine stance time 
            stance_timeLength = length(determine_stance);
            stance_time = 0:1/GRFHz:(stance_timeLength-1)/GRFHz;
            stance_time = stance_time';
            
            %Loading rate calculation - mean of 3-12% of stance phase
            LR_time_start = round(stance_timeLength*.03);
            LR_time_end = round(stance_timeLength*.12,1);
            
            LR_time = stance_time(LR_time_start:LR_time_end);
            GRF_LR = determine_stance(LR_time_start:LR_time_end);
            
            %Average of time and force for 3-12% of stance (absence of F1)
            LoadingRate = mean(GRF_LR)/mean(LR_time);

            plot(xpos,vGRFmax, 'mo')
            legend('GRF','vGRF max')
            hold on
            pause 
            hold off
            plot(determine_stance)
            pause
            LR_vals (((name_index-1)*8) + sheet_index,i) = LoadingRate;
            time_vals (((name_index-1)*8) + sheet_index,i) = maxtime;
            GRF_vals (((name_index-1)*8) + sheet_index,i) = vGRFmax;
            
                %Conditional formatting for the first array
                if i == 1
                % on the first iteration, set the cell to another cell array
                    stance_vals{((name_index-1)*8) + sheet_index} = {}
                end
            %Store all arrays past the first for each click
            %Each click will be it's own cell
            stance_vals{((name_index-1)*8) + sheet_index}{i} = determine_stance
            %5 clicks = 1x5 cell for each trial. columns 1-8 = condition
            %100%; 9-17 80%; 18-26 60%
             
            
            
            
            
            
        
        end
        
        close gcf
        
            
        
        
        
        
                
         
        
        
               
            
          
           %filter_vals (1:40000,(name_index-1)*32+(sheet_index-1)*4+filter_index) = filter_emg_data(1:40000,1); 
           %index variables need to be within the loop at the end to allow for indexing 
           %filter_index = filter_index+1;                          
        sheet_index = sheet_index+1;
     end
        
           
           
           
       name_index = name_index+1;    
           
end
            
     
            
            
            
            
           

        
        
                  

        
    
    

