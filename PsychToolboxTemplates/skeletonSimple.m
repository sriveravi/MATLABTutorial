function skeletonSimple

    %
    % Adapted after "Psychtoolbox\PsychHardware\EyelinkToolbox\EyelinkDemos\
    % ShortDemos\EyelinkExample.m"
    %
    %  categorization study, show image and get left/right keypress from
    %  participant to enter response.  record response time and accuracy in
    %  result file.

    
    %%%%% FOLLOWING LINES SETUP EXPERIMENT/PSYCHTOOLBOX THINGS, SEE COMMENTS
    %%%%%% TO UNDERSTAND WHAT THEY DO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    clear all;
    rng('shuffle')  % seeds random number generator based on current time
    commandwindow;
    PsychDefaultSetup(1);

    % create directory to save results
    saveDir = 'Results/';
    if ~exist( saveDir, 'dir'); mkdir( saveDir); end

    % define keyboard things
    DisableKeysForKbCheck([ 194]); %otherwise won't stop ( some computers are funny with numlock/capslock,etc.)
    KbName('UnifyKeyNames')
    stopkey=KbName('space');
    exitkey = KbName( 'q');  %escape
    leftkey = KbName( 'leftarrow');
    rightkey = KbName( 'rightarrow');

    
    % Popup file to enter information
    prompt = {'Participant ID number? (4 digit number)', 'Is participant a child? (y or n)'}; %, 'Eye tracking? (y o n)'};
    dlg_title = 'Player Status';
    num_lines= [1;1]; 
    def     = { '0000','y', 'n', 'y'};
    answer  = inputdlg(prompt,dlg_title,num_lines,def);  % stores inputs
    

    % if a child, less trials 
    if strcmpi( answer{2}, 'y' )
        isChild =1;
        fprintf( 'Child playing.\n');
        % maybe you will do something child specific
    else
        isChild = 0;
    end
    
    
    % open file for saving result
    resFile = [ saveDir 'result' answer{1} '.txt']; %filename
    fID = fopen(resFile, 'w');    % MATLAB fileID
    
    % write column labels to file
    fprintf( fID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
                'trial', 'stimulus', 'pressRight', 'pressLeft', ...
                'catLabel', 'rctTime', 'acc', 'isChild', 'fullImgFile');    
  


%%%%%%%%%%%  RANDOMIZE AND LOAD STIUMULUS INFO  %%%%%%%%%%%%%%%% 

    % stimulus image folders 
    imFolder = 'Practice/';

    % load and shuffle practice image names in data structure
    imageList = Shuffle( dir( [imFolder '*.jpg'])); %assume names end in .png
    N = length(imageList); % number of  trails is number stimuli
    
    % create vector of corresponding category labels
    catLabels = ones( 1,N);  % assuming all category 1 (you must define properly)
   
 
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    try 

        % STEP 2
        % Open a graphics window on the main screen
        % using the PsychToolbox's Screen function.
        screenNumber=max(Screen('Screens'));
        [window, wRect]=Screen('OpenWindow', screenNumber, 0,[],32,2);
        Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        % Hide the mouse cursor 
        Screen('HideCursorHelper', window);
        [width, height]=Screen('WindowSize', screenNumber);
        
        % Disable key output to Matlab window:
        ListenChar(2);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% show welcome screen %%%%%%%%%%%%%%%
        if isChild;  
            msg ='child Welcome text'; 
        else
            msg = 'adult Welcome text';
        end        
        
        instSize= 25; % set text size
        oldTextSize=Screen('TextSize', window, instSize); 
        DrawFormattedText(window, msg, width/9, height/8, 255, 50); 
        Screen('Flip', window, [],1);  %flip screen to show it
        Screen('TextSize', window, oldTextSize); % restore text size
        WaitSecs(0.5); % pause
        FlushEvents();  % to clear keyboard que
        KbWait();  % wait for keypress
        
        Screen('FillRect', window, [0,0,0]);  % fill black screen 
        WaitSecs(0.05);  

%%%%%%%%%%%%%%%%  Trials time %%%%%%%%%%%%%%
        

        endExp = 0;  % will check later if participant wants to quit early
        
        % loop through every image
        for i1 = 1:N
            
            % initialize response on trial
            lookedLeft = 0;
            lookedRight = 0;

            % load stimulus for this trial
            imgfile= [ imFolder, imageList(i1).name ];  % file name
            imdata=imread(imgfile); % load file function

            % small pause and clear keyboard queue
            WaitSecs(0.1);
            FlushEvents()
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%  show stimulus %%%%%%%%%%
            Screen('FillRect', window, [0,0,0]);      % make background black
            stimTexture=Screen('MakeTexture',window, imdata);  % make texture     
            Screen('DrawTexture', window, stimTexture, []);  % draw texture to window           
            Screen('Flip', window);   % 'flip' to show it instantly

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            % initialize timer for reaction time
            startTime = GetSecs();
            selectTime = startTime;


            % now monitor participant response
            FlushEvents()
            while 1 % loop untill error or keypress
                % check for keyboard press
                [keyIsDown,secs,keyCode] = KbCheck;

                % if spacebar was pressed skip trial
                if keyCode(stopkey)  
                    break;
                end

                % terminate experiment early
                if keyCode(exitkey)
                    endExp = 1;
                    break;
                end

                % enter left/right on keyboard
                if keyCode(leftkey)
                    lookedLeft = 1;
                    lookedRight = 0;
                    break;
                end            
                if keyCode(rightkey)
                    lookedLeft = 0;
                    lookedRight = 1;
                    break;
                end

               % for reaction time
               selectTime = GetSecs();
            end % end checking for keypress       

            % clear screen (make black)
            Screen('FillRect', window, [0,0,0]);
            Screen('Flip', window);                                     

            %-----------------------
            % update reaction time and accuracy             
            rctTime =  selectTime - startTime;
            acc = 1;  % always right, you must code what you want 

            %-----------------------
            
            % export trial results to a file
            fprintf( fID, '%d\t%s\t%d\t%d\t%d\t%f\t%d\t%d\t%s\n', ...
                i1, imageList(i1).name , lookedRight, lookedLeft, ...
                catLabels(i1), rctTime, acc, isChild, imgfile);           
            
            

        %%%%%%%%%%%%%%%% put a feedback screen here %%%%%%%%%%%%%%%

            msg = 'press space TO CONDINUE!!!';

            instSize= 25; % set text size
            oldTextSize=Screen('TextSize', window, instSize); 
            DrawFormattedText(window, msg, width/9, height/8, 255, 50); 
            Screen('Flip', window, [],1);  %flip screen to show it
            Screen('TextSize', window, oldTextSize); % restore text size
            WaitSecs(0.15); % pause
            FlushEvents();  % to clear keyboard que
            KbWait();  % wait for keypress

            Screen('FillRect', window, [0,0,0]);  % fill black screen 
            WaitSecs(0.05);  


            %----- allow participant to control feedback duration
            FlushEvents()
            while 1 % loop till space bar is pressed  or selection                   
                if endExp
                    break;
                end

                % check keyboard press
                [keyIsDown,secs,keyCode] = KbCheck;
                % if spacebar was pressed stop display
                if keyCode(stopkey)
                    break;
                end

                % check for want to end experiment
                if keyCode(exitkey)
                    endExp = 1;
                    break;
                end
            end

           %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     

            % if exit experiment key hit, end experiment (exit for loop)
            if endExp 
                break;
            end

        end % end loop of all trials  


        % close text result file
        fclose(fID);      

        % debriefing
        WaitSecs(0.1);
        Screen('FillRect', window, [0,0,0]); 
        % make a debriefing screen 

        cleanup;


    catch
         %this "catch" section executes in case of an error in the "try" section
         %above.  Importantly, it closes the onscreen window if its open. 
         x = lasterror
         x.stack
         cleanup;
    %      Eyelink('ShutDown');
    %      Screen('CloseAll'); 
    %      commandwindow;
    %      rethrow(lasterr);
    end %try..catch.
end

% Cleanup routine:
function cleanup

    Snd('Close');
    sca;
    commandwindow;

    % Restore keyboard output to Matlab:
    ListenChar(0);
end


