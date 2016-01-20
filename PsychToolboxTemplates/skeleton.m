function skeleton

    %
    % Adapted after "Psychtoolbox\PsychHardware\EyelinkToolbox\EyelinkDemos\
    % ShortDemos\EyelinkExample.m"
    %
    %  categorization study, show image and get left/right keypress from
    %  participant to enter response.  record response time and accuracy in
    %  result file.


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
    fprintf( fID, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', ...
                'trial', 'stimulus', 'pressRight', 'pressLeft', ...
                'catLabel', 'rctTime', 'acc', 'leftResponse', 'isChild', 'fullImgFile');    
  


%%%%%%%%%%%  RANDOMIZE AND LOAD STIUMULUS INFO  %%%%%%%%%%%%%%%% 

    % get stimulus image folders used for the trials
    pracFolder = 'Practice/';
    imgFolder = {'Trees/', 'Trees2OutShift/', 'TreesHardShift/'};
    % randomize blocks to counterbalance conditions
    imgFolder = Shuffle( imgFolder); 


    % load and shuffle practice image names in data structure
    pracImages = Shuffle( dir( [pracFolder 'cat*'])); %assume names start with cat
    pN = length(pracImages); % number of practice images
    
    % pre-allocate cells to store just file names and category labels
    % of practice block (as 1 or 2)
    pracImgList = cell( pN,1);
    pracCatLabels = ones(pN,1); 
    for i1 = 1:pN
        pracImgList{i1} = [ pracFolder pracImages(i1).name ]; 
        if strcmp(pracImages(i1).name(1:4), 'cat2')
            pracCatLabels(i1) = 2;
        end
    end

    
    images = [];  %create empty arrays
    catLabels = [];
    imageList = [];
    
    % loap through all image folders ( diff folders of images for diff blocks)
    for i2 = 1:length( imgFolder ) 
        thisImages = Shuffle( dir( [imgFolder{i2} 'cat*.png'])); % get and shuffle image struct
        N = length(thisImages); % store number of images
        
        % now get just image names and put in cell (just names, not struct)
        % and also set the category label (1 or 2)
        thisImageList = cell( N,1);
        thisCatLabels = ones(N,1); 
        for i1 = 1:N
            thisImageList{i1} = [ imgFolder{i2} thisImages(i1).name ];
            if ~strcmp(thisImages(i1).name(1:4), 'cat1')
                thisCatLabels(i1) = 2;
            end
        end
        
        % create a big cell that has all the trials combined (all blocks)
        images = [images;thisImages];
        catLabels = [ catLabels;  thisCatLabels];
        imageList = [imageList; thisImageList];
    end

    N = length( imageList); % total number trials
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % determine stimulus display size
    stimSz = size( imread(imageList{1} ));  %making sure getting real images, not practice images
    stimSz(1:2) = stimSz(1:2)*1.75;  % scale up by 1.75%
    
    % combine practice and real trials
    images = [pracImages; images ];
    catLabels = [ pracCatLabels; catLabels];
    imageList = [ pracImgList; imageList];

    % counterbalance the left/right target placement of categories
    responseSides = Shuffle([1 2]); % responseSides(1) goes left, responseSides(2) goes right

%     % load up feedback images
%     fbImg{1} = imresize( imread( '../FBStim/smile.png'), .75);
%     fbImg{3} = imresize( imread( '../FBStim/frown.png'), .75);
%     fbImg{2} = imresize( imread( '../FBStim/neutral.png'), .75);

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
        
        % determine stimulus rectangle size + position [left, top, right,
        % bottom], ( x,y) 
        stimRect = CenterRectOnPoint([0 0 stimSz(2) stimSz(1)], width/2, height/2);
    
        % initialize things
        endExp = 0;  % will check later if participant wants to quit early
        trials = [-1*ones(1,pN) 1:N];  %indicates -1 for practice, 1:N for real trials
        i1 = 1; %  trial index ( in case we want to repeat practice )
        
        % loop through every image
        while i1 <= length(trials)
            
            % initialize response on trial
            lookedLeft = 0;
            lookedRight = 0;

            % load stimulus for this trial
            imgfile= imageList{i1}; 
            imdata=imread(imgfile);

            % maybe display something when practice trials are over
            if trials(i1) == 1
                % something maybe...                
            end

            WaitSecs(0.1);
            FlushEvents()
            
            % show stimulus
            Screen('FillRect', window, [0,0,0]);          
            stimTexture=Screen('MakeTexture',window, imdata);        
            Screen('DrawTexture', window, stimTexture, [], stimRect);             
            Screen('Flip', window);

            % initialize timer for reaction time
            startTime = GetSecs();
            selectTime = startTime;


            % now monitor participant response
            FlushEvents()
            while 1 % loop till error or keypress
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

            % clear screen
            Screen('FillRect', window, [0,0,0]);
            Screen('Flip', window);                                     

            %-----------------------
            % update reaction time and accuracy             
            rctTime =  selectTime - startTime;
            if ~lookedLeft && ~lookedRight  % skipped trial
                acc = -1;
            % correct left response
            elseif lookedLeft && ( catLabels(i1) == responseSides(1)  )    
                acc = 1;
            % correct right res[pmse
            elseif lookedRight && ( catLabels(i1) == responseSides(2)  )
                acc = 1;
            % incorrect    
            else
                acc = 0;
            end
            %-----------------------
            
            % export trial results to a file
            fprintf( fID, '%d\t%s\t%d\t%d\t%d\t%f\t%d\t%d\t%d\t%s\n', ...
                trials(i1), images(i1).name, lookedRight, lookedLeft, ...
                catLabels(i1), rctTime, acc, responseSides(1), isChild, imgfile);           
            
            
            %--------------------------
            % MAYBE put a feedback screen here
            
            
            
            
            
            %----- allow participant to control feedback duration
            WaitSecs(.15);
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
            %-------------------------------------------


            % if escape key hit, end experiment
            if endExp 
                break;
            end


            % if wrong(or no answer) on practice trial, redo that practice trial
            if acc ~= 1 && trials(i1) == -1; i1 = i1-1; end     
            i1 = i1+1;


        end % end loop of all trials  


        % close text result file
        if dummymode
            fclose(fID);
        end
        

        % debriefing
        WaitSecs(0.1);
        Screen('FillRect', window, el.backgroundcolour); 
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


