%read in EMG file
%All EMG trials are 1 minute worth of data
clear all
clc
close (gcf)


%%%% indicates areas to change the feet

%Create file name for indexing
name_index = 1;
%constants for indexin g
%change subject number for initial fprint and for filenames - line 190
fprintf('Participant 1 \n')

%BW = msgbox("Please enter the participant's bodyweight");



GRFHz = 200; 
%create an area with each file name as a string - MATLAB will not read it
%unless it is in a string  
%"noBWS.xlsx","0%.xlsx","20%.xlsx", 
for name = ["noBWS.xlsx", "0%.xlsx", "20%.xlsx", "40%.xlsx"]

    %display file name to keep track
    fprintf(name)
    %Create index for every sheet, create string
    sheet_index = 1;
    
    for sheet = ["t1", "t2", "t3","t4","t5","t6"]
        %display sheet name to keep track
        fprintf(sheet) 
        %Read in data and sheet name    
        data = xlsread(name,sheet);
        %create full time column for data visualization
        %time_full = length(data);
        %time_full = 0:1/GRFHz:(time_full-1)/GRFHz;
        %time_full = time_full';

        

        %column 4 is NAN
        loadsol_data_leftfoot = data(:, 2:4); 
        loadsol_data_rightfoot = data(:,6:8);
        %40% of the sensor is the rearfoot, 60% of the sensor is the
        %forefoot
        %Rearfoot is column 2, Forefoot is column 3 for left
        %Rearfoot is column 3, Forefoot is column 2
        
        %%%%%% RIGHT FOOT has heel in second column
        rearfoot_data = loadsol_data_rightfoot(:,2);
        forefoot_data = loadsol_data_rightfoot(:,1);
        %%%%change feet
        [data_row, data_col] = size(loadsol_data_rightfoot);
        %%%%    
        
        
        Bothfeet_data = [loadsol_data_leftfoot(2:end, 3), loadsol_data_rightfoot(2:end, 3)];
        Bothfeet_data = Bothfeet_data(1:6000,:);
        timeLength = length(Bothfeet_data);
        time_bothfeet = 0:1/GRFHz:(timeLength-1)/GRFHz;
        time_bothfeet = time_bothfeet'; 
        
        Bothfeet_data = [time_bothfeet Bothfeet_data];



        %Grab and plot out 30 seconds
        
        rearfoot_data = rearfoot_data(1:6000,1);
        forefoot_data = forefoot_data(1:6000,1);
        timeLength = length(rearfoot_data);
            time = 0:1/GRFHz:(timeLength-1)/GRFHz;
            time = time';
        %plots for visualization
        %plot(forefoot_data)
        %title('30 seconds of forefoot GRF')
        %hold on
        %pause
        %hold off
        %plot(rearfoot_data)
        %title('30 seconds of rearfoot data')
        %hold on
        %pause
        %hold off
        
                
        %plot(loadsol_data_right)
        %hold on
        %pause
        %hold off
        
        %Contact time for first 30 seconds
        Stance = 30;
        %StanceGRF = find(loadsol_data_right>Stance);
        %GRFstance1st = first10_GRF(first10_GRF>Stance);
        %GRFstanceLast = last10_GRF(last10_GRF>Stance);
        
        %plot(GRFstance1st)
        %pause
        %hold off
        
        %plot(GRFstanceLast)
        %pause 
        %hold off
        
        
        
        
        
        numberofstrides = 10;
        fprintf(1,'\n');
       
        for i = 1:numberofstrides
            
        %%%%average GRF data - switch to left when doing other foot
        GRF_data = loadsol_data_rightfoot(1:6000,3);
        GRF_data_left = loadsol_data_leftfoot(1:6000,3);
        
        subplot(3,1,1)
        plot(time, GRF_data, 'bo')  
        title('Pick 10 consecutive peaks', i)
        xlabel('time')
        ylabel('force')
        x0=10;
        y0=10;
        %Set graphs larger for clicking
        width=2000;
        height=400;
        set(gcf,'position',[x0,y0,width,height])
        hold on

        
        plot(time, GRF_data_left, 'go')  


        subplot(3,1,2)
        plot(time, GRF_data, 'bo')  
        hold on
        pause
        %brings up graphs to click for the peak
        fprintf(' Click on the Impact Peak\n')
            %searchwindow = 135;
            %[xpos,ypos] = ginput(1);
            %returns the row # for time with each click
            %GRF_time = round(xpos*GRFHz);
            
            %start = GRF_time - searchwindow;
                %if (start <1)
                   %start = 1;
                %end
            %vGRFmax = max(GRF_data(start:GRF_time+searchwindow))
                        %Stance = GRF_data(start:GRF_time+searchwindow);
            %time_for_stance = time(start:GRF_time+searchwindow);
            %Stance_GRF_time = [time_for_stance,Stance];
            
            %calculate start and endpoints for walking curve
            searchwindow = 100;
            [xpos,ypos] = ginput(1);
            GRF_time = round(xpos*GRFHz)
            
                %half_searchwindow = floor(searchwindow / 2);
                if (GRF_time - searchwindow) < 1
                    start = 1;
                else 
                    start = max(1, GRF_time - searchwindow);
                end
                
                end_point2 = GRF_time + searchwindow;
                
                               
                [vGRFmax,vGRFpos] = max(GRF_data(start:end_point2));
                vGRFpos = vGRFpos+start-1;
                timeofvGRF = vGRFpos/GRFHz;

                end_point_temp = find(GRF_data(vGRFpos:end)<10);
                end_point = start+end_point_temp(1)+vGRFpos-1;

                Stance = GRF_data(start:end_point2);
                
                
           
                %vGRFmax = max(GRF_data(start:end_point));
                %Stance = GRF_data(start:end_point);
                Contact_time = time(start:end_point2);
                
            
            %threshold for selecting stance data = 20N originally, however
            %30 will avoid some of the noise present and grab accurate
            %footstrikes

            grf_start_IDX = find(Stance>30,1);
            grf_end_IDX = find(Stance>30,1, 'last');

            determine_stance = Stance(grf_start_IDX:grf_end_IDX);
            %need the location of these rows for the time
            
           
                
            grfx = grf_start_IDX+start-1;
            grfend = grf_end_IDX+start-1;
         
            %while true
                    %if Stance >= 20
                        %determine_stance = [Stance, GRF_data]
                    %else 
                        %break;
                    
                    %end
            %end 
            %You also need to determine the time column along with the vGRF
            
            %create time index to find the correct time points
            startIDX = find(Stance>30, 1); %first true value
            endIDX = find(Stance>30,1, 'last'); %Last true value
            
    
            %use the index to find the time points
            determine_stance_time = Contact_time(startIDX:endIDX);
            %test = [time GRF_data]
            
            


            
            %Create a new time column for the full GRF data
            %This time column will locate the footstrike in the GRF data
            %set ->double support time
            timeLength = length(GRF_data);
            GRFdata_time = 0:1/GRFHz:(timeLength-1)/GRFHz;
            GRFdata_time = GRFdata_time';  
            %Find the footstrike time and GRF point: find_footstrike
            find_footstrike = determine_stance_time(1,1);
            find_footstrike = find(GRFdata_time == find_footstrike);
            find_footstrikeforGRF = GRF_data(find_footstrike,1);
            

            %find toeoff time: find_toeoff
            find_toeoff = determine_stance_time(end,1);
            find_toeoff = find(GRFdata_time == find_toeoff);
            find_footstrikeforGRF = GRF_data(find_toeoff,1);
                 
            %Now I can use find_footstrike:find_toeoff in my large data set
            %Call Bothfeet_data a 6000,3 time, Leftfoot, right foot
            %I need the points where BOTH columns are greater than 30N

            double_support = Bothfeet_data(find_footstrike:find_toeoff,:);
            %Now remove the time column to find the columns that meet the
            %threshold
            double_supportTIME = double_support(:,1);
            double_supportGRF = double_support(:, 2:3);
            %find the rows where both columns are >20
            rowsAboveThreshold = (double_supportGRF(:,1) > 30) & (double_supportGRF(:,2) > 30);
            


            doubleSupportPhase = double_supportGRF(rowsAboveThreshold,:);
            doubleSupportPhaseTime = double_supportTIME(rowsAboveThreshold,:);
            %This variable is to test for the time values pulled and
            %compare
            %I confirmed in excel the time values are correct so it is
            %commented out
            %doubleSupportPhaseLength = double_supportTIME(rowsAboveThreshold)
           
            %Now I just need the total length of the time in double support
            %timeLength = length(data);
            %time_full = 0:1/GRFHz:(timeLength-1)/GRFHz;
            %time_full = time_full';
            
            %Grab the length of the rows above the threshold
            doubleSupportPhaseDuration = length(doubleSupportPhase);
            doubleSupportPhaseDuration = 0:1/GRFHz:(doubleSupportPhaseDuration-1)/GRFHz;
            doubleSupportPhaseDuration = doubleSupportPhaseDuration';
            %Matlab code is adding a 0 data point, but the time does not
            %start from zero
            %Need to subtract out one frame to get the accurate time
            doubleSupportPhaseDuration = doubleSupportPhaseDuration(end,1)-.005;
            
            subplot(3,1,1)
            temp = ones(length(doubleSupportPhaseTime));
            temp = temp*100;

            plot(doubleSupportPhaseTime, temp, 'kx')

            subplot(3,1,2)
            plot(timeofvGRF,vGRFmax, 'mo')
            legend('GRF','vGRF max')
            hold on
            
            plot(time(grfx:grfend), GRF_data(grfx:grfend), 'r')
            %plot(time(grf_start_IDX:grf_end_IDX), GRF_data(grf_start_IDX:grf_end_IDX), 'r')
            pause 
            
            subplot(3,1,3)
            plot(determine_stance_time, determine_stance,'r')
            legend('Contact time')
            hold on
            pause
            hold off
            
            
           

            %Find the vGRF values for footstrike and toeoff for footstrike
            %index
            footstrike_vGRF = determine_stance(1,1);
            toeoff_vGRF = determine_stance(end,1);
            %find times for stride rate calculations    
            time_for_footstrike = determine_stance_time(1,1);
            time_for_toeoff = determine_stance_time(end,1);
            %calculate contact time to live the dream
            StanceDuration = time_for_toeoff - time_for_footstrike;
            
            %use footstrike time for the index
            time_for_footstrike_idx = find(time_for_footstrike == time)
            rearfoot_data_stance = rearfoot_data(find_footstrike:find_toeoff,:);
            forefoot_data_stance = forefoot_data(find_footstrike:find_toeoff,:);
            %Find the correct rearfoot row above 30
            rowsAboveThresholdRF = (rearfoot_data_stance(:,1) > 30);
            value_for_RFidx = rearfoot_data_stance(rowsAboveThresholdRF,:);
           
            rearfoot_index = rearfoot_data(time_for_footstrike_idx,1)/footstrike_vGRF;
            
            

            %Now that the row number for time has been found, use that to
            %determine the footstrike index
            %[time_row,time_col] = find(time==time_for_footstrike);
            
            %Find the percentage at which footstike is rearfoot vs forefoot
            %rearfoot_index = rearfoot_data(time_for_footstrike_idx,1)/footstrike_vGRF;
            

            

            %rearfoot dominant in the loadsol, use only the rearfoot for
            %indexing
            %forefoot_index = forefoot_data(find_footstrike,1)/footstrike_vGRF;

      
            
            %Loading Rate code is not used during walking
            %Time that max GRF occurs
            %maxtime = GRF_time*.001;
            
            %determine stance time 
            stance_timeLength = length(determine_stance);
            stance_time = 0:1/GRFHz:(stance_timeLength-1)/GRFHz;
            stance_time = stance_time';
            %min-max time normalization
            %stance_time_min = min(stance_time);
            %stance_time_max = max(stance_time);
            %normalize_stance_time = (stance_time- stance_time_min)./ stance_time_max;
            %normalize_stance_time = round(normalize_stance_time,2);
            %This code finds a value close to 3% and 12% IF it is not
            %present in the dataset. 
            %min_VAL = .03;
            %[minVAL, closestIndex] = min(abs(normalize_stance_time - min_VAL));
            %lower limit
            %closestValue_min = normalize_stance_time(closestIndex);
            %max_VAL = .12;
            %[maxVAL, closestIndex] = min(abs(normalize_stance_time - max_VAL));
            %upperlimit
            %closestValue_max = normalize_stance_time(closestIndex);        
            %plot(normalize_stance_time,LR_vGRF_vals)
            %Loading rate calculation - mean of 3-12% of stance phase from
            %the values above (closetValue_min and closetValue_max)
            %LR_time_data = normalize_stance_time(:,1);
            %find row numbers for time vals to extract time and vGRF
            %LR_time_vals_row = find(LR_time_data >= closestValue_min & LR_time_data <= closestValue_max);
            %LR_time_vals = LR_time_vals_row.*.01;
            %LR_vGRF_vals = determine_stance; 
            %find_LR_vGRF_vals = ismember(1:size(LR_vGRF_vals,1),LR_time_vals_row);
            %extracted_LR_vGRF_vals = LR_vGRF_vals(find_LR_vGRF_vals,:);
            %Now solve for the loading rate
            %LoadingRate = mean(LR_vGRF_vals)/mean(LR_time_vals);
            %LR_vals (((name_index-1)*8) + sheet_index,i) = LoadingRate;

            %swing phase: footstrike -> toe off
            stance_duration_vals (((name_index-1)*8) + sheet_index,i)= StanceDuration; 
            double_support_vals (((name_index-1)*8) + sheet_index,i) = doubleSupportPhaseDuration;
            time_vals_footstrike (((name_index-1)*8) + sheet_index,i) = time_for_footstrike;
            time_vals_toeoff (((name_index-1)*8) + sheet_index,i) = time_for_toeoff;
            GRF_vals (((name_index-1)*8) + sheet_index,i) = vGRFmax;

            %store footstrike index percentages
            %10 foot strikes - rows
            %Each "trial" column; 8 per person 24 total
            %omit forefoot for now, indexing will be based on movement from
            %rearfoot. 1-rearfoot = forefoot index
            %forefoot_index_vals (((name_index-1)*8) + sheet_index,i) = forefoot_index;
            rearfoot_index_vals (((name_index-1)*8) + sheet_index,i) = rearfoot_index;

                %Conditional formatting for the first array
                if i == 1
                % on the first iteration, set the cell to another cell array
                    stance_vals{((name_index-1)*8) + sheet_index} = {};
                end
            %Store all arrays past the first for each click
            %Each click will be it's own cell
            stance_vals{((name_index-1)*8) + sheet_index}{i} = determine_stance;
            %5 clicks = 1x5 cell for each trial. columns 1-8 = condition
            %100%; 9-17 80%; 18-26 60%
            
            
                        
        
        end
        
        hold off
        hold off
        close gcf
        
            
        
        
        
        
                
         
        
        
               
            
          
           %filter_vals (1:40000,(name_index-1)*32+(sheet_index-1)*4+filter_index) = filter_emg_data(1:40000,1); 
           %index variables need to be within the loop at the end to allow for indexing 
           %filter_index = filter_index+1;                          
        sheet_index = sheet_index+1;
        
     end
        
           
           
           
       name_index = name_index+1;    
           
end
  





